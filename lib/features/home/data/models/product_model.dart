class ProductModel {
  ProductModel({
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
  });

  String title;
  String description;
  double price;
  double discountPercentage;
  double rating;
  int stock;
  List<String> tags;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      title: json["title"] as String,
      description: json["description"] as String,
      price: (json["price"] as num).toDouble(),
      discountPercentage: (json["discountPercentage"] as num).toDouble(),
      rating: (json["rating"] as num).toDouble(),
      stock: (json["stock"] as num).toInt(),
      tags:
          (json["tags"] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
    );
  }
}
