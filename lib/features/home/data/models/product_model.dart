class ProductModel {
  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.images,
    required this.thumbnail,
  });
  int id;
  String title;
  String description;
  double price;
  double discountPercentage;
  double rating;
  int stock;
  List<String> tags;
  List<String> images;
  String thumbnail;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"] as String,
      description: json["description"] as String,
      price: (json["price"] as num).toDouble(),
      discountPercentage: (json["discountPercentage"] as num).toDouble(),
      rating: (json["rating"] as num).toDouble(),
      stock: (json["stock"] as num).toInt(),
      tags:
          (json["tags"] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      images: (json["images"] as List).cast<String>(),
      thumbnail: json["thumbnail"],
    );
  }
}
