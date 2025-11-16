import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aitunanetra/preferences_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Onboarding setting
  bool _alwaysShowOnboarding = false;
  
  // Gesture settings
  bool _gesturesEnabled = true;
  bool _flashlightGestureEnabled = true;
  bool _microphoneGestureEnabled = true;
  
  // TTS settings
  double _ttsSpeed = 0.8; // 0.3, 0.5, 0.8
  double _ttsVolume = 1.0; // 0.3, 0.7, 1.0
  
  // Vibration intensity: 0 = light, 1 = medium, 2 = heavy
  int _vibrationIntensity = 2; // default heavy

  // Warna default aplikasi
  Color _bgColor1 = const Color(0xFFEEF26B);
  Color _bgColor2 = const Color(0xFFEAF207);
  Color _bgColor3 = const Color(0xFFEBFF52);
  Color _textColor = const Color(0xFF0D0D0D);

  @override
  void initState() {
    super.initState();
    _loadSettings();
    
    // Maintain fullscreen mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  Future<void> _loadSettings() async {
    final alwaysShow = await PreferencesService.getAlwaysShowOnboarding();
    setState(() {
      _alwaysShowOnboarding = alwaysShow;
    });
  }

  Future<void> _toggleAlwaysShowOnboarding(bool value) async {
    await PreferencesService.setAlwaysShowOnboarding(value);
    setState(() {
      _alwaysShowOnboarding = value;
    });
  }

  // dispose berfungsi untuk mematikan animasi ketika aplikasi ditutup
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration( //warna background
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
                      'App Setting',
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
                      title: 'Always Show Onboarding',
                      description: 'Show boarding screen every time app starts',
                      value: _alwaysShowOnboarding,
                      onChanged: _toggleAlwaysShowOnboarding,
                    ),
                    const SizedBox(height: 15),

                    // GESTURE SETTINGS SECTION
                    Text(
                      'Gesture Controls',
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
                      title: 'Enable Gestures',
                      description: 'Enable or disable all gesture controls',
                      value: _gesturesEnabled,
                      onChanged: (value) {
                        setState(() {
                          _gesturesEnabled = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // Gesture sub-options (only show if gestures enabled)
                    if (_gesturesEnabled) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          children: [
                            _buildToggleContainer(
                              title: 'Flashlight Gesture',
                              description: 'Double-tap to toggle flashlight',
                              value: _flashlightGestureEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _flashlightGestureEnabled = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildToggleContainer(
                              title: 'Microphone Gesture',
                              description: 'Long-press to toggle microphone',
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
                      'Text-to-Speech',
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
                      title: 'TTS Speed',
                      value: _ttsSpeed,
                      min: 0.3,
                      max: 0.8,
                      divisions: 2,
                      label: _ttsSpeed <= 0.35
                          ? 'Slow (0.3x)'
                          : (_ttsSpeed <= 0.55 ? 'Medium (0.5x)' : 'Fast (0.8x)'),
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
                      title: 'TTS Volume',
                      value: _ttsVolume,
                      min: 0.3,
                      max: 1.0,
                      divisions: 2,
                      label: _ttsVolume <= 0.4
                          ? 'Low (30%)'
                          : (_ttsVolume <= 0.8 ? 'Medium (70%)' : 'High (100%)'),
                      onChanged: (value) {
                        setState(() {
                          _ttsVolume = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),

                    // VIBRATION SETTINGS SECTION
                    Text(
                      'Haptic Feedback',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Vibration Intensity Setting
                    Container(
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
                              Icon(Icons.vibration, size: 24, color: _textColor),
                              const SizedBox(width: 8),
                              Text(
                                'Vibration Intensity',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                  fontFamily: 'Helvetica',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildVibrationButton('Light', 0),
                              _buildVibrationButton('Medium', 1),
                              _buildVibrationButton('Heavy', 2),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
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
                            'Cancel',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xFF0D0D0D),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
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
                            'Save!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'Helvetica',
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
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: _textColor, size: 30),
                onPressed: () {
                  Navigator.of(context).pop(); // Kembali ke halaman sebelumnya (Dashboard)
                },
                tooltip: 'Kembali',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membuat toggle container
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

  // Helper method untuk slider settings
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

  // Helper method untuk vibration intensity buttons
  Widget _buildVibrationButton(String label, int intensity) {
    bool isSelected = _vibrationIntensity == intensity;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _vibrationIntensity = intensity;
            });
            // Test vibration when selected
            if (intensity == 0) {
              HapticFeedback.lightImpact();
            } else if (intensity == 1) {
              HapticFeedback.mediumImpact();
            } else {
              HapticFeedback.heavyImpact();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? _textColor : Colors.white,
            foregroundColor: isSelected ? Colors.white : _textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: _textColor, width: 2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Helvetica',
            ),
          ),
        ),
      ),
    );
  }
}
