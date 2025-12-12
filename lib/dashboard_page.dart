import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:aitunanetra/setting_page.dart';
import 'package:aitunanetra/main.dart';
import 'package:aitunanetra/preferences_service.dart';
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
  bool _isFlashOn = false; 
  bool _isMicOn = false; 
  bool _isSubtitleOn = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  FlutterTts flutterTts = FlutterTts();
  DateTime? _lastBackPressed; //tracking back button
  double _subtitleBoxHeight = 0.18; 
  bool _animateSubtitle = true; 
  bool _isLongPressActive = false;
  
  // Settings
  bool _gesturesEnabled = true;
  bool _flashlightGestureEnabled = true;
  bool _microphoneGestureEnabled = true;
  double _ttsSpeed = 0.5;
  double _ttsVolume = 1.0;

  @override
  void initState() {
    super.initState();
    
    // Ensure fullscreen mode is maintained
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
    
    _loadSettings();
    _initializeCamera();
    _initAudioPlayer();
    _initializeTts();
    _playWelcomeGuide();

    // Tampilkan notifikasi jika berhasil login
    if (widget.loggedInSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil Login!')),
        );
      });
    }
  }

  // Load user settings
  Future<void> _loadSettings() async {
    final gesturesEnabled = await PreferencesService.getGesturesEnabled();
    final flashlightGesture = await PreferencesService.getFlashlightGestureEnabled();
    final microphoneGesture = await PreferencesService.getMicrophoneGestureEnabled();
    final ttsSpeed = await PreferencesService.getTtsSpeed();
    final ttsVolume = await PreferencesService.getTtsVolume();
    
    setState(() {
      _gesturesEnabled = gesturesEnabled;
      _flashlightGestureEnabled = flashlightGesture;
      _microphoneGestureEnabled = microphoneGesture;
      _ttsSpeed = ttsSpeed;
      _ttsVolume = ttsVolume;
    });
  }

  // Inisialisasi TTS untuk back button warning
  Future<void> _initializeTts() async {
    try {
      await flutterTts.setLanguage("id-ID"); // Indonesian
      await flutterTts.setSpeechRate(_ttsSpeed); // Use user-configured speed
      await flutterTts.setVolume(_ttsVolume); // Use user-configured volume
      await flutterTts.setPitch(1.0); // Pitch
    } catch (e) {
      // TTS engine not available
      _showMessage('TTS Engine tidak tersedia. Silakan install Google TTS atau Speech Services.');
    }
  }

  // Play welcome guide audio saat pertama masuk dashboard
  Future<void> _playWelcomeGuide() async {
    // Cek apakah user mengaktifkan "always play dashboard guide"
    final alwaysPlayGuide = await PreferencesService.getAlwaysPlayDashboardGuide();
    final hasPlayedBefore = await PreferencesService.getHasPlayedDashboardGuide();
    
    // Jika toggle OFF dan sudah pernah dimainkan sebelumnya, skip
    if (!alwaysPlayGuide && hasPlayedBefore) {
      return;
    }
    
    // Tunggu sebentar untuk memastikan TTS sudah siap
    await Future.delayed(const Duration(milliseconds: 3000));
    
    try {
      await flutterTts.setLanguage("id-ID");
      await flutterTts.setSpeechRate(_ttsSpeed);
      await flutterTts.setVolume(_ttsVolume);
      await flutterTts.setPitch(1.0);
      
      String guideText = "Selamat datang di AI Tunanetra. "
          "Di bagian bawah layar terdapat tiga tombol. "
          "Dari kiri ke kanan adalah senter, teks, dan mikrofon. "
          "Di bagian atas layar juga terdapat tiga tombol. "
          "Pojok kiri atas adalah panduan untuk melihat kembali cara penggunaan aplikasi. "
          "Tengah atas adalah pengaturan untuk menyesuaikan aplikasi. "
          "Pojok kanan atas adalah keluar untuk menutup aplikasi.";
      
      await flutterTts.speak(guideText);
      
      // Tandai bahwa guide sudah pernah dimainkan
      await PreferencesService.setHasPlayedDashboardGuide(true);
    } catch (e) {
      // Jika TTS gagal, tidak masalah
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
      await flutterTts.setSpeechRate(_ttsSpeed * 1.3); // Sedikit lebih cepat untuk feedback
      await flutterTts.setVolume(_ttsVolume);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(message);
    } catch (e) {
      // kalo gagal, teks saja
      _showMessage(message);
    }
  }

  // Play error audio feedback
  Future<void> _playErrorFeedback(String errorMessage) async {
    try {
      await flutterTts.setLanguage("id-ID");
      await flutterTts.setSpeechRate(_ttsSpeed); // Use normal speed for errors
      await flutterTts.setVolume(_ttsVolume);
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
                        // Check if gestures are enabled and flashlight gesture is enabled
                        if (!_gesturesEnabled || !_flashlightGestureEnabled) return;
                        
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
                        // Check if gestures are enabled and microphone gesture is enabled
                        if (!_gesturesEnabled || !_microphoneGestureEnabled) return;
                        
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

            // 3 Button di bagian atas: Panduan (kiri), Pengaturan (tengah), Keluar (kanan)
            // Button Panduan di pojok kiri atas
            Positioned(
              top: 40,
              left: 20,
              child: _buildTopButton(
                icon: Icons.help_outline,
                label: 'Panduan',
                onPressed: () async {
                  await flutterTts.speak("Membuka panduan penggunaan. Tunggu sebentar");
                  await Future.delayed(const Duration(milliseconds: 3000)); // perlu delay untuk load konten panduan
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const OnboardingScreen(playAudio: true)),
                  );
                },
              ),
            ),

            // Button Pengaturan di tengah atas
            Positioned(
              top: 40,
              left: MediaQuery.of(context).size.width / 2 - 45,
              child: _buildTopButton(
                icon: Icons.settings,
                label: 'Pengaturan',
                onPressed: () async {
                  await flutterTts.stop();
                  await _playButtonFeedback('Membuka pengaturan');
                  // Tunggu audio selesai sebelum pindah halaman
                  await Future.delayed(const Duration(milliseconds: 1500)); // sama, perlu delay untuk load
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SettingPage()),
                  );
                  // Reload settings after returning from settings page
                  await _loadSettings();
                  await _initializeTts(); // Re-initialize TTS with new settings
                },
              ),
            ),

            // Button Keluar di pojok kanan atas
            Positioned(
              top: 40,
              right: 20,
              child: _buildTopButton(
                icon: Icons.exit_to_app,
                label: 'Keluar',
                onPressed: () async {
                  await flutterTts.speak("Keluar dari aplikasi");
                  await Future.delayed(const Duration(milliseconds: 500));
                  SystemNavigator.pop();
                },
              ),
            ),

            // Tombol control di bagian bawah: Flashlight, Subtitle, Microphone
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flashlight button (kiri)
                  _buildActionButton(
                    icon: _isFlashOn ? Icons.flashlight_on : Icons.flashlight_off,
                    onPressed: _toggleFlashlight,
                    backgroundColor: _isFlashOn ? const Color(0xFFFFEB3B) : const Color(0xFFEEF26B),
                    label: 'Senter',
                  ),
                  
                  const SizedBox(width: 60), // Spacing antar button diperbesar agar tidak berdempet
                  
                  // Subtitle button (tengah)
                  _buildActionButton(
                    icon: _isSubtitleOn ? Icons.subtitles : Icons.subtitles_outlined,
                    onPressed: _toggleSubtitle,
                    backgroundColor: const Color(0xFFEEF26B),
                    label: 'Teks',
                  ),
                  
                  const SizedBox(width: 60), // Spacing antar button diperbesar agar tidak berdempet
                  
                  // Microphone button (kanan)
                  _buildActionButton(
                    icon: _isMicOn ? Icons.mic : Icons.mic_off,
                    onPressed: _toggleMic,
                    backgroundColor: _isMicOn ? const Color(0xFFEF4444) : const Color(0xFFEEF26B),
                    label: 'Mikrofon',
                  ),
                ],
              ),
            ),

            // Mic Active Indicator - Removed (sudah ada button mic)
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon, 
    required VoidCallback onPressed,
    required String label,
    Color backgroundColor = const Color(0xFFEEF26B),
  }) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor, 
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0x4D000000), 
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF0D0D0D), size: 30),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D0D0D),
                  fontFamily: 'Helvetica',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method untuk membuat button atas dengan icon dan label terintegrasi (untuk TalkBack)
  Widget _buildTopButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF26B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF0D0D0D), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0x4D000000),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF0D0D0D), size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D0D0D),
                  fontFamily: 'Helvetica',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
