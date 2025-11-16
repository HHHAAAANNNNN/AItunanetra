import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:aitunanetra/user_profile_page.dart';
import 'package:aitunanetra/setting_page.dart';
import 'package:flutter/gestures.dart';

class DashboardPage extends StatefulWidget {
  final bool loggedInSuccessfully; 

  const DashboardPage({super.key, this.loggedInSuccessfully = false});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isFlashOn = false; //default senter kamera mati
  bool _isMicOn = false; //default mikrofon mati
  bool _isSubtitleOn = false; //default subtitle mati
  final AudioPlayer _audioPlayer = AudioPlayer();
  FlutterTts flutterTts = FlutterTts();
  bool _showMenu = false; //default menu tertutup
  bool _showMenuItems = false; //default items di dalam menu belum muncul
  DateTime? _lastBackPressed; //untuk tracking double tap back button
  double _subtitleBoxHeight = 0.18; // Rasio tinggi subtitle box (default lebih kecil ~18%)
  bool _animateSubtitle = true; // Flag untuk mengontrol apakah perlu animasi atau tidak
  bool _isLongPressActive = false; // Track long press state

  @override
  void initState() {
    super.initState();
    
    // Ensure fullscreen mode is maintained
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
    
    _initializeCamera();
    _initAudioPlayer();
    _initializeTts();

    // Tampilkan notifikasi jika berhasil login
    if (widget.loggedInSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil Login!')),
        );
      });
    }
  }

  // Inisialisasi TTS untuk back button warning
  Future<void> _initializeTts() async {
    try {
      await flutterTts.setLanguage("id-ID"); // Indonesian
      await flutterTts.setSpeechRate(0.6); // Sedikit lebih cepat dari default
      await flutterTts.setVolume(1.0); // Volume
      await flutterTts.setPitch(1.0); // Pitch
    } catch (e) {
      // TTS engine not available
      _showMessage('TTS Engine tidak tersedia. Silakan install Google TTS atau Speech Services.');
    }
  }

  // Inisialisasi Audio Player
  void _initAudioPlayer() async {
    _audioPlayer.setVolume(1.0); // Default volume
    _audioPlayer.setReleaseMode(ReleaseMode.loop); //looping audio
  }

  // Play audio feedback untuk button actions (cepat dan singkat)
  Future<void> _playButtonFeedback(String message) async {
    try {
      await flutterTts.setLanguage("id-ID");
      await flutterTts.setSpeechRate(0.8); // Lebih cepat untuk feedback
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(message);
    } catch (e) {
      // If TTS fails, show visual message only
      _showMessage(message);
    }
  }

  // Play error audio feedback
  Future<void> _playErrorFeedback(String errorMessage) async {
    try {
      await flutterTts.setLanguage("id-ID");
      await flutterTts.setSpeechRate(0.7); // Slower for errors
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(0.9); // Slightly lower pitch for errors
      await flutterTts.speak(errorMessage);
    } catch (e) {
      // If TTS fails, show visual message
      _showMessage(errorMessage);
    }
  }

  // Toggle mikrofon on/off with permission check
  void _toggleMic() async {
    // Check microphone permission first
    var micStatus = await Permission.microphone.status;
    
    if (!micStatus.isGranted) {
      // Request permission
      var result = await Permission.microphone.request();
      
      if (!result.isGranted) {
        // Permission denied
        await _playErrorFeedback('Izin mikrofon ditolak. Buka pengaturan untuk mengaktifkan izin mikrofon.');
        return;
      }
    }

    // Haptic feedback untuk long press - strong and long
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    
    setState(() {
      _isMicOn = !_isMicOn;
    });
    _playButtonFeedback(_isMicOn ? 'Mikrofon hidup' : 'Mikrofon mati');
  }

  // Toggle subtitle on/off
  void _toggleSubtitle() {
    setState(() {
      _animateSubtitle = true; // Aktifkan animasi saat button ditekan
      _isSubtitleOn = !_isSubtitleOn;
    });
    _playButtonFeedback(_isSubtitleOn ? 'Subtitle hidup' : 'Subtitle mati');
  }

  // Inisialisasi Kamera
  Future<void> _initializeCamera() async {
    try {
      var status = await Permission.camera.request(); //request izin penggunaan kamera
      
      if (status.isGranted) {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          _cameraController = CameraController(
            _cameras![0], //default menggunakan kamera 0 (belakang)
            ResolutionPreset.medium,
            enableAudio: false,
          );

          _cameraController!.initialize().then((_) {
            if (!mounted) {
              return;
            }
            setState(() {});
          }).catchError((Object e) { //error handling jika akses kamera tidak diizinkan
            if (e is CameraException) {
              switch (e.code) {
                case 'CameraAccessDenied':
                  _playErrorFeedback('Akses kamera ditolak. Buka pengaturan untuk mengaktifkan izin kamera.');
                  break;
                default:
                  _playErrorFeedback('Terjadi kesalahan kamera. ${e.description}');
                  break;
              }
            }
          });
        } else {
          _playErrorFeedback('Tidak ada kamera tersedia pada perangkat ini.');
        }
      } else if (status.isDenied) {
        _playErrorFeedback('Izin kamera ditolak. Aplikasi memerlukan akses kamera untuk berfungsi.');
      } else if (status.isPermanentlyDenied) {
        _playErrorFeedback('Izin kamera ditolak secara permanen. Buka pengaturan aplikasi untuk mengaktifkan izin kamera.');
      }
    } catch (e) {
      _playErrorFeedback('Gagal menginisialisasi kamera. Coba restart aplikasi.');
    }
  }

  // error handling jika kamera tidak diizinkan namun senter dinyalakan
  Future<void> _toggleFlashlight() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _playErrorFeedback('Kamera belum siap. Tunggu beberapa saat.');
      return;
    }

    // Haptic feedback untuk double-tap - light and quick
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();

    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
        _playButtonFeedback('Senter mati');
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
        _playButtonFeedback('Senter hidup');
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied') {
        _playErrorFeedback('Akses kamera ditolak. Senter tidak dapat digunakan.');
      } else if (e.code == 'torchModeNotSupported') {
        _playErrorFeedback('Perangkat ini tidak mendukung mode senter.');
      } else {
        _playErrorFeedback('Gagal mengontrol senter. ${e.description}');
      }
    } catch (e) {
      _playErrorFeedback('Terjadi kesalahan saat mengontrol senter.');
    }
  }

  // Menampilkan pesan Snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // dispose berfungsi untuk mematikan animasi ketika aplikasi ditutup
  @override
  void dispose() {
    _cameraController?.dispose();
    _audioPlayer.dispose();
    flutterTts.stop();
    super.dispose();
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        _lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      _lastBackPressed = now;
      
      // Play TTS warning
      try {
        await flutterTts.speak(
            "Anda menekan tombol back pada ponsel. Tekan sekali lagi untuk keluar dari aplikasi");
      } catch (e) {
        // TTS failed, just show message
      }
      
      _showMessage('Tekan sekali lagi untuk keluar');
      
      return false; // Don't exit yet
    }
    
    // Exit dari aplikasi menggunakan SystemNavigator
    SystemNavigator.pop();
    return false; // Return false karena SystemNavigator.pop() sudah handle exit
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEF26B), // #EEF26B
              Color(0xFFEAF207), // #EAF207
              Color(0xFFEBFF52), // #EBFF52
            ],
            stops: [0.25, 0.75, 1.0],
          ),
        ),
        child: const Center(child: CircularProgressIndicator(color: Color(0xFF0D0D0D))),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onWillPop();
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Kamera dengan improved gesture handling
            Positioned.fill(
              child: RawGestureDetector(
                gestures: <Type, GestureRecognizerFactory>{
                  // Double-tap gesture (priority higher)
                  DoubleTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
                    () => DoubleTapGestureRecognizer(),
                    (DoubleTapGestureRecognizer instance) {
                      instance.onDoubleTap = () {
                        // Cancel any pending long press
                        _isLongPressActive = false;
                        _toggleFlashlight();
                      };
                    },
                  ),
                  // Long press gesture with proper handling
                  LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                    () => LongPressGestureRecognizer(
                      duration: const Duration(milliseconds: 800),
                    ),
                    (LongPressGestureRecognizer instance) {
                      instance.onLongPressStart = (details) {
                        // Mark long press as active
                        _isLongPressActive = true;
                        
                        // Delay to avoid conflict with double-tap
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (_isLongPressActive) {
                            _toggleMic();
                          }
                        });
                      };
                      
                      instance.onLongPressEnd = (details) {
                        _isLongPressActive = false;
                      };
                      
                      instance.onLongPressCancel = () {
                        _isLongPressActive = false;
                      };
                    },
                  ),
                },
                behavior: HitTestBehavior.opaque,
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),

            // Subtitle Box - Overlay di depan kamera, hanya tampil jika ON
            if (_isSubtitleOn)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * _subtitleBoxHeight,
                child: Column(
                  children: [
                    // Drag handle untuk mengubah ukuran
                    GestureDetector(
                      onVerticalDragStart: (details) {
                        // Nonaktifkan animasi saat mulai drag
                        setState(() {
                          _animateSubtitle = false;
                        });
                      },
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          // Update height berdasarkan drag tanpa animasi
                          double newHeight = _subtitleBoxHeight - 
                              (details.delta.dy / MediaQuery.of(context).size.height);
                          // Batasi antara 0.12 (minimum) dan 0.6 (maximum)
                          _subtitleBoxHeight = newHeight.clamp(0.12, 0.6);
                        });
                      },
                      child: Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xBF818C2E),
                        ),
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D0D0D),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Subtitle content box
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFEEF26B),
                              Color(0xFFEAF207),
                              Color(0xFFEBFF52),
                            ],
                            stops: [0.25, 0.75, 1.0],
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Text(
                              'Subtitle akan muncul di sini...',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D0D0D),
                                fontFamily: 'Helvetica',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            //menu di pojok kanan atas
            Positioned(
              top: 40,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300), // Durasi transisi dibukanya menu
                curve: Curves.easeInOut,
                width: 50,
                height: _showMenu ? 150.0 : 50.0, //tinggi berubah dari 50 ke 150 jika ditekan
                decoration: BoxDecoration(
                  color: const Color(0xBF818C2E),
                  borderRadius: BorderRadius.circular(_showMenu ? 25.0 : 25.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x4D000000), // Black with 30% opacity
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showMenu = !_showMenu;
                          if (_showMenu) {
                            // Jika membuka menu, tampilkan item setelah transisi container
                            Future.delayed(const Duration(milliseconds: 200), () {
                              if (mounted && _showMenu) {
                                setState(() {
                                  _showMenuItems = true;
                                });
                              }
                            });
                          } else {
                            // Jika menutup menu, sembunyikan item
                            setState(() {
                              _showMenuItems = false; // Fade out menu items
                            });
                          }
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.transparent,
                        child: Center(
                          child: Image.asset(
                            'assets/logo.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                    // Menu item (Profile & Setting) hanya muncul saat _showMenuItems true
                    if (_showMenu) // Pastikan container sudah membesar sebelum mencoba menampilkan item
                      AnimatedOpacity(
                        opacity: _showMenuItems ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300), // Durasi fade in/out item
                        curve: Curves.easeInOut,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 1),
                            IconButton( //icon button profile
                              icon: const Icon(Icons.person, color: Color(0xFF0D0D0D), size: 24),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const UserProfilePage()),
                                );
                              },
                              tooltip: 'Profile',
                            ),
                            IconButton( //icon button setting
                              icon: const Icon(Icons.settings, color: Color(0xFF0D0D0D), size: 24),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const SettingPage()),
                                );
                              },
                              tooltip: 'Setting',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Tombol Subtitle di bagian bawah tengah - bergeser ke atas saat subtitle aktif
            AnimatedPositioned(
              duration: _animateSubtitle 
                  ? const Duration(milliseconds: 400) // Animasi saat button ditekan
                  : Duration.zero, // Tidak ada animasi saat drag manual
              curve: Curves.easeInOut,
              bottom: _isSubtitleOn 
                  ? (MediaQuery.of(context).size.height * _subtitleBoxHeight) + 20 // 20px di atas subtitle box
                  : 40, // Posisi default
              left: 0,
              right: 0,
              child: Center(
                child: _buildActionButton(
                  icon: _isSubtitleOn ? Icons.subtitles : Icons.subtitles_outlined,
                  onPressed: _toggleSubtitle,
                ),
              ),
            ),

            // Mic Active Indicator - Bottom right corner
            if (_isMicOn)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: _isSubtitleOn 
                    ? (MediaQuery.of(context).size.height * _subtitleBoxHeight) + 20 // 20px di atas subtitle box
                    : 40, // Posisi default
                right: 20,
                child: AnimatedOpacity(
                  opacity: _isMicOn ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444), // Red color to indicate active mic
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x4D000000), // Black with 30% opacity
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membuat tombol aksi bawah
  Widget _buildActionButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF26B), // Warna tombol
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0x4D000000), // Black with 30% opacity
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF0D0D0D), size: 30),
        onPressed: onPressed,
      ),
    );
  }
}
