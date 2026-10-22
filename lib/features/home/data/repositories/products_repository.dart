import 'package:digi_meh/core/domain/entities/product_categories.dart';
import 'package:digi_meh/features/home/data/models/product_model.dart';
import 'package:digi_meh/features/home/data/sources/products_source.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts({required int limit, required int skip});
}

class ProductsRepositoryImpl extends ProductsRepository {
  ProductsSource dataSource;
  ProductsRepositoryImpl({required this.dataSource});
  @override
  Future<List<Product>> getProducts({
    required int limit,
    required int skip,
  }) async {
    List<ProductModel> results = await dataSource.getProducts(
      limit: limit,
      skip: skip,
    );
    return results
        .map(
          (result) => Product(
            title: result.title,
            description: result.description,
            price: result.price,
            discountPercentage: result.discountPercentage,
            rating: result.rating,
            stock: result.stock,
            tags: result.tags
                .map((e) => ProductCategory.fromId(e))
                .nonNulls
                .toList(),
          ),
        )
        .toList();
  }
}
