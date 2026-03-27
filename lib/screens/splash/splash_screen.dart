import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    /// 🎬 Animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    init();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await AuthService.getToken();

    if (token != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D9488),
              Color(0xFF14B8A6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: FadeTransition(
          opacity: _fadeAnimation,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// 🏙 Logo
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_city,
                  size: 50,
                  color: Color(0xFF0D9488),
                ),
              ),

              SizedBox(height: 20),

              /// 🏷 App Name
              Text(
                "دليل الصالحية",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "اكتشف كل ما تحتاجه في مدينتك",
                style: TextStyle(color: Colors.white70),
              ),

              SizedBox(height: 40),

              /// 🔄 Loading
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}