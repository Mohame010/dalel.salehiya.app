import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../widgets/home/home_banner.dart';
import '../../widgets/home/home_categories.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<HomeProvider>(context, listen: false).loadHome();
    });
  }

  @override
  Widget build(BuildContext context) {

    final home = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: home.loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔥 HEADER (Premium)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "👋 أهلاً بيك",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "دليل الصالحية",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.notifications_none),
                          )
                        ],
                      ),
                    ),

                    /// 🔍 SEARCH (أفخم)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "ابحث عن مطعم أو محل...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 18),

                    /// 🎞 ADS
                    HomeBanner(ads: home.ads),

                    SizedBox(height: 20),

                    /// 🚗 TRANSPORT (Premium Card)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.transport);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF03819B),
                                Color(0xFFDC0C49),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.teal.withOpacity(0.3),
                                offset: Offset(0, 5),
                              )
                            ],
                          ),
                          child: Row(
                            children: [

                              /// ICON
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.directions_bus,
                                    color: Color(0xFF03819B)),
                              ),

                              SizedBox(width: 12),

                              /// TEXT
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "المواصلات",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "اعرف خطوط السير والأسعار",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              Spacer(),

                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 22),

                    /// 🧩 TITLE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "الأقسام",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    /// 🧩 CATEGORIES
                    HomeCategories(categories: home.categories),

                    SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }
}