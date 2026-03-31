import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _loading = false;

  UserModel? get user => _user;
  bool get loading => _loading;

  /// 🔐 LOGIN
  Future<bool> login(String phone, String password) async {
    _loading = true;
    notifyListeners();

    final res = await AuthService.login(phone, password);

    _loading = false;

    if (res != null && res['success'] == true) {
      _user = UserModel.fromJson(res['user']);

      /// ✅ حفظ البيانات
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", _user!.name);
      await prefs.setString("phone", _user!.phone);

      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  /// 📝 REGISTER
  Future<bool> register(Map data) async {
    _loading = true;
    notifyListeners();

    final success = await AuthService.register(data);

    _loading = false;
    notifyListeners();

    return success;
  }

  /// 🔄 LOAD USER (🔥 أهم جزء)
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString("name");
    final phone = prefs.getString("phone");

    if (name != null) {
      _user = UserModel.fromJson({
        "name": name,
        "phone": phone ?? "",
      });

      notifyListeners();
    }
  }

  /// 🚪 LOGOUT
  Future<void> logout() async {
    await AuthService.logout();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _user = null;
    notifyListeners();
  }
}