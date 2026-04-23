import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../models/place_model.dart';
import '../../models/item_model.dart';
import '../../services/api_service.dart';
import '../../services/favorite_service.dart';
import '../../services/storage_service.dart';
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

  bool isFav = false;

  double rating = 0;
  int ratingCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      place = ModalRoute.of(context)!.settings.arguments as PlaceModel;

      isFav = FavoriteService.isFavorite(place.id);

      loadItems(place.id);
      loadRating(place.id);

      _loaded = true;
    }
  }

  Future<void> loadRating(int placeId) async {
    try {
      final res = await ApiService.get('/place-rating/$placeId');

      setState(() {
        rating = (res['rating'] ?? 0).toDouble();
        ratingCount = res['count'] ?? 0;
      });

    } catch (e) {
      print("rating error");
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

  Future<void> submitRating(double value) async {
    try {
      await ApiService.post('/rate', {
        "place_id": place.id,
        "rating": value,
      });

      loadRating(place.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text("تم إرسال تقييمك بنجاح ⭐"),
            ],
          ),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حصل خطأ ❌")),
      );
    }
  }

  String getRatingEmoji(double rating) {
    if (rating >= 4.5) return "🔥";
    if (rating >= 4) return "😍";
    if (rating >= 3) return "🙂";
    if (rating >= 2) return "😐";
    return "😕";
  }

  void showRatingDialog() async {
    final token = await StorageService.getToken();

    if (token == null) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text("تسجيل مطلوب"),
            content: Text("سجل دخول علشان تقدر تقيم ⭐"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("لاحقًا"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/login");
                },
                child: Text("تسجيل الدخول"),
              ),
            ],
          );
        },
      );
      return;
    }

    double userRating = 3;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "قيّم المكان",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              RatingBar.builder(
                initialRating: userRating,
                minRating: 1,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 42,
                glow: true,
                glowColor: Colors.orange,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  userRating = value;
                },
              ),

              SizedBox(height: 10),

              Text(
                "${userRating.toStringAsFixed(1)} / 5",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    submitRating(userRating);
                    Navigator.pop(context);
                  },
                  child: Text("إرسال التقييم"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget ratingSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade50,
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.15),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [

          Column(
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 4),
              Text("$ratingCount تقييم"),
              SizedBox(height: 6),
              Text(
                getRatingEmoji(rating),
                style: TextStyle(fontSize: 26),
              ),
            ],
          ),

          SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                RatingBarIndicator(
                  rating: rating,
                  itemCount: 5,
                  itemSize: 22,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),

                SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: rating / 5,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(Colors.orange),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10),

          ElevatedButton(
            onPressed: showRatingDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("قيّم"),
          ),
        ],
      ),
    );
  }

  Future<void> call() async {
    if (place.phone == null || place.phone!.isEmpty) return;

    final uri = Uri.parse("tel:${place.phone}");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

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

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [

            Expanded(
              child: ElevatedButton.icon(
                onPressed: call,
                icon: Icon(Icons.phone),
                label: Text("اتصل"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            SizedBox(width: 10),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: whatsapp,
                icon: Icon(Icons.chat),
                label: Text("واتساب"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [

                  SliverAppBar(
                    expandedHeight: 250,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        place.name,
                        style: TextStyle(
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.black)
                          ],
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: place.image ?? "",
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black54
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 10),

                          /// ⭐ التقييم الجديد
                          ratingSection(),

                          SizedBox(height: 15),

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
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
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
      ),
    );
  }

  Widget _card(ThemeData theme, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                theme.colorScheme.primary.withOpacity(0.1),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
