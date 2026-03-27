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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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
                  backgroundColor: Color(0xFF0D9488),
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
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  iconTheme: IconThemeData(color: Colors.black),

                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      place.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
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
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.red),
                              SizedBox(width: 8),
                              Expanded(child: Text(place.address)),
                            ],
                          ),
                        ),

                        SizedBox(height: 15),

                        /// 🕒 Time Card
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
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

                        SizedBox(height: 20),

                        /// 📞 Phone Card
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.phone, color: Colors.teal),
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
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
}