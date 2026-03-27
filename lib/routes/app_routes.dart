import 'package:flutter/material.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/categories/places_screen.dart'; // 👈 مهم
import '../screens/categories/place_details_screen.dart';
import '../screens/transport/transport_screen.dart';
import '../screens/home/main_screen.dart';
import '../screens/settings/privacy_screen.dart';
import '../screens/settings/contact_screen.dart';
import '../screens/settings/about_screen.dart';


class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const places = '/places';
  static const placeDetails = '/place-details';
  static const transport = '/transport';

  /// 🔀 Route Generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case '/about':
        return MaterialPageRoute(builder: (_) => AboutScreen());

      case '/privacy':
       return MaterialPageRoute(builder: (_) => PrivacyScreen());

      case '/contact':
       return MaterialPageRoute(builder: (_) => ContactScreen());

      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case home:
        return MaterialPageRoute(builder: (_) => MainScreen());

      case places:
        return MaterialPageRoute(
          builder: (_) => PlacesScreen(),
          settings: settings,
        );

      case placeDetails:
        return MaterialPageRoute(
          builder: (_) => PlaceDetailsScreen(),
          settings: settings,
        );

      case transport:
        return MaterialPageRoute(
          builder: (_) => TransportScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("No route found")),
          ),
        );
    }
  }
}