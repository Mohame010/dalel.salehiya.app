import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// 🔥 Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// 🔹 Providers
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';

/// 🔹 Theme
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_provider.dart';

/// 🔹 Routes
import 'routes/app_routes.dart';

/// 🔥 مهم جدًا (علشان نفتح شاشة من أي مكان)
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 Firebase Init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// 🔥 OneSignal Init
  OneSignal.initialize("85026b5a-4e49-4e87-8379-6758fb5d7167");

  /// 🔔 طلب إذن الإشعارات
  OneSignal.Notifications.requestPermission(true);

  /// 🔥 لما المستخدم يضغط على الإشعار
  OneSignal.Notifications.addClickListener((event) async {

    final data = event.notification.additionalData;

    print("🔔 NOTIFICATION DATA: $data");

    if (data == null) return;

    final openType = data['openType'];
    final url = data['url'];

    /// 🌐 فتح لينك
    if (openType == "url" && url != null) {

      final uri = Uri.parse(url);

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }

    /// 📱 فتح شاشة
    else if (openType == "screen") {

      navigatorKey.currentState?.pushNamed('/home');

      /// بعدين نطورها:
      /// /place-details
      /// /transport
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
      ],

      child: Consumer<AppThemeProvider>(
        builder: (context, themeProvider, _) {

          return MaterialApp(
            navigatorKey: navigatorKey, // 👈 مهم جدًا

            debugShowCheckedModeBanner: false,

            /// 🎨 Themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            /// 🚦 Routing
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,

            /// 🌍 Localization (جاهز)
            locale: const Locale('en'),
          );
        },
      ),
    );
  }
}