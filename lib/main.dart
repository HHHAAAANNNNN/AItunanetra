import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aitunanetra/dashboard_page.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set fullscreen mode - hide status bar and navigation bar
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );
  
  // Set preferred orientations (optional - lock to portrait)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Login',
      theme: ThemeData(
        fontFamily: 'Helvetica', // aplikasi mobile cenderung menggunakan Helvetica
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}

// Dimulai dari splashscreen agar lebih nyaman penggunaan
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoFadeAnimation;

  final double _initialLogoWidth = 155.0;
  final double _initialLogoHeight = 135.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), //animasi splashscreen ke login screen berlangsung 1,5 detik
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate( //animasi dimulai di detik 1, berakhir di detik 0
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(1000 / 1500, 1.0, curve: Curves.easeOut), //animasi berupa fade out
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) { //kalau animasi selesai, start animasi login screen
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500), //durasi animasi login screen 0.5 detik
            pageBuilder: (context, animation, secondaryAnimation) =>
                FadeTransition(opacity: animation, child: const LoginPage()),
          ),
        );
      }
    });
  }

  // dispose berfungsi untuk mematikan animasi ketika aplikasi ditutup
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration( //background aplikasi
          gradient: LinearGradient( //gradient background aplikasi
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
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _logoFadeAnimation.value,
                child: Image.asset(
                  'assets/logo.png',
                  width: _initialLogoWidth,
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FlutterTts flutterTts = FlutterTts();

  // logo pada login screen berakhir di ukuran berikut
  final double _logoWidth = 102.0;
  final double _logoHeight = 89.0;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  // Initialize TTS with Indonesian language settings
  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("id-ID"); // Indonesian
    await flutterTts.setSpeechRate(0.5); // Speed (0.5 = slower, good for accessibility)
    await flutterTts.setVolume(1.0); // Volume
    await flutterTts.setPitch(1.0); // Pitch
    
    // Play welcome message
    await flutterTts.speak("Selamat datang di AI Tunanetra. By Any Chance, if my audio sounds weird then I'm unable to talk in English.");
  }

  @override
  void dispose() {
    flutterTts.stop();
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
              Color(0xFFEEF26B),
              Color(0xFFEAF207),
              Color(0xFFEBFF52),
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
                Image.asset(
                  'assets/logo.png',
                  width: _logoWidth,
                  height: _logoHeight,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Sign In to Your Account',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D0D0D),
                    fontFamily: 'Helvetica',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                TextField(
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
                      color: Color(0xFF0d0d0d),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
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
                      color: Color(0xFF0d0d0d),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      //tombol 'Forgot Password' masih belum berfungsi
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Color(0xFF0D0D0D),
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const DashboardPage(loggedInSuccessfully: true)),
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
