import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/ad_model.dart';
import '../services/api_service.dart';

class HomeProvider with ChangeNotifier {

  List<CategoryModel> _categories = [];
  List<AdModel> _ads = [];

  bool _loading = false;

  List<CategoryModel> get categories => _categories;
  List<AdModel> get ads => _ads;
  bool get loading => _loading;

  /// 📊 Load Home Data
  Future<void> loadHome() async {
    _loading = true;
    notifyListeners();

    try {
      final catRes = await ApiService.get('/categories');
      final adRes = await ApiService.get('/ads');

      _categories = (catRes as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      _ads = (adRes as List)
          .map((e) => AdModel.fromJson(e))
          .toList();

    } catch (e) {
      print("Home Error: $e");
    }

    _loading = false;
    notifyListeners();
  }
}