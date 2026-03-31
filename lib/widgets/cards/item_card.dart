import 'package:flutter/material.dart';
import '../../models/item_model.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;

  const ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🖼 IMAGE
          AspectRatio(
            aspectRatio: 1.2, // 🔥 أهم حاجة تمنع الفراغ
            child: ClipRRect(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: theme.cardColor,
                  child: Icon(Icons.image, size: 30),
                ),
              ),
            ),
          ),

          /// 📄 INFO
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// NAME
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 4),

                /// PRICE
                Text(
                  "${item.price} ج",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}