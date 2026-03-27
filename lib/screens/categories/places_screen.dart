import 'package:flutter/material.dart';

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

  bool _loaded = false; // 🔥 مهم جدًا

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
  try {
    print("🔥 CALL API");
    print("Category ID: $categoryId");

    final res = await ApiService.get('/places/$categoryId');

    print("API RESPONSE: $res");

    places = (res as List)
        .map((e) => PlaceModel.fromJson(e))
        .toList();

    print("PLACES LENGTH: ${places.length}");

  } catch (e) {
    print("ERROR: $e");
  }

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