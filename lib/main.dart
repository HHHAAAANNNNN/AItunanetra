import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:aitunanetra/dashboard_page.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:aitunanetra/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences before app starts
  await SharedPreferences.getInstance();
  
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
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start the flow
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    // Wait 1 second
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (!mounted) return;
    
    // Start fade animation
    _controller.forward();
    
    // Wait for fade to complete
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Navigate
    if (mounted && !_hasNavigated) {
      _hasNavigated = true;
      _navigateToNextScreen();
    }
  }

  Future<void> _navigateToNextScreen() async {
    try {
      final shouldShowOnboarding = await PreferencesService.shouldShowOnboarding();
      
      if (!mounted) return;
      
      if (shouldShowOnboarding) {
        // Show onboarding
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      } else {
        // Skip directly to dashboard (login removed based on user feedback)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Navigation ERROR: $e');
      }
      // Fallback to onboarding
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
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
  final bool playAudio;
  
  const OnboardingScreen({super.key, this.playAudio = true});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    if (widget.playAudio) {
      _playWelcomeAudio();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _playWelcomeAudio() async {
    await flutterTts.setLanguage("id-ID"); // Indonesian
    await flutterTts.setSpeechRate(0.6); // Speed (0.6 = moderate)
    await flutterTts.setVolume(1.0); // Volume
    await flutterTts.setPitch(1.0); // Pitch
    
    // Play welcome message in Indonesian
    await flutterTts.speak(
      "disarankan untuk menyalakan suara ponsel untuk penggunaan aplikasi yang lebih baik."
      "Selamat datang di AI Tunanetra. Aplikasi ini membantu kamu berinteraksi dengan lingkungan berbasis kamera pada ponsel. "
      "Geser layar untuk melihat panduan berikutnya, atau tekan tombol selanjutnya. "
      "Arahkan saja kamera dan pemindaian akan otomatis dijalankan. "
      "Ketuk layar dua kali untuk menyalakan atau mematikan lampu senter, dan tekan tahan layar untuk mengaktifkan mikrofon."
      "Jika sudah siap menggunakan aplikasi, tekan tombol di bawah pada halaman terakhir."
    );
  }

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/SplashScreen2.png',
      title: 'Selamat Datang',
      subtitle: 'di AITunanetra!',
      description: 'Aplikasi Ini Terus Menerus\nMemindai Objek di Sekitar Anda!',
      showSwipeHint: true,
    ),
    OnboardingData(
      image: 'assets/SplashScreen3.png',
      title: 'Arahkan Kamera',
      subtitle: 'ke Objek Apa Pun,',
      description: 'Deteksi Terjadi\nSecara Otomatis!',
    ),
    OnboardingData(
      image: 'assets/SplashScreen4.1.png',
      title: 'Butuh Cahaya?',
      subtitle: 'Ketuk Dua Kali di Mana Saja\npada Layar!',
      description: 'Tekan Tahan\nuntuk Mengaktifkan Kontrol Suara!',
      showDualImages: true, 
      image2: 'assets/SplashScreen4.2.png', 
    ),
    OnboardingData(
      image: 'assets/logo.png',
      title: 'Deteksi Dimulai',
      subtitle: 'Otomatis Saat Anda\nMembuka Tampilan Kamera',
      description: 'Siap Menggunakan Aplikasi?',
      showButton: true,
      showImage: true,
    ),
  ];

  void _navigateToDashboard() async {
    // Mark first run as completed
    await PreferencesService.setFirstRunCompleted();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    }
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
                  onTap: _navigateToDashboard,
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

            // Page indicator dan navigation buttons di bawah
            Positioned(
              bottom: 20, // Diturunkan dari 40 ke 20 untuk mendekati bottom corner
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Navigation buttons (Previous / Next)
                  if (_currentPage > 0 || _currentPage < _pages.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Previous button
                          if (_currentPage > 0)
                            ElevatedButton.icon(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              icon: const Icon(Icons.arrow_back, size: 20),
                              label: const Text('Sebelumnya'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D0D0D),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 120), // Spacer when no previous button
                          
                          // Next button
                          if (_currentPage < _pages.length - 1)
                            ElevatedButton.icon(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              label: const Text('Selanjutnya'),
                              icon: const Icon(Icons.arrow_forward, size: 20),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D0D0D),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 120), // Spacer when no next button
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 12), // Dikurangi dari 16 ke 12
                  
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildIndicator(index == _currentPage),
                    ),
                  ),
                ],
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

          const SizedBox(height: 20), // Dikurangi dari 40 ke 20 untuk "Deteksi terjadi secara otomatis" & "Arahkan kamera" lebih dekat dengan gambar

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

          // Swipe hint untuk halaman pertama
          if (data.showSwipeHint)
            Padding(
              padding: const EdgeInsets.only(top: 10.0), // Dikurangi dari 20 ke 10 agar "Geser untuk lanjut" lebih dekat dengan teks di atasnya
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swipe,
                    size: 24,
                    color: const Color(0xFF0D0D0D).withAlpha((255 * 0.7).round()),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Geser ke kanan untuk lanjut',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF0D0D0D).withAlpha((255 * 0.7).round()),
                      fontFamily: 'Helvetica',
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 40),

          // Button "Dengar Lagi" hanya di page terakhir
          if (data.showButton)
            ElevatedButton.icon(
              onPressed: () async {
                // Replay audio panduan
                await _playWelcomeAudio();
              },
              icon: const Icon(Icons.replay, size: 20),
              label: const Text(
                'Dengar Lagi',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0D0D0D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF0D0D0D), width: 2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),

          if (data.showButton) const SizedBox(height: 12),

          // Button "Anda Siap?" hanya di page terakhir
          if (data.showButton)
            ElevatedButton(
              onPressed: _navigateToDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D0D0D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
              ),
              child: const Text(
                'Anda Siap?',
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
  final bool showDualImages; // Property untuk dual images
  final String? image2; // Property untuk gambar kedua (optional)
  final bool showSwipeHint; // Property untuk menampilkan hint geser

  OnboardingData({
    required this.image,
    required this.title,
    this.subtitle = '',
    this.description = '',
    this.showButton = false,
    this.showImage = false,
    this.showDualImages = false,
    this.image2,
    this.showSwipeHint = false,
  });
}
