import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../routes/app_routes.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;

  const CategoryCard({required this.category});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),

      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.places,
          arguments: widget.category,
        );
      },

      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: isPressed ? 0.96 : 1,

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(0.15),
                offset: Offset(0, 6),
              )
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [

                /// 🖼 IMAGE
                Positioned.fill(
                  child: Image.network(
                    widget.category.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image),
                    ),
                  ),
                ),

                /// 🌑 OVERLAY
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                /// 🔥 GLASS CARD تحت
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),

                    child: Row(
                      children: [

                        /// 🎯 ICON
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.category,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(width: 8),

                        /// 🏷 TITLE
                        Expanded(
                          child: Text(
                            widget.category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// ⭐ BADGE
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "HOT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}