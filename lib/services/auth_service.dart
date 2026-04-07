import 'api_service.dart';
import 'storage_service.dart';

class AuthService {

  /// 🔐 LOGIN
  static Future<Map<String, dynamic>?> login(
    String phone,
    String password,
  ) async {
    try {
      final res = await ApiService.post('/login', {
        "phone": phone,
        "password": password,
      });

      if (res['token'] != null) {
        await StorageService.saveToken(res['token']);
      }

      return res;

    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  /// 📝 REGISTER
  static Future<bool> register(Map data) async {
    try {
      final res = await ApiService.post('/register', data);

      return res['success'] == true;

    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  /// 🚪 LOGOUT
  static Future<void> logout() async {
    await StorageService.clear();
  }

  /// 🔍 GET TOKEN
  static Future<String?> getToken() async {
    return await StorageService.getToken();
  }

  /// ❌ DELETE ACCOUNT (🔥 أهم جزء)
  static Future<bool> deleteAccount() async {
    try {
      final res = await ApiService.delete('/delete-my-account');

      return res['success'] == true;

    } catch (e) {
      print("Delete Account Error: $e");
      return false;
    }
  }
}