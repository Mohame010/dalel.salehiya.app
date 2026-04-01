import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/category_model.dart';
import '../../models/place_model.dart';
import '../../services/api_service.dart';
import '../../widgets/cards/place_card.dart';

class PlacesScreen extends StatefulWidget {
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  List<PlaceModel> places = [];
  bool loading = true;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      final category =
          ModalRoute.of(context)!.settings.arguments as CategoryModel;

      loadPlaces(category.id);
      _loaded = true;
    }
  }

  Future<void> loadPlaces(int categoryId) async {
    final box = Hive.box('appData');

    try {
      print("🔥 CALL API");

      final res = await ApiService.get('/places/$categoryId');

      places = (res as List)
          .map((e) => PlaceModel.fromJson(e))
          .toList();

      /// 💾 Save per category
      await box.put('places_$categoryId', res);

      print("✅ FROM API");
    } catch (e) {
      print("⚠️ API FAILED → LOAD CACHE");

      /// 📦 Load from cache
      final cached = box.get('places_$categoryId') ?? [];

      places = (cached as List)
          .map((e) => PlaceModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    }

    /// ✅ دا لازم يكون برا try/catch
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final category =
        ModalRoute.of(context)!.settings.arguments as CategoryModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : places.isEmpty
              ? Center(
                  child: Text(
                    "لا يوجد أماكن",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return PlaceCard(place: places[index]);
                  },
                ),
    );
  }
}