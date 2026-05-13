import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الإشعارات"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _item(
            title: "مكان جديد تمت إضافته",
            subtitle: "مطعم الشيف الجديد متاح الآن",
          ),
          _item(
            title: "خصومات جديدة",
            subtitle: "خصم 20% على بعض المطاعم",
          ),
          _item(
            title: "أماكن مقترحة لك",
            subtitle: "أماكن قريبة قد تعجبك",
          ),
        ],
      ),
    );
  }

  Widget _item({required String title, required String subtitle}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.notifications_active),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}