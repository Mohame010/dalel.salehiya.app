class ItemModel {
  final int id;
  final String name;
  final String image;
  final double price;
  final int placeId;

  ItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.placeId,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
      placeId: json['place_id'] ?? 0,
    );
  }
}