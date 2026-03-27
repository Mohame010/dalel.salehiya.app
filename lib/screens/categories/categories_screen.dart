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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: home.loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "الأقسام",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "اختر القسم المناسب",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🧩 Grid
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: home.categories.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        final category = home.categories[index];

                        return CategoryCard(category: category);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}