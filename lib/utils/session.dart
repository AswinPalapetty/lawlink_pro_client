import 'package:shared_preferences/shared_preferences.dart';

class SessionManagement {
  static Future<void> storeUserData(String name, String email, String userId, String  phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('userId', userId);
    await prefs.setString('phone', phone);
  }

  static Future<Map<String, String>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('name') ?? 'Aswin';
    final String email = prefs.getString('email') ?? '';
    final String userId = prefs.getString('userId') ?? '';
    final String phone = prefs.getString('phone') ?? '';
    return {'name': name, 'email': email, 'userId': userId, 'phone': phone};
  }

  static Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('userId');
    await prefs.remove('phone');
  }
}