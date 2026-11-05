import 'package:shared_preferences/shared_preferences.dart';

class IpRepository {
  static const _ipKey = 'home_assistant_ip';
  static const _defaultIp = '192.168.1.9';

  // Save a new IP address
  Future<void> setIp(String newIp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ipKey, newIp);
  }

  // Load the current IP address
  Future<String> getIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ipKey) ?? _defaultIp;
  }
}
