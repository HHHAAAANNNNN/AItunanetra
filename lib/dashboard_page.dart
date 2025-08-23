import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:torch_light/torch_light.dart'; // Hapus atau komentari ini
import 'package:audioplayers/audioplayers.dart';

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
  bool _showMenu = false; // State untuk mengontrol visibilitas menu logo

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initAudioPlayer();
  }

  // Inisialisasi Audio Player
  void _initAudioPlayer() async {
    // Memutar suara secara loop sebagai latar belakang (contoh, ganti dengan aset suara Anda)
    // Untuk tujuan demonstrasi, kita akan memainkan suara lokal.
    // Anda perlu menambahkan file suara ke folder 'assets' dan mendeklarasikannya di pubspec.yaml
    // Contoh:
    // await _audioPlayer.setSourceAsset('audio/background_sound.mp3');
    // await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // await _audioPlayer.resume();

    // Untuk demo awal tanpa aset suara, kita bisa melewati pemutaran default
    // atau menggunakan URL jika tersedia. Untuk saat ini, asumsikan default mute
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
        // Jika suara belum diputar, dan sekarang unmuted, mulai putar
        // Anda mungkin perlu memanggil _audioPlayer.resume() atau setel sumber lagi
        // jika pemutaran berhenti sepenuhnya saat dimute.
        // Untuk demo, asumsikan _audioPlayer sudah memiliki sumber yang disetel
        // dan hanya mengatur volume.
      }
    });
    _showMessage(_isMuted ? 'Suara Dimatikan' : 'Suara Dihidupkan');
  }

  // Inisialisasi Kamera
  Future<void> _initializeCamera() async {
    // Meminta izin kamera
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0], // Menggunakan kamera pertama (biasanya belakang)
          ResolutionPreset.medium,
          enableAudio: false, // Kamera tidak perlu merekam audio untuk latar belakang
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
        await _cameraController!.setFlashMode(FlashMode.torch); // Menggunakan mode torch
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showMenu = !_showMenu;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF26B), // Warna tombol
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png', // Logo Anda
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ),
                if (_showMenu)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 120, // Lebar tombol menu
                          child: ElevatedButton(
                            onPressed: () {
                              _showMessage('Tombol User Profile ditekan');
                              // Aksi untuk User Profile
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEEF26B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text(
                              'User Profile',
                              style: TextStyle(color: Color(0xFF0D0D0D), fontFamily: 'Helvetica'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 120, // Lebar tombol menu
                          child: ElevatedButton(
                            onPressed: () {
                              _showMessage('Tombol Setting ditekan');
                              // Aksi untuk Setting
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEEF26B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text(
                              'Setting',
                              style: TextStyle(color: Color(0xFF0D0D0D), fontFamily: 'Helvetica'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
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
