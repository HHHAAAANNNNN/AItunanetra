import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:aitunanetra/dashboard_page.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:aitunanetra/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SharedPreferences.getInstance();
  
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );

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
        fontFamily: 'Helvetica', 
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const InitialSplashScreen(),
    );
  }
}

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

    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (!mounted) return;
    
    _controller.forward();
    
    await Future.delayed(const Duration(milliseconds: 1000));
    
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      } else {
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
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    await flutterTts.speak(
      "disarankan untuk menyalakan suara ponsel untuk penggunaan aplikasi yang lebih baik."
      "pada pojok kanan-atas terdapat tombol untuk melewati panduan ini."
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
      showSwipeHint: true,
    ),
    OnboardingData(
      image: 'assets/SplashScreen4.1.png',
      title: 'Butuh Cahaya?',
      subtitle: 'Ketuk Dua Kali di Mana Saja\npada Layar!',
      description: 'Tekan Tahan\nuntuk Mengaktifkan Kontrol Suara!',
      showDualImages: true, 
      image2: 'assets/SplashScreen4.2.png',
      showSwipeHint: true,
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

            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  if (_currentPage > 0 || _currentPage < _pages.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                            const SizedBox(width: 120), 
                          
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
                            const SizedBox(width: 120), 
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 12), 
                  
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

    if (data.showDualImages && data.image2 != null) {
      return Column(
        children: [
          const SizedBox(height: 30),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D0D0D),
              fontFamily: 'Helvetica',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              data.subtitle,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF0D0D0D),
                fontFamily: 'Helvetica',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            flex: 2, 
            child: Image.asset(
              data.image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 15), 
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              data.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF0D0D0D),
                fontFamily: 'Helvetica',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15), 

          Flexible(
            flex: 2, 
            child: Image.asset(
              data.image2!,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 15), 

          if (data.showSwipeHint)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swipe,
                    color: const Color(0xFF0D0D0D),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Geser ke kanan untuk lanjut',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0D0D0D),
                      fontFamily: 'Helvetica',
                    ),
                  ),
                ],
              ),
            ),
        
          const Spacer(), 
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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

          if (data.image.isNotEmpty)
            Flexible(
              flex: 4,
              child: Center(
                child: Image.asset(
                  data.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          const SizedBox(height: 20), 

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

          if (data.showSwipeHint)
            Padding(
              padding: const EdgeInsets.only(top: 10.0), 
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

          if (data.showButton)
            ElevatedButton.icon(
              onPressed: () async {
                
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


class OnboardingData {
  final String image;
  final String title;
  final String subtitle;
  final String description;
  final bool showButton;
  final bool showImage;
  final bool showDualImages; 
  final String? image2; 
  final bool showSwipeHint; 

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
