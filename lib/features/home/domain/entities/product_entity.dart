import 'package:digi_meh/core/domain/entities/product_categories.dart';

class Product {
  String title;
  String description;
  double price;
  double discountPercentage;
  double rating;
  int stock;
  List<ProductCategory> tags;

  Product({
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
  });
}
