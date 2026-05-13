import 'package:flutter/material.dart';

class RecentlyProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _recent = [];

  List<Map<String, dynamic>> get recent => _recent;

  void addPlace(Map<String, dynamic> place) {
    _recent.removeWhere((e) => e['id'] == place['id']);

    _recent.insert(0, place);

    if (_recent.length > 5) {
      _recent.removeLast();
    }

    notifyListeners();
  }
}