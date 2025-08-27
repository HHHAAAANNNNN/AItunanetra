import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:aitunanetra/user_profile_page.dart';
import 'package:aitunanetra/setting_page.dart';

class DashboardPage extends StatefulWidget {
  final bool loggedInSuccessfully; // cek apakah berhasil login atau tidak

  const DashboardPage({super.key, this.loggedInSuccessfully = false});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isFlashOn = false; //default senter kamera mati
  bool _isMuted = false; //default text-to-voice menyala
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _showMenu = false; //default menu tertutup
  bool _showMenuItems = false; //default items di dalam menu belum muncul

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initAudioPlayer();

    // Tampilkan notifikasi jika berhasil login
    if (widget.loggedInSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil Login!')),
        );
      });
    }
  }

  // Inisialisasi Audio Player
  void _initAudioPlayer() async {
    _audioPlayer.setVolume(1.0); // Default volume
    _audioPlayer.setReleaseMode(ReleaseMode.loop); //looping audio
  }

  // Mengubah status audio mute/unmute
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (_isMuted) {
        _audioPlayer.setVolume(0.0);
      } else {
        _audioPlayer.setVolume(1.0);
      }
    });
    _showMessage(_isMuted ? 'Suara Dimatikan' : 'Suara Dihidupkan');
  }

  // Inisialisasi Kamera
  Future<void> _initializeCamera() async {
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
                _showMessage('Akses kamera ditolak.');
                break;
              default:
                _showMessage('Terjadi kesalahan kamera: ${e.description}');
                break;
            }
          }
        });
      } else {
        _showMessage('Tidak ada kamera tersedia.');
      }
    } else {
      _showMessage('Izin kamera ditolak.');
    }
  }

  // error handling jika kamera tidak diizinkan namun senter dinyalakan
  Future<void> _toggleFlashlight() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _showMessage('Kamera belum siap.');
      return;
    }

    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
        _showMessage('Flashlight Dimatikan');
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
        _showMessage('Flashlight Dinyalakan');
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } on CameraException catch (e) {
      _showMessage('Gagal mengontrol flashlight: ${e.description}');
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
    super.dispose();
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

    return Scaffold(
      body: Stack(
        children: [
          // Background Kamera
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
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
                    color: Colors.black.withOpacity(0.3),
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

          // 3 Tombol di bagian bawah
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Senter
                _buildActionButton(
                  icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  onPressed: _toggleFlashlight,
                ),
                // Tombol Search (belum berfungsi)
                _buildActionButton(
                  icon: Icons.search,
                  onPressed: () {
                    _showMessage('Tombol Search ditekan (tidak berfungsi)');
                  },
                ),
                // Tombol Suara
                _buildActionButton(
                  icon: _isMuted ? Icons.volume_off : Icons.volume_up,
                  onPressed: _toggleMute,
                ),
              ],
            ),
          ),
        ],
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
            color: Colors.black.withOpacity(0.3),
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
