import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static const String _storageKey = 'user_id';

  Future<String?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_storageKey)) {
      return null;
    }
    return prefs.getString(_storageKey);
  }

  Future<void> saveUserID(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, userId);
  }
}
