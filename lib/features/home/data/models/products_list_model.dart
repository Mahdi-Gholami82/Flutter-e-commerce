import 'package:digi_meh/features/home/data/models/product_model.dart';

class ProductsListModel {
  List<ProductModel> products;
  int total;
  int skip;
  int limit;
  ProductsListModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsListModel.fromJson(Map<String, dynamic> json) {
    return ProductsListModel(
      products: List<ProductModel>.from(
        (json["products"] as List<dynamic>).map<ProductModel>(
          (x) => ProductModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
      total: (json["total"] as num).toInt(),
      skip: (json["skip"] as num).toInt(),
      limit: (json["limit"] as num).toInt(),
    );
  }
}
