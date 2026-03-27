import 'package:flutter/material.dart';
import '../../models/category_model.dart';

class HomeCategories extends StatelessWidget {
  final List<CategoryModel> categories;

  const HomeCategories({required this.categories});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {

          final cat = categories[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/places',
                arguments: cat,
              );
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// 🖼 Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      cat.image,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 10),

                  /// 📄 Name
                  Text(
                    cat.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}