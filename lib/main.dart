import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// 🔥 Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// 🔥 Hive (Offline)
import 'package:hive_flutter/hive_flutter.dart';

/// 🔹 Providers
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/search_provider.dart';

/// 🔹 Theme
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_provider.dart';

/// 🔹 Routes
import 'routes/app_routes.dart';

/// 🔥 Navigator Key
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 Firebase Init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// 🔥 Hive Init
  await Hive.initFlutter();
  await Hive.openBox('appData');

  /// 🔥 OneSignal
  OneSignal.initialize("85026b5a-4e49-4e87-8379-6758fb5d7167");

  OneSignal.Notifications.requestPermission(true);

  OneSignal.Notifications.addClickListener((event) async {

    final data = event.notification.additionalData;

    if (data == null) return;

    final openType = data['openType'];
    final url = data['url'];

    if (openType == "url" && url != null) {
      final uri = Uri.parse(url);

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else if (openType == "screen") {
      navigatorKey.currentState?.pushNamed('/home');
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

        /// 🔥 Auth
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..loadUser(),
        ),

        ChangeNotifierProvider(create: (_) => HomeProvider()),

        /// 🔍 SEARCH
        ChangeNotifierProvider(create: (_) => SearchProvider()),

        /// 🌙 THEME (🔥 أهم تعديل)
        ChangeNotifierProvider(
          create: (_) => AppThemeProvider()..loadTheme(), // 🔥 FIX
        ),
      ],

      child: Consumer<AppThemeProvider>(
        builder: (context, themeProvider, _) {

          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,

            /// 🎨 Themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            /// 🚦 Routing
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,

            /// 🌍 Arabic
            locale: const Locale('ar'),
          );
        },
      ),
    );
  }
}