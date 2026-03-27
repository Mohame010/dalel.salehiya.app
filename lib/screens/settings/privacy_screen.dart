import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [

          /// 🔥 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 60, bottom: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D9488),
                  Color(0xFF14B8A6),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.privacy_tip,
                    color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  "سياسة الخصوصية",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "نحن نحمي بياناتك بكل أمان",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// 📄 CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [

                  _section(
                    icon: Icons.info,
                    title: "المعلومات التي نجمعها",
                    content:
                        "نقوم بجمع بعض المعلومات مثل الاسم ورقم الهاتف لتحسين تجربة المستخدم داخل التطبيق.",
                    isDark: isDark,
                  ),

                  _section(
                    icon: Icons.settings,
                    title: "كيفية استخدام البيانات",
                    content:
                        "نستخدم البيانات لتقديم الخدمات، تحسين الأداء، وإرسال الإشعارات المهمة.",
                    isDark: isDark,
                  ),

                  _section(
                    icon: Icons.share,
                    title: "مشاركة البيانات",
                    content:
                        "لا نقوم بمشاركة بياناتك مع أي طرف ثالث بدون إذن مسبق.",
                    isDark: isDark,
                  ),

                  _section(
                    icon: Icons.security,
                    title: "الأمان",
                    content:
                        "نلتزم بحماية بياناتك باستخدام أفضل معايير الأمان.",
                    isDark: isDark,
                  ),

                  _section(
                    icon: Icons.update,
                    title: "التعديلات",
                    content:
                        "قد نقوم بتحديث سياسة الخصوصية من وقت لآخر.",
                    isDark: isDark,
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 Section Card
  Widget _section({
    required IconData icon,
    required String title,
    required String content,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 Icon
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF0D9488).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFF0D9488)),
          ),

          SizedBox(width: 10),

          /// 🔹 Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : Colors.black87,
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