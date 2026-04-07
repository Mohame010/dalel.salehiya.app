import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SearchProvider with ChangeNotifier {
  List places = [];
  List items = [];
  bool loading = false;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      places = [];
      items = [];
      notifyListeners();
      return;
    }

    loading = true;
    notifyListeners();

    try {
      final res = await ApiService.search(query);

      places = res['places'] ?? [];
      items = res['items'] ?? [];

    } catch (e) {
      print("Search Error: $e");
    }

    loading = false;
    notifyListeners();
  }

  void clear() {
    places = [];
    items = [];
    notifyListeners();
  }
}