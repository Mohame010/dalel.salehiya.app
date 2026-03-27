import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  /// 🔥 الجديد
  final Color? iconColor;
  final Color? textColor;

  const SettingsItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,

      leading: Icon(
        icon,
        color: iconColor ?? Colors.black,
      ),

      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),

      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}