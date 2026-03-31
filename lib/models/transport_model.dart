class TransportModel {
  final int id;
  final String type;
  final String from;
  final String to;
  final double price;
  final int categoryId;
  final String? time; // ✅ جديد

  TransportModel({
    required this.id,
    required this.type,
    required this.from,
    required this.to,
    required this.price,
    required this.categoryId,
    this.time, // ✅ جديد
  });

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    return TransportModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      from: json['from_location'] ?? '',
      to: json['to_location'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
      categoryId: json['category_id'] ?? 0,
      time: json['time'], // ✅ جديد
    );
  }
}