import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aitunanetra/preferences_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Onboarding setting
  bool _alwaysShowOnboarding = false;
  bool _alwaysPlayDashboardGuide = false;
  
  // Gesture settings
  bool _gesturesEnabled = true;
  bool _flashlightGestureEnabled = true;
  bool _microphoneGestureEnabled = true;
  
  // TTS radio default settings
  double _ttsSpeed = 0.8; // 0.3, 0.5, 0.8
  double _ttsVolume = 1.0; // 0.3, 0.7, 1.0

  // FlutterTts untuk audio panduan
  final FlutterTts flutterTts = FlutterTts();

  // Warna default aplikasi
  Color _bgColor1 = const Color(0xFFEEF26B);
  Color _bgColor2 = const Color(0xFFEAF207);
  Color _bgColor3 = const Color(0xFFEBFF52);
  Color _textColor = const Color(0xFF0D0D0D);

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _playSettingsGuide();
    
    // Maintain fullscreen mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  Future<void> _playSettingsGuide() async {
    // Load TTS settings first
    final ttsSpeed = await PreferencesService.getTtsSpeed();
    final ttsVolume = await PreferencesService.getTtsVolume();
    
    // Tunggu bentar untuk memastikan TTS sudah siap
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      await flutterTts.setLanguage("id-ID");
      await flutterTts.setSpeechRate(ttsSpeed);
      await flutterTts.setVolume(ttsVolume);
      await flutterTts.setPitch(1.0);
      
      await flutterTts.speak("Scroll ke bawah untuk opsi lebih lanjut.");
    } catch (e) {
      // Jika TTS gagal, gapapa
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final alwaysShow = await PreferencesService.getAlwaysShowOnboarding();
    final alwaysPlayGuide = await PreferencesService.getAlwaysPlayDashboardGuide();
    final gesturesEnabled = await PreferencesService.getGesturesEnabled();
    final flashlightGesture = await PreferencesService.getFlashlightGestureEnabled();
    final microphoneGesture = await PreferencesService.getMicrophoneGestureEnabled();
    final ttsSpeed = await PreferencesService.getTtsSpeed();
    final ttsVolume = await PreferencesService.getTtsVolume();
    
    setState(() {
      _alwaysShowOnboarding = alwaysShow;
      _alwaysPlayDashboardGuide = alwaysPlayGuide;
      _gesturesEnabled = gesturesEnabled;
      _flashlightGestureEnabled = flashlightGesture;
      _microphoneGestureEnabled = microphoneGesture;
      _ttsSpeed = ttsSpeed;
      _ttsVolume = ttsVolume;
    });
  }

  Future<void> _toggleAlwaysShowOnboarding(bool value) async {
    await PreferencesService.setAlwaysShowOnboarding(value);
    setState(() {
      _alwaysShowOnboarding = value;
    });
  }

  Future<void> _toggleAlwaysPlayDashboardGuide(bool value) async {
    await PreferencesService.setAlwaysPlayDashboardGuide(value);
    setState(() {
      _alwaysPlayDashboardGuide = value;
    });
  }

  Future<void> _saveSettings() async {
    await PreferencesService.setAlwaysShowOnboarding(_alwaysShowOnboarding);
    await PreferencesService.setAlwaysPlayDashboardGuide(_alwaysPlayDashboardGuide);
    await PreferencesService.setGesturesEnabled(_gesturesEnabled);
    await PreferencesService.setFlashlightGestureEnabled(_flashlightGestureEnabled);
    await PreferencesService.setMicrophoneGestureEnabled(_microphoneGestureEnabled);
    await PreferencesService.setTtsSpeed(_ttsSpeed);
    await PreferencesService.setTtsVolume(_ttsVolume);
  }

  // Play audio feedback untuk button actions
  Future<void> _playButtonFeedback(String message) async {
    try {
      final ttsSpeed = await PreferencesService.getTtsSpeed();
      final ttsVolume = await PreferencesService.getTtsVolume();
      
      await flutterTts.setLanguage("id-ID");
      await flutterTts.setSpeechRate(ttsSpeed * 1.3);
      await flutterTts.setVolume(ttsVolume);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(message);
    } catch (e) {
      // kalo gagal, gapapa
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration( 
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgColor1, _bgColor2, _bgColor3],
            stops: const [0.25, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      size: 100,
                      color: _textColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Pengaturan Aplikasi',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                        fontFamily: 'Helvetica',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Always Show Onboarding Setting
                    _buildToggleContainer(
                      title: 'Selalu Tampilkan Panduan',
                      description: 'Tampilkan layar panduan setiap kali aplikasi dibuka',
                      value: _alwaysShowOnboarding,
                      onChanged: _toggleAlwaysShowOnboarding,
                    ),
                    const SizedBox(height: 10),

                    // Always Play Dashboard Guide Setting
                    _buildToggleContainer(
                      title: 'Putar Audio Panduan Dashboard',
                      description: 'Putar audio panduan setiap kali masuk ke halaman utama',
                      value: _alwaysPlayDashboardGuide,
                      onChanged: _toggleAlwaysPlayDashboardGuide,
                    ),
                    const SizedBox(height: 15),

                    // GESTURE SETTINGS SECTION
                    Text(
                      'Kontrol Gestur',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Enable/Disable Gestures
                    _buildToggleContainer(
                      title: 'Aktifkan Gestur',
                      description: 'Aktifkan atau nonaktifkan semua kontrol gestur',
                      value: _gesturesEnabled,
                      onChanged: (value) {
                        setState(() {
                          _gesturesEnabled = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // Gesture sub-options
                    if (_gesturesEnabled) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          children: [
                            _buildToggleContainer(
                              title: 'Gestur Senter',
                              description: 'Ketuk dua kali untuk menyalakan/mematikan senter',
                              value: _flashlightGestureEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _flashlightGestureEnabled = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildToggleContainer(
                              title: 'Gestur Mikrofon',
                              description: 'Tekan lama untuk menyalakan/mematikan mikrofon',
                              value: _microphoneGestureEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _microphoneGestureEnabled = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 15),

                    // TTS SETTINGS SECTION
                    Text(
                      'Suara Pembaca',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // TTS Speed Setting
                    _buildSliderSetting(
                      icon: Icons.speed,
                      title: 'Kecepatan Suara',
                      value: _ttsSpeed,
                      min: 0.3,
                      max: 0.8,
                      divisions: 2,
                      label: _ttsSpeed <= 0.35
                          ? 'Lambat (0.3x)'
                          : (_ttsSpeed <= 0.55 ? 'Sedang (0.5x)' : 'Cepat (0.8x)'),
                      onChanged: (value) {
                        setState(() {
                          _ttsSpeed = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // TTS Volume Setting
                    _buildSliderSetting(
                      icon: Icons.volume_up,
                      title: 'Volume Suara',
                      value: _ttsVolume,
                      min: 0.3,
                      max: 1.0,
                      divisions: 2,
                      label: _ttsVolume <= 0.4
                          ? 'Rendah (30%)'
                          : (_ttsVolume <= 0.8 ? 'Sedang (70%)' : 'Tinggi (100%)'),
                      onChanged: (value) {
                        setState(() {
                          _ttsVolume = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Semantics(
                          label: 'Tombol Batal. Kembali tanpa menyimpan perubahan',
                          button: true,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _playButtonFeedback('Batal');
                              await Future.delayed(const Duration(milliseconds: 600));
                              Navigator.of(context).pop(); // Kembali ke halaman sebelumnya (dashboard)
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Color(0xFF0D0D0D), width: 2.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            ),
                            child: Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 18,
                                color: const Color(0xFF0D0D0D),
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: 'Tombol Simpan. Menyimpan semua perubahan pengaturan',
                          button: true,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _playButtonFeedback('Menyimpan pengaturan');
                              await Future.delayed(const Duration(milliseconds: 1000));
                              await _saveSettings();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pengaturan disimpan!')),
                              );
                              Navigator.of(context).pop(); // Kembali ke halaman sebelumnya (dashboard)
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D0D0D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            ),
                            child: Text(
                              'Simpan!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //tombol back
            Positioned(
              top: 40,
              left: 20,
              child: Semantics(
                label: 'Tombol Kembali. Kembali ke halaman sebelumnya',
                button: true,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: _textColor, size: 30),
                  onPressed: () async {
                    await _playButtonFeedback('Kembali');
                    await Future.delayed(const Duration(milliseconds: 600));
                    Navigator.of(context).pop(); // Kembali ke dashboard
                  },
                  tooltip: 'Kembali',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // toggle pada setting
  Widget _buildToggleContainer({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((255 * 0.3).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                    fontFamily: 'Helvetica',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: _textColor.withAlpha((255 * 0.7).round()),
                    fontFamily: 'Helvetica',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _textColor,
          ),
        ],
      ),
    );
  }

  // radio slider pada setting
  Widget _buildSliderSetting({
    required IconData icon,
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((255 * 0.3).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: _textColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                  fontFamily: 'Helvetica',
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: label,
            onChanged: onChanged,
            activeColor: _textColor,
            inactiveColor: _textColor.withAlpha((255 * 0.3).round()),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: _textColor.withAlpha((255 * 0.7).round()),
              fontFamily: 'Helvetica',
            ),
          ),
        ],
      ),
    );
  }
}
