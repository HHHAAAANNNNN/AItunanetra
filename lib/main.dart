import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

// Halaman utama aplikasi
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(), // Mulai dengan SplashScreen
    );
  }
}

// SplashScreen (Halaman Loading Awal)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;

  // Ukuran awal logo di splash screen
  final double _initialLogoWidth = 155.0;
  final double _initialLogoHeight = 135.0;

  // Ukuran target logo di halaman login (sekitar 2/3 dari ukuran awal)
  final double _targetLogoWidth = 102.0; // 155 * (2/3)
  final double _targetLogoHeight = 89.0; // 135 * (2/3)

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Durasi total animasi dan jeda
      vsync: this,
    );

    // Hitung skala akhir berdasarkan perbandingan ukuran target dan awal
    double endScale = _targetLogoWidth / _initialLogoWidth;

    // Animasi ukuran logo (zoom out)
    _logoSizeAnimation = Tween<double>(begin: 1.0, end: endScale).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut), // Mulai animasi zoom setelah jeda 1 detik
      ),
    );

    // Animasi posisi logo (ke atas menuju posisi di halaman login)
    // Penyesuaian offset berdasarkan proporsi layar
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0), // Tengah layar
      // Offset akhir disesuaikan agar logo berada di posisi yang tepat di halaman login
      // Nilai -0.4 adalah perkiraan yang bagus untuk memposisikan logo di bagian atas
      // Anda mungkin perlu menyesuaikan nilai ini jika layout halaman login berubah signifikan
      end: const Offset(0.0, -0.4),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut), // Mulai animasi posisi setelah jeda 1 detik
      ),
    );

    _controller.forward(); // Mulai animasi

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Setelah animasi selesai, navigasi ke halaman login
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500), // Transisi antar halaman
            pageBuilder: (context, animation, secondaryAnimation) =>
                FadeTransition(opacity: animation, child: const LoginPage()),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                // Menggunakan _initialLogoHeight/2 untuk menggeser titik tengah logo agar animasinya lebih akurat
                offset: _logoPositionAnimation.value * MediaQuery.of(context).size.height,
                child: Transform.scale(
                  scale: _logoSizeAnimation.value,
                  child: Image.asset(
                    'assets/logo.png', // Pastikan Anda memiliki file 'logo.png' di folder 'assets'
                    width: _initialLogoWidth, // Ukuran awal logo
                    height: _initialLogoHeight,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// LoginPage (Halaman Login)
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Ukuran logo di halaman login harus cocok dengan ukuran target dari animasi splash screen
  final double _logoWidth = 102.0; // Cocok dengan _targetLogoWidth di SplashScreen
  final double _logoHeight = 89.0;  // Cocok dengan _targetLogoHeight di SplashScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo di bagian atas halaman login
                Image.asset(
                  'assets/logo.png', // Pastikan Anda memiliki file 'logo.png' di folder 'assets'
                  width: _logoWidth, // Ukuran logo di halaman login
                  height: _logoHeight,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sign In to Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t Have an Account?',
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {
                        // Aksi untuk SignUp
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: const Icon(Icons.visibility_off),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Aksi untuk Forgot Password
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Aksi untuk Sign In
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Warna tombol Sign In
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
