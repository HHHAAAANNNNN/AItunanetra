import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PreferencesService {
  static const String _keyFirstRun = 'first_run';
  static const String _keyAlwaysShowOnboarding = 'always_show_onboarding';
  static const String _keyAlwaysPlayDashboardGuide = 'always_play_dashboard_guide';
  static const String _keyGesturesEnabled = 'gestures_enabled';
  static const String _keyFlashlightGestureEnabled = 'flashlight_gesture_enabled';
  static const String _keyMicrophoneGestureEnabled = 'microphone_gesture_enabled';
  static const String _keyTtsSpeed = 'tts_speed';
  static const String _keyTtsVolume = 'tts_volume';
  static const String _keyHasPlayedDashboardGuide = 'has_played_dashboard_guide';

  // Check if this is the first run
  static Future<bool> isFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstRun) ?? true;
  }

  // Mark that the app has been run
  static Future<void> setFirstRunCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstRun, false);
  }

  // Get "Always show onboarding" setting
  static Future<bool> getAlwaysShowOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAlwaysShowOnboarding) ?? false;
  }

  // Set "Always show onboarding" setting
  static Future<void> setAlwaysShowOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAlwaysShowOnboarding, value);
  }

  // Get "Always play dashboard guide" setting
  static Future<bool> getAlwaysPlayDashboardGuide() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAlwaysPlayDashboardGuide) ?? false;
  }

  // Set "Always play dashboard guide" setting
  static Future<void> setAlwaysPlayDashboardGuide(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAlwaysPlayDashboardGuide, value);
  }

  // Get "Gestures enabled" setting
  static Future<bool> getGesturesEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyGesturesEnabled) ?? true;
  }

  // Set "Gestures enabled" setting
  static Future<void> setGesturesEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyGesturesEnabled, value);
  }

  // Get "Flashlight gesture enabled" setting
  static Future<bool> getFlashlightGestureEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFlashlightGestureEnabled) ?? true;
  }

  // Set "Flashlight gesture enabled" setting
  static Future<void> setFlashlightGestureEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFlashlightGestureEnabled, value);
  }

  // Get "Microphone gesture enabled" setting
  static Future<bool> getMicrophoneGestureEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyMicrophoneGestureEnabled) ?? true;
  }

  // Set "Microphone gesture enabled" setting
  static Future<void> setMicrophoneGestureEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMicrophoneGestureEnabled, value);
  }

  // Get TTS speed setting
  static Future<double> getTtsSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyTtsSpeed) ?? 0.5;
  }

  // Set TTS speed setting
  static Future<void> setTtsSpeed(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTtsSpeed, value);
  }

  // Get TTS volume setting
  static Future<double> getTtsVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyTtsVolume) ?? 1.0;
  }

  // Set TTS volume setting
  static Future<void> setTtsVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTtsVolume, value);
  }

  // Get "Has played dashboard guide" flag
  static Future<bool> getHasPlayedDashboardGuide() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasPlayedDashboardGuide) ?? false;
  }

  // Set "Has played dashboard guide" flag
  static Future<void> setHasPlayedDashboardGuide(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasPlayedDashboardGuide, value);
  }

  // Check if onboarding should be shown (first run OR always show enabled)
  static Future<bool> shouldShowOnboarding() async {
    try {
      final isFirst = await isFirstRun();
      final alwaysShow = await getAlwaysShowOnboarding();
      
      if (kDebugMode) {
        debugPrint('PreferencesService: isFirst=$isFirst, alwaysShow=$alwaysShow');
      }
      
      return isFirst || alwaysShow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('PreferencesService ERROR: $e');
      }
      return true;
    }
  }
}
