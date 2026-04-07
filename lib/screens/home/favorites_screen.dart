import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../services/api_service.dart';
import '../../services/favorite_service.dart';
import '../../widgets/cards/place_card.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  List<PlaceModel> places = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favIds = FavoriteService.getFavorites();

    if (favIds.isEmpty) {
      setState(() {
        loading = false;
      });
      return;
    }

    try {
      final res = await ApiService.get('/all-places');

      final all = (res as List)
          .map((e) => PlaceModel.fromJson(e))
          .toList();

      places = all.where((p) => favIds.contains(p.id)).toList();

    } catch (e) {
      print("Fav Error: $e");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("المفضلة ❤️")),

      body: loading
          ? Center(child: CircularProgressIndicator())

          : places.isEmpty
              ? Center(child: Text("لا يوجد مفضلة"))
              : ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return PlaceCard(place: places[index]);
                  },
                ),
    );
  }
}