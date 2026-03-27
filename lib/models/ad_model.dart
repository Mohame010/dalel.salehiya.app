class AdModel {
  final int id;
  final String image;
  final String? link;

  AdModel({
    required this.id,
    required this.image,
    this.link,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      image: json['image'] ?? '',
      link: json['link'],
    );
  }
}