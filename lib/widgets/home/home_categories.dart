import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/category_model.dart';

class HomeCategories extends StatelessWidget {
  final List<CategoryModel> categories;

  const HomeCategories({required this.categories});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categories.length,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.9,
        ),

        itemBuilder: (context, index) {

          final cat = categories[index];
          final theme = Theme.of(context);

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/places',
                arguments: cat,
              );
            },

            child: Container(
              padding: EdgeInsets.all(12),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.08),
                  )
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// 🖼 IMAGE (🔥 Cached)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: cat.image,
                      height: 65,
                      width: 65,
                      fit: BoxFit.cover,

                      placeholder: (_, __) => Container(
                        height: 65,
                        width: 65,
                        color: Colors.grey[200],
                      ),

                      errorWidget: (_, __, ___) =>
                          Icon(Icons.image, size: 30),

                      memCacheWidth: 200,
                      memCacheHeight: 200,
                    ),
                  ),

                  SizedBox(height: 10),

                  /// 📄 NAME
                  Text(
                    cat.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}