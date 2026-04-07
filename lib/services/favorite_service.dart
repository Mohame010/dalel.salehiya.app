import 'package:hive_flutter/hive_flutter.dart';

class FavoriteService {

  static final box = Hive.box('appData');

  /// ❤️ إضافة / حذف
  static Future<void> toggle(int placeId) async {
    List favs = box.get('favorites') ?? [];

    if (favs.contains(placeId)) {
      favs.remove(placeId);
    } else {
      favs.add(placeId);
    }

    await box.put('favorites', favs);
  }

  /// ❤️ هل مفضل؟
  static bool isFavorite(int placeId) {
    List favs = box.get('favorites') ?? [];
    return favs.contains(placeId);
  }

  /// ❤️ كل المفضلة
  static List getFavorites() {
    return box.get('favorites') ?? [];
  }
}