import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  // Remove WebSocketManager instance as we don't need to notify from here anymore
  // Notifications will be handled by the actual sensor updates coming through WebSocket

  // Default values
  static const double defaultLightLevel = 999;
  static const double defaultTemperature = 999;
  static const double defaultSmokeLevel = -999;

  // Save light level
  static Future<void> saveLightLevel(double lightLevel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('light_level', lightLevel);
    print('Light level saved: $lightLevel');

    // No need to manually notify - the actual light sensor update will trigger automations
  }

  static Future<double> getLightLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('light_level') ?? defaultLightLevel;
  }

  // Save temperature
  static Future<void> saveTemperature(double temperature) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('temperature', temperature);
    print('Temperature saved: $temperature');

    // No need to manually notify
  }

  static Future<double> getTemperature() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('temperature') ?? defaultTemperature;
  }

  // Save smoke level
  static Future<void> saveSmokeLevel(double smokeLevel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('smoke_level', smokeLevel);
    print('Smoke level saved: $smokeLevel');

    // No need to manually notify
  }

  static Future<double> getSmokeLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('smoke_level') ?? defaultSmokeLevel;
  }

  // Clear all preferences (optional)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('light_level');
    await prefs.remove('temperature');
    await prefs.remove('smoke_level');
  }
}