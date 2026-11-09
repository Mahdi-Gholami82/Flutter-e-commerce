import 'package:digi_meh/core/domain/entities/product_categories.dart';
import 'package:digi_meh/features/home/domain/entities/review_entity.dart';

class Product {
  int id;
  String title;
  String description;
  double price;
  double discountPercentage;
  double rating;
  int stock;
  List<ProductCategory> tags;
  List<Uri> images;
  List<Review> reviews;
  Uri thumbnail;

  Product({
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
    required this.reviews,
  });

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
