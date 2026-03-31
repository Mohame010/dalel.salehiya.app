import 'package:flutter/material.dart';
import '../../models/transport_model.dart';

class TransportCard extends StatelessWidget {
  final TransportModel route;

  const TransportCard({required this.route});

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 HEADER (type + price)
          Row(
            children: [

              /// TYPE CHIP
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  route.type,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Spacer(),

              /// PRICE
              Text(
                "${route.price} ج",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 18),

          /// 🔥 ROUTE (modern layout)
          Row(
            children: [

              /// LINE
              Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 35,
                    color: Colors.grey.shade400,
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 14),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      route.from,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      route.to,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          /// 🔥 META (time + action)
          Row(
            children: [

              Icon(Icons.access_time,
                  size: 16, color: Colors.grey),

              SizedBox(width: 6),

              Text(
                route.time ?? "-",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              Spacer(),

              /// subtle action
              Text(
                "عرض التفاصيل",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}