class PlaceModel {
  final int id;
  final String name;
  final String image;
  final String phone;
  final String whatsapp;
  final String openTime;
  final String closeTime;
  final String address; // 👈 جديد
  final int categoryId;
  final String workingDays;

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
      address: json['address'] ?? '', // 👈 مهم
      categoryId: json['category_id'] ?? 0,
      workingDays: json['working_days'] ?? '',
    );
  }
}