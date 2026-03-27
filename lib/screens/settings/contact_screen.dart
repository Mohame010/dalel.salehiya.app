import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {

  void call() async {
    await launchUrl(Uri.parse("tel:01000000000"));
  }

  void whatsapp() async {
    await launchUrl(Uri.parse("https://wa.me/201000000000"));
  }

  void email() async {
    await launchUrl(Uri.parse("mailto:support@app.com"));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("تواصل معنا"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔥 Header Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF0D9488),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(Icons.support_agent,
                      size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "فريق الدعم",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  Text(
                    "نحن هنا لمساعدتك",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// 📞 Call
            _item(
              icon: Icons.phone,
              title: "اتصل بنا",
              onTap: call,
            ),

            /// 💬 WhatsApp
            _item(
              icon: Icons.message,
              title: "واتساب",
              onTap: whatsapp,
            ),

            /// 📧 Email
            _item(
              icon: Icons.email,
              title: "البريد الإلكتروني",
              onTap: email,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tileColor: Colors.grey.withOpacity(0.1),
        leading: CircleAvatar(
          backgroundColor: Color(0xFF0D9488).withOpacity(0.1),
          child: Icon(icon, color: Color(0xFF0D9488)),
        ),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}