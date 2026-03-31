import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/place_model.dart';
import '../../models/item_model.dart';
import '../../services/api_service.dart';
import '../../widgets/cards/item_card.dart';

class PlaceDetailsScreen extends StatefulWidget {
  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {

  List<ItemModel> items = [];
  bool loading = true;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      final place =
          ModalRoute.of(context)!.settings.arguments as PlaceModel;

      loadItems(place.id);

      _loaded = true;
    }
  }

  Future<void> loadItems(int placeId) async {
    try {
      final res = await ApiService.get('/items/$placeId');

      items = (res as List)
          .map((e) => ItemModel.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {

    final place =
        ModalRoute.of(context)!.settings.arguments as PlaceModel;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// 🔘 Bottom Buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [

            /// 📞 Call
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  launchUrl(Uri.parse("tel:${place.phone}"));
                },
                icon: Icon(Icons.phone),
                label: Text("اتصل"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
              ),
            ),

            SizedBox(width: 10),

            /// 💬 WhatsApp
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  launchUrl(
                    Uri.parse("https://wa.me/${place.whatsapp}"),
                  );
                },
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

                /// 🖼 Image
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  iconTheme: IconThemeData(
                    color: theme.iconTheme.color,
                  ),

                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      place.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: theme.cardColor,
                        child: Icon(Icons.image, size: 50),
                      ),
                    ),
                  ),
                ),

                /// 📄 Details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 🏷 Name
                        Text(
                          place.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        /// 📍 Address Card
                        _buildCard(
                          context,
                          child: Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: theme.colorScheme.error),
                              SizedBox(width: 8),
                              Expanded(child: Text(place.address)),
                            ],
                          ),
                        ),

                        SizedBox(height: 15),

                        /// 🕒 Time Card
                        _buildCard(
                          context,
                          child: Column(
                            children: [

                              Row(
                                children: [
                                  Icon(Icons.access_time),
                                  SizedBox(width: 8),
                                  Text("${place.openTime} - ${place.closeTime}"),
                                ],
                              ),

                              SizedBox(height: 6),

                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 18),
                                  SizedBox(width: 8),
                                  Text(place.workingDays),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15),

                        /// 📞 Phone Card
                        _buildCard(
                          context,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          child: Row(
                            children: [
                              Icon(Icons.phone,
                                  color: theme.colorScheme.primary),
                              SizedBox(width: 8),
                              Text(place.phone),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        /// 🍔 Items Title
                        Text(
                          "المنتجات",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
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
                )
              ],
            ),
    );
  }

  /// 💎 Reusable Card (Dark Mode Safe)
  Widget _buildCard(BuildContext context,
      {required Widget child, Color? color}) {

    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: child,
    );
  }
}