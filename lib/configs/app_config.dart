import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
   static const String smtpUsername = 'YOUR_SMTP_USERNAME';
   static const String smtpPassword = 'YOUR_SMTP_PASSWORD';
   static const String senderEmail = 'YOUR_SENDER_EMAIL';

  static String? _cachedIp;

  // This method loads the IP address from SharedPreferences and caches it
  static Future<void> loadIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedIp = prefs.getString('home_assistant_ip'); // Load IP from preferences
  }

  // This method allows synchronous access to the IP address after it has been loaded
  static String? get ipAddress => _cachedIp;

  // This method saves the IP address to SharedPreferences and caches it
  static Future<void> saveIpAddress(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('home_assistant_ip', ip); // Save to preferences
    _cachedIp = ip; // Cache the IP address for future use
  }
}
