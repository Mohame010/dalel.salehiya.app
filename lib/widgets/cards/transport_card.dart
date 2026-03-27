import 'package:flutter/material.dart';
import '../../models/transport_model.dart';

class TransportCard extends StatefulWidget {
  final TransportModel route;

  const TransportCard({required this.route});

  @override
  _TransportCardState createState() => _TransportCardState();
}

class _TransportCardState extends State<TransportCard> {

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {

    final route = widget.route;

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),

      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: isPressed ? 0.96 : 1,

        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(0.08),
                offset: Offset(0, 8),
              )
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 TOP (TYPE + PRICE)
              Row(
                children: [

                  /// 🚗 TYPE
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF0D9488).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      route.type,
                      style: TextStyle(
                        color: Color(0xFF0D9488),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  Spacer(),

                  /// 💰 PRICE
                  Text(
                    "${route.price} ج",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              /// 🔥 ROUTE TIMELINE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 📍 TIMELINE
                  Column(
                    children: [

                      /// START DOT
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),

                      /// LINE
                      Container(
                        width: 2,
                        height: 30,
                        color: Colors.grey[400],
                      ),

                      /// END DOT
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 12),

                  /// 📄 TEXTS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// FROM
                        Text(
                          route.from,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 16),

                        /// TO
                        Text(
                          route.to,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}