import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  Future<void> loadHome() async {
    _loading = true;
    notifyListeners();

    final box = Hive.box('appData');

    try {
      final catRes = await ApiService.get('/categories');
      final adRes = await ApiService.get('/ads');

      _categories = (catRes as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      _ads = (adRes as List)
          .map((e) => AdModel.fromJson(e))
          .toList();

      /// 💾 Save
      await box.put('categories', catRes);
      await box.put('ads', adRes);

      print("🔥 FROM API");

    } catch (e) {

      print("⚠️ FROM CACHE");

      final cachedCategories = box.get('categories') ?? [];
      final cachedAds = box.get('ads') ?? [];

      /// 🔥 الحل هنا
      _categories = (cachedCategories as List)
          .map((e) => CategoryModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();

      _ads = (cachedAds as List)
          .map((e) => AdModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    }

    _loading = false;
    notifyListeners();
  }
}