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

  late CategoryModel category;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      category =
          ModalRoute.of(context)!.settings.arguments as CategoryModel;

      loadPlaces(category.id);
      _loaded = true;
    }
  }

  Future<void> loadPlaces(int categoryId) async {
    final box = Hive.box('appData');

    setState(() => loading = true);

    try {
      print("🔥 CALL API");

      final res = await ApiService.get('/places/$categoryId');

      places = (res as List)
          .map((e) => PlaceModel.fromJson(e))
          .toList();

      await box.put('places_$categoryId', res);

      print("✅ FROM API");

    } catch (e) {
      print("⚠️ API FAILED → LOAD CACHE");

      final cached = box.get('places_$categoryId') ?? [];

      places = (cached as List)
          .map((e) => PlaceModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    }

    if (!mounted) return;

    setState(() => loading = false);
  }

  Future<void> _refresh() async {
    await loadPlaces(category.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),

      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : places.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store_mall_directory_outlined,
                          size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        "لا يوجد أماكن",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      return PlaceCard(place: places[index]);
                    },
                  ),
                ),
    );
  }
}