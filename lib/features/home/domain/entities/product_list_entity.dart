import 'package:digi_meh/features/home/domain/entities/product_entity.dart';

class ProductsPage {
  int number;
  int totalProducts;
  int totalPages;
  ProductsPage({
    required this.number,
    required this.totalProducts,
    required this.totalPages,
  }) {
    assert(totalPages >= 0);
    assert(totalProducts >= 0);
    assert(number >= 0);
  }
}

class ProductsList {
  List<Product> products;
  ProductsPage page;
  ProductsList({required this.products, required this.page});
}
