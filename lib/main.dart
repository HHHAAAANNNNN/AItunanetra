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
      home: const InitialSplashScreen(),
    );
  }
}

// Initial Splash Screen dengan logo AITUNANETRA
class InitialSplashScreen extends StatefulWidget {
  const InitialSplashScreen({super.key});

  @override
  State<InitialSplashScreen> createState() => _InitialSplashScreenState();
}

class _InitialSplashScreenState extends State<InitialSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // 1 detik untuk fade out
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Tunggu 1 detik, lalu mulai fade out
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _controller.forward();
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Setelah fade out selesai, navigasi ke onboarding
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                FadeTransition(opacity: animation, child: const OnboardingScreen()),
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
              Color(0xFFEEF26B),
              Color(0xFFEAF207),
              Color(0xFFEBFF52),
            ],
            stops: [0.25, 0.75, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica',
                        ),
                        children: [
                          TextSpan(
                            text: 'AI',
                            style: TextStyle(color: Color(0xFF0066FF)), // Biru
                          ),
                          TextSpan(
                            text: 'TUNANETRA',
                            style: TextStyle(color: Color(0xFF0D0D0D)), // Hitam
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Onboarding Screen dengan swipeable pages
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/SplashScreen2.png',
      title: 'Welcome',
      subtitle: 'to AITunanetra!',
      description: 'This App Continuously\nScan Objects Around You!',
    ),
    OnboardingData(
      image: 'assets/SplashScreen3.png',
      title: 'Point your Camera',
      subtitle: 'at Any Object,',
      description: 'Detection Happens\nAutomatically!',
    ),
    OnboardingData(
      image: 'assets/SplashScreen4.1.png',
      title: 'Need Light?',
      subtitle: 'Double-Tap Anywhere\non The Screen!',
      description: 'Long Press\nto Activate Voice Control!',
      showDualImages: true, 
      image2: 'assets/SplashScreen4.2.png', 
    ),
    OnboardingData(
      image: 'assets/logo.png',
      title: 'Detection Starts',
      subtitle: 'Automatically When You\nEnter the Camera View,',
      description: '',
      showButton: true,
      showImage: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
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
        child: Stack(
          children: [
            // PageView untuk swipe
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),

            // Skip button (X) di pojok kanan atas
            Positioned(
              top: 50,
              right: 24,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _navigateToLogin,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF0D0D0D),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            // Page indicator di bawah
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildIndicator(index == _currentPage),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    // Jika hanya menampilkan gambar (untuk page 4 dan 5)
    if (data.showImage && data.title.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Image.asset(
            data.image,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    // Jika menampilkan dual images (untuk page 3)
    if (data.showDualImages && data.image2 != null && data.image2!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title dengan subtitle
            if (data.title.isNotEmpty)
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvetica',
                    color: Color(0xFF0D0D0D),
                  ),
                  children: [
                    TextSpan(text: data.title),
                    if (data.subtitle.isNotEmpty)
                      TextSpan(
                        text: '\n${data.subtitle}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // Gambar pertama (Double-Tap)
            Expanded(
              child: Center(
                child: Image.asset(
                  data.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description
            if (data.description.isNotEmpty)
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Helvetica',
                  color: Color(0xFF0D0D0D),
                ),
              ),

            const SizedBox(height: 20),

            // Gambar kedua (Long Press)
            Expanded(
              child: Center(
                child: Image.asset(
                  data.image2!,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      );
    }

    // Layout normal dengan title, image, description
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          if (data.title.isNotEmpty)
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Helvetica',
                  color: Color(0xFF0D0D0D),
                ),
                children: [
                  TextSpan(text: data.title),
                  if (data.subtitle.isNotEmpty)
                    TextSpan(
                      text: '\n${data.subtitle}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 40),

          // Image
          if (data.image.isNotEmpty)
            Expanded(
              child: Center(
                child: Image.asset(
                  data.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          const SizedBox(height: 40),

          // Description
          if (data.description.isNotEmpty)
            Text(
              data.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica',
                color: Color(0xFF0D0D0D),
              ),
            ),

          const SizedBox(height: 40),

          // Button "You Ready?" hanya di page terakhir
          if (data.showButton)
            ElevatedButton(
              onPressed: _navigateToLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D0D0D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
              ),
              child: const Text(
                'You Ready?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0D0D0D) : const Color(0x4D0D0D0D), // 0x4D = ~30% opacity
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

// Data model untuk onboarding pages
class OnboardingData {
  final String image;
  final String title;
  final String subtitle;
  final String description;
  final bool showButton;
  final bool showImage;
  final bool showDualImages; // Property baru untuk dual images
  final String? image2; // Property untuk gambar kedua (optional)

  OnboardingData({
    required this.image,
    required this.title,
    this.subtitle = '',
    this.description = '',
    this.showButton = false,
    this.showImage = false,
    this.showDualImages = false,
    this.image2,
  });
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
    await flutterTts.setSpeechRate(0.6); // Speed (0.5 = slower, good for accessibility)
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
                    fillColor: const Color(0xCCFFFFFF), // 0xCC = ~80% opacity white
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
                    fillColor: const Color(0xCCFFFFFF), // 0xCC = ~80% opacity white
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
