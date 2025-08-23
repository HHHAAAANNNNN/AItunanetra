import 'package:flutter/material.dart';
import 'package:aitunanetra/dashboard_page.dart';

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
        // Mengatur fontFamily secara global untuk semua TextStyle yang tidak menimpanya
        fontFamily: 'Helvetica',
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
  late Animation<double> _logoFadeAnimation; // Animasi fade out logo

  // Ukuran logo di splash screen (tidak lagi dianimasikan ukurannya)
  final double _initialLogoWidth = 155.0;
  final double _initialLogoHeight = 135.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Total durasi: 1 detik jeda + 0.5 detik fade out
      vsync: this,
    );

    // Animasi fade out logo: Mulai setelah 1 detik (1000ms), berakhir pada 1.5 detik (1500ms)
    _logoFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(1000 / 1500, 1.0, curve: Curves.easeOut), // Fade mulai pada 1 detik, selesai pada 1.5 detik
      ),
    );

    _controller.forward(); // Mulai animasi

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Setelah animasi selesai, navigasi ke halaman login
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1500), // Durasi fade in halaman login
            pageBuilder: (context, animation, secondaryAnimation) =>
                FadeTransition(opacity: animation, child: const LoginPage()), // Halaman login fade in
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
          // AnimatedBuilder digunakan untuk menerapkan animasi opacity pada logo
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _logoFadeAnimation.value,
                child: Image.asset(
                  'assets/logo.png', // Pastikan Anda memiliki file 'logo.png' di folder 'assets'
                  width: _initialLogoWidth, // Ukuran logo tetap
                  height: _initialLogoHeight,
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

  // Ukuran logo di halaman login
  final double _logoWidth = 102.0;
  final double _logoHeight = 89.0;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Logo di bagian atas halaman login
                Image.asset(
                  'assets/logo.png', // Pastikan Anda memiliki file 'logo.png' di folder 'assets'
                  width: _logoWidth, // Ukuran logo di halaman login
                  height: _logoHeight,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Sign In to Your Account',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D0D0D), // Warna teks diubah ke #0D0D0D
                    fontFamily: 'Helvetica', // Font diubah ke Helvetica
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30), // Mengembalikan ke tanpa width
                // TextField Email
                TextField( // Kembali tanpa SizedBox wrapper untuk width
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2.0, color: Color(0xFF0D0D0D)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2.0, color: Color(0xFF0D0D0D)),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    labelStyle: const TextStyle(
                      fontFamily: 'Helvetica',
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // TextField Password
                TextField( // Kembali tanpa SizedBox wrapper untuk width
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: const Icon(Icons.visibility_off),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2.0, color: Color(0xFF0D0D0D)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2.0, color: Color(0xFF0D0D0D)),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    labelStyle: const TextStyle(
                      fontFamily: 'Helvetica',
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      // Aksi untuk Forgot Password
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Color(0xFF0D0D0D),
                        fontFamily: 'Helvetica',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    // --- BARIS INI YANG DIUBAH ---
                    // Navigasi ke DashboardPage saat tombol Sign In ditekan
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D0D0D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Helvetica',
                    ),
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
