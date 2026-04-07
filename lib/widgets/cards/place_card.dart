import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/favorite_service.dart'; // 🔥 جديد

class PlaceCard extends StatefulWidget {
  final PlaceModel place;

  const PlaceCard({required this.place});

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {

  bool isPressed = false;
  bool isFav = false;

  @override
  void initState() {
    super.initState();

    /// ❤️ حالة المفضلة
    isFav = FavoriteService.isFavorite(widget.place.id);
  }

  @override
  Widget build(BuildContext context) {

    final place = widget.place;

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),

      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.placeDetails,
          arguments: place,
        );
      },

      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: isPressed ? 0.97 : 1,

        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                color: Colors.black.withOpacity(0.08),
                offset: Offset(0, 6),
              )
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🖼 IMAGE
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [

                    CachedNetworkImage(
                      imageUrl: place.image,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,

                      placeholder: (context, url) => Container(
                        height: 160,
                        color: Colors.grey[200],
                        child: Center(child: CircularProgressIndicator()),
                      ),

                      errorWidget: (context, url, error) => Container(
                        height: 160,
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 40),
                      ),

                      memCacheWidth: 400,
                      memCacheHeight: 300,
                    ),

                    /// 🌑 Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                    /// ⭐ Badge
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "مميز",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                    /// ❤️ FAVORITE BUTTON 🔥
                    Positioned(
                      top: 10,
                      left: 10,
                      child: GestureDetector(
                        onTap: () async {
                          await FavoriteService.toggle(place.id);

                          setState(() {
                            isFav = !isFav;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 📄 INFO
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🏷 Name
                    Text(
                      place.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 6),

                    /// 📍 Address
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.red),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6),

                    /// 📞 Phone
                    Row(
                      children: [
                        Icon(Icons.phone,
                            size: 16, color: Colors.teal),
                        SizedBox(width: 4),
                        Text(
                          place.phone,
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}