import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeBanner extends StatefulWidget {
  final List ads;

  const HomeBanner({required this.ads});

  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {

  int current = 0;

  @override
  Widget build(BuildContext context) {

    if (widget.ads.isEmpty) return SizedBox();

    return Column(
      children: [

        /// 🎞 Slider
        CarouselSlider(
          options: CarouselOptions(
            height: 170,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() => current = index);
            },
          ),

          items: widget.ads.map((ad) {
            return GestureDetector(
              onTap: () async {

                final url = ad.link;

                if (url != null && url != "") {
                  final uri = Uri.parse(url);

                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },

              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                    )
                  ],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [

                      /// 🖼 IMAGE (🔥 Cached)
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: ad.image,
                          fit: BoxFit.cover,

                          placeholder: (_, __) => Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),

                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.image),
                          ),

                          memCacheWidth: 800,
                          memCacheHeight: 400,
                        ),
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
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 10),

        /// 🔵 Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.ads.asMap().entries.map((entry) {
            return Container(
              width: current == entry.key ? 14 : 6,
              height: 6,
              margin: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: current == entry.key
                    ? Color(0xFF03819B)
                    : Colors.grey,
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}