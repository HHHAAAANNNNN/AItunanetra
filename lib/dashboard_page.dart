import 'package:aitunanetra/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:aitunanetra/setting_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isFlashOn = false;
  bool _isMuted = false;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _showMenu = false; // State untuk mengontrol visibilitas AnimatedContainer (ukuran box)
  bool _showMenuItems = false; // State baru untuk mengontrol visibilitas item menu (opacity)

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initAudioPlayer();
  }

  // Inisialisasi Audio Player
  void _initAudioPlayer() async {
    _audioPlayer.setVolume(1.0); // Default volume, akan diubah jika _isMuted true
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  // Mengubah status mute/unmute
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
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0], // Menggunakan kamera pertama (biasanya belakang)
          ResolutionPreset.medium,
          enableAudio: false,
        );

        _cameraController!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        }).catchError((Object e) {
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

  // Mengubah status flashlight melalui CameraController
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

          // Tombol di bagian atas kanan (Logo dan menu)
          Positioned(
            top: 40,
            right: 20,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Durasi transisi AnimatedContainer
              curve: Curves.easeInOut,
              width: 50, // Lebar tetap 50
              height: _showMenu ? 150.0 : 50.0, // Tinggi berubah dari 50 ke 170
              decoration: BoxDecoration(
                color: const Color(0x7F818C2E), // Warna #818C2E dengan opacity 75%
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
                  // Tombol Logo (selalu terlihat)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showMenu = !_showMenu; // Mengubah ukuran container
                        if (_showMenu) {
                          // Jika membuka menu, tampilkan item setelah transisi container + 500ms delay
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted && _showMenu) { // Pastikan widget masih mounted dan menu masih terbuka
                              setState(() {
                                _showMenuItems = true; // Fade in menu items
                              });
                            }
                          });
                        } else {
                          // Jika menutup menu, sembunyikan item segera
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
                          'assets/logo.png', // Logo Anda
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                  // Menu item (Profile & Setting) hanya muncul saat _showMenuItems true
                  if (_showMenu) // Pastikan container sudah membesar sebelum mencoba menampilkan item
                    AnimatedOpacity(
                      opacity: _showMenuItems ? 1.0 : 0.0, // Dikontrol oleh _showMenuItems
                      duration: const Duration(milliseconds: 100), // Durasi fade in/out item
                      curve: Curves.easeInOut,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 1),
                          // Tombol User Profile sebagai IconButton
                          IconButton(
                            icon: const Icon(Icons.person, color: Color(0xFF0D0D0D), size: 24),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const UserProfilePage()),
                              );
                            },
                            tooltip: 'Profile',
                          ),
                          // Tombol Setting sebagai IconButton
                          IconButton(
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

          // Tombol di bagian bawah
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
                // Tombol Search (tidak berfungsi)
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
