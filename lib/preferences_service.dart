import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PreferencesService {
  static const String _keyFirstRun = 'first_run';
  static const String _keyAlwaysShowOnboarding = 'always_show_onboarding';
  static const String _keyAlwaysPlayDashboardGuide = 'always_play_dashboard_guide';

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
      return true; // Default to showing onboarding on error
    }
  }
}
