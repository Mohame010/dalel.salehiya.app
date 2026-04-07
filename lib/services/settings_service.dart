import 'api_service.dart';

class SettingsService {
  static Future<bool> requireLogin() async {
    try {
      final res = await ApiService.get('/settings');

      /// 🔥 الحل هنا
      return res['require_login'] == 1 || res['require_login'] == true;

    } catch (e) {
      print("Settings Error: $e");
      return false;
    }
  }
}