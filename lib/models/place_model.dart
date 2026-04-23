class PlaceModel {
  final int id;
  final String name;
  final String image;
  final String phone;
  final String whatsapp;
  final String openTime;
  final String closeTime;
  final String address;
  final int categoryId;
  final String workingDays;

  /// ⭐ الجديد (rating)
  final double rating;
  final int ratingCount;

  PlaceModel({
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.whatsapp,
    required this.openTime,
    required this.closeTime,
    required this.address,
    required this.categoryId,
    required this.workingDays,

    /// ⭐ الجديد
    this.rating = 0,
    this.ratingCount = 0,
  });

  /// 🔥 Fix image + null safety
  static String fixImage(String url) {
    if (url.isEmpty) return "";
    if (url.startsWith("http://")) {
      return url.replaceFirst("http://", "https://");
    }
    return url;
  }

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: fixImage(json['image'] ?? ''),
      phone: json['phone'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      openTime: json['open_time'] ?? '',
      closeTime: json['close_time'] ?? '',
      address: json['address'] ?? '',
      categoryId: json['category_id'] ?? 0,
      workingDays: json['working_days'] ?? '',

      /// ⭐ الجديد
      rating: (json['rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
    );
  }
}