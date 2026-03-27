import 'package:flutter/material.dart';
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

  /// 🚪 LOGOUT
  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    notifyListeners();
  }
}