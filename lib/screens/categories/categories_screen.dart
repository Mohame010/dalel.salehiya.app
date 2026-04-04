import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../widgets/cards/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

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
      body: Column(
        children: [

          /// 🔥 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 60, bottom: 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF03819B),
                  Color(0xFFDC0C49),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "الأقسام",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "اختر القسم المناسب",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// 🧩 CONTENT
          Expanded(
            child: home.loading
                ? Center(child: CircularProgressIndicator())

                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: home.categories.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        category: home.categories[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}