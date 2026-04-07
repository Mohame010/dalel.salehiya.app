import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/place_model.dart';
import '../../models/item_model.dart';
import '../../services/api_service.dart';
import '../../services/favorite_service.dart'; // 🔥 جديد
import '../../widgets/cards/item_card.dart';

class PlaceDetailsScreen extends StatefulWidget {
  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {

  List<ItemModel> items = [];
  bool loading = true;
  bool _loaded = false;

  late PlaceModel place;

  bool isFav = false; // ❤️ جديد

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      place =
          ModalRoute.of(context)!.settings.arguments as PlaceModel;

      /// ❤️ حالة المفضلة
      isFav = FavoriteService.isFavorite(place.id);

      loadItems(place.id);
      _loaded = true;
    }
  }

  Future<void> loadItems(int placeId) async {
    final box = Hive.box('appData');

    try {
      final res = await ApiService.get('/items/$placeId');

      items = (res as List)
          .map((e) => ItemModel.fromJson(e))
          .toList();

      await box.put('items_$placeId', res);

    } catch (e) {

      final cached = box.get('items_$placeId') ?? [];

      items = (cached as List)
          .map((e) => ItemModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    }

    setState(() => loading = false);
  }

  /// 📞 اتصال
  Future<void> call() async {
    if (place.phone == null || place.phone!.isEmpty) return;

    final uri = Uri.parse("tel:${place.phone}");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// 💬 واتساب
  Future<void> whatsapp() async {
    if (place.whatsapp == null || place.whatsapp!.isEmpty) return;

    final uri = Uri.parse("https://wa.me/${place.whatsapp}");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// ❤️ Favorite Button
      appBar: AppBar(
        title: Text(place.name),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () async {
              await FavoriteService.toggle(place.id);

              setState(() {
                isFav = !isFav;
              });
            },
          ),
        ],
      ),

      /// 🔘 Buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [

            Expanded(
              child: ElevatedButton.icon(
                onPressed: call,
                icon: Icon(Icons.phone),
                label: Text("اتصل"),
              ),
            ),

            SizedBox(width: 10),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: whatsapp,
                icon: Icon(Icons.chat),
                label: Text("واتساب"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),

      body: loading
          ? Center(child: CircularProgressIndicator())

          : CustomScrollView(
              slivers: [

                /// 🖼 IMAGE
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  backgroundColor: theme.scaffoldBackgroundColor,

                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      imageUrl: place.image ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// 📄 DETAILS
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          place.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        if (place.address != null)
                          _card(theme, Icons.location_on, place.address!),

                        SizedBox(height: 10),

                        if (place.openTime != null &&
                            place.closeTime != null)
                          _card(
                            theme,
                            Icons.access_time,
                            "${place.openTime} - ${place.closeTime}",
                          ),

                        SizedBox(height: 10),

                        if (place.workingDays != null)
                          _card(
                            theme,
                            Icons.calendar_today,
                            place.workingDays!,
                          ),

                        SizedBox(height: 20),

                        Text(
                          "المنتجات",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        items.isEmpty
                            ? Center(child: Text("لا يوجد منتجات"))
                            : GridView.builder(
                                shrinkWrap: true,
                                physics:
                                    NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                ),
                                itemBuilder: (context, index) {
                                  return ItemCard(item: items[index]);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _card(ThemeData theme, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}