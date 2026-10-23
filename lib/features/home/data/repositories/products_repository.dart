import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/core/domain/entities/product_categories.dart';
import 'package:digi_meh/features/home/data/models/products_list_model.dart';
import 'package:digi_meh/features/home/data/sources/products_source.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';

abstract class ProductsRepository {
  Future<ProductsList> getProducts({required int pageNumber});
  Future<ProductsList> searchProducts({required String query});
}

class ProductsRepositoryImpl extends ProductsRepository {
  ProductsSource dataSource;
  ProductsRepositoryImpl({required this.dataSource});

  ProductsList _fromProductsListModel(ProductsListModel productsList) {
    return ProductsList(
      products: productsList.products
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
              images: result.images.map(Uri.tryParse).nonNulls.toList(),
              thumbnail: Uri.parse(result.thumbnail),
            ),
          )
          .toList(),
      page: ProductsPage(
        number: (productsList.skip / productsListPaginationLimit).toInt(),
        totalProducts: productsList.total,
        totalPages: (productsList.total / productsListPaginationLimit).ceil(),
      ),
    );
  }

  @override
  Future<ProductsList> getProducts({required int pageNumber}) async {
    ProductsListModel productsList = await dataSource.getProducts(
      limit: productsListPaginationLimit,
      skip: pageNumber * productsListPaginationLimit,
    );
    return _fromProductsListModel(productsList);
  }

  @override
  Future<ProductsList> searchProducts({required String query}) async {
    ProductsListModel productsList = await dataSource.searchProducts(
      query: query,
    );
    return _fromProductsListModel(productsList);
  }
}
