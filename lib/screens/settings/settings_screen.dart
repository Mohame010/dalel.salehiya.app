import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../core/theme/app_theme_provider.dart';
import '../../widgets/settings/settings_item.dart';
import '../../core/utils/helpers.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    final theme = Provider.of<AppThemeProvider>(context);

    final textColor =
        Theme.of(context).textTheme.bodyLarge!.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [

            /// 🔥 HEADER
            Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0D9488),
                    Color(0xFF14B8A6),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.teal.withOpacity(0.3),
                    offset: Offset(0, 6),
                  )
                ],
              ),
              child: Row(
                children: [

                  /// 👤 Avatar
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 30),
                    ),
                  ),

                  SizedBox(width: 12),

                  /// 👤 Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.user?.name ?? "Guest",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        auth.user?.phone ?? "",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// ⚙️ SETTINGS
            _buildCard(
              context,
              children: [

                SettingsItem(
                  title: "الوضع الداكن",
                  icon: Icons.dark_mode,
                  trailing: Switch(
                    value: theme.isDark,
                    onChanged: (value) {
                      theme.toggleTheme();
                    },
                  ),
                ),

                SettingsItem(
                  title: "اللغة",
                  icon: Icons.language,
                  onTap: () {
                    Helpers.showSnackBar(context, "قريبًا");
                  },
                ),
              ],
            ),

            SizedBox(height: 15),

            /// 📄 INFO
            _buildCard(
              context,
              children: [
                SettingsItem(
                   title: "من نحن",
                   icon: Icons.info,
                   onTap: () {
                      Navigator.pushNamed(context, '/about');
                      },
                         ),

                SettingsItem(
                  title: "سياسة الخصوصية",
                  icon: Icons.privacy_tip,
                  onTap: () {
                   Navigator.pushNamed(context, '/privacy');
                       }
                           ),

                SettingsItem(
                  title: "تواصل معنا",
                  icon: Icons.phone,
                  onTap: () {
                   Navigator.pushNamed(context, '/contact');
                       }
                       

                       

                ),
              ],
            ),

            SizedBox(height: 15),

            /// ⚠️ DANGER
            _buildCard(
              context,
              children: [

                SettingsItem(
                  title: "حذف الحساب",
                  icon: Icons.delete,
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    Helpers.showSnackBar(context, "قريبًا");
                  },
                ),

                SettingsItem(
                  title: "تسجيل الخروج",
                  icon: Icons.logout,
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () async {
                    await auth.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 🔥 CARD (Dark Mode Safe)
  Widget _buildCard(BuildContext context,
      {required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark
                  ? 0.3
                  : 0.06,
            ),
          )
        ],
      ),
      child: Column(children: children),
    );
  }
}