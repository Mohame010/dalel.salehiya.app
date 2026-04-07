import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/home/home_banner.dart';
import '../../widgets/home/home_categories.dart';
import '../../routes/app_routes.dart';
import '../../models/place_model.dart'; // 🔥 مهم

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<HomeProvider>(context, listen: false).loadHome();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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

                    /// 🔥 HEADER
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("👋 أهلاً بيك",
                                  style: TextStyle(color: Colors.grey)),
                              Text("دليل الصالحية",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
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

                    /// 🔍 SEARCH
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
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false) {
                                    _debounce!.cancel();
                                  }

                                  _debounce = Timer(
                                      Duration(milliseconds: 500), () {
                                    context
                                        .read<SearchProvider>()
                                        .search(value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    /// 🔍 RESULTS
                    Consumer<SearchProvider>(
                      builder: (context, search, child) {

                        if (search.loading) {
                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                                child: CircularProgressIndicator()),
                          );
                        }

                        if (search.places.isEmpty &&
                            search.items.isEmpty) {
                          return SizedBox();
                        }

                        return Column(
                          children: [

                            /// 🏪 Places
                            ...search.places.map((p) => ListTile(
                                  title: Text(p['name']),
                                  leading: Icon(Icons.store),

                                  onTap: () {
                                    context.read<SearchProvider>().clear();

                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.placeDetails,
                                      arguments:
                                          PlaceModel.fromJson(p), // 🔥 FIX
                                    );
                                  },
                                )),

                            /// 🍔 Items
                            ...search.items.map((i) => ListTile(
                                  title: Text(i['name']),
                                  leading: Icon(Icons.fastfood),

                                  onTap: () {
                                    context.read<SearchProvider>().clear();

                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.placeDetails,
                                      arguments: PlaceModel.fromJson({
                                        "id": i['place_id'],
                                        "name": i['name'],
                                      }),
                                    );
                                  },
                                )),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 18),

                    /// 🎞 ADS
                    HomeBanner(ads: home.ads),

                    SizedBox(height: 20),

                    /// 🚗 TRANSPORT
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
                          ),
                          child: Row(
                            children: [
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
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text("المواصلات",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Text("اعرف خطوط السير والأسعار",
                                      style: TextStyle(
                                          color: Colors.white70)),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("الأقسام",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
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