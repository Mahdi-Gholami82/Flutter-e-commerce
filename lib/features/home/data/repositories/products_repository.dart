import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/core/domain/entities/product_categories.dart';
import 'package:digi_meh/features/home/data/models/products_list_model.dart';
import 'package:digi_meh/features/home/data/sources/products_source.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';

abstract class ProductsRepository {
  Future<ProductsList> getProducts({required int pageNumber});
}

class ProductsRepositoryImpl extends ProductsRepository {
  ProductsSource dataSource;
  ProductsRepositoryImpl({required this.dataSource});
  @override
  Future<ProductsList> getProducts({required int pageNumber}) async {
    ProductsListModel productsList = await dataSource.getProducts(
      limit: productsListPaginationLimit,
      skip: pageNumber * productsListPaginationLimit,
    );
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
        number: pageNumber,
        totalProducts: productsList.total,
        totalPages: (productsList.total / productsListPaginationLimit).ceil(),
      ),
    );
  }
}
