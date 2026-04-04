import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("من نحن"),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔥 App Logo + Name
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF03819B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.location_city,
                        size: 40, color: Color(0xFF03819B)),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "دليل المدينة",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "City Guide App",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// 📄 About
            _section(
              title: "عن التطبيق",
              content:
                  "تطبيق دليل االصالحية يساعدك في الوصول إلى أفضل الأماكن والخدمات بسهولة داخل مدينتك.",
              isDark: isDark,
            ),

            _section(
              title: "مهمتنا",
              content:
                  "توفير تجربة سهلة وسريعة للمستخدم للوصول إلى الأماكن والخدمات المختلفة.",
              isDark: isDark,
            ),

            _section(
              title: "رؤيتنا",
              content:
                  "أن نكون التطبيق الأول في تقديم خدمات الدليل المحلي في كل المدن.",
              isDark: isDark,
            ),

            SizedBox(height: 20),

            /// 👨‍💻 Developer
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Column(
                children: [

                  Text(
                    "تطوير بواسطة ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  Text("Dr/Mo.Sa3dawy 👑"),
                  Text("APP Developer"),
                ],
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required String content,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.withOpacity(0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}