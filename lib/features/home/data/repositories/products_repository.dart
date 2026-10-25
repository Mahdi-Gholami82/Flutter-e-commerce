import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/core/domain/entities/product_categories.dart';
import 'package:digi_meh/features/home/data/models/product_model.dart';
import 'package:digi_meh/features/home/data/models/products_list_model.dart';
import 'package:digi_meh/features/home/data/sources/products_source.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';

abstract class ProductsRepository {
  Future<ProductsList> getProducts({required int pageNumber});
  Future<ProductsList> searchProducts({required String query});
  Future<Product> getSingleProduct({required int id});
}

class ProductsRepositoryImpl extends ProductsRepository {
  ProductsSource dataSource;
  ProductsRepositoryImpl({required this.dataSource});

  ProductsList _fromProductsListModel(ProductsListModel productsList) {
    return ProductsList(
      products: productsList.products.map(_fromProductModel).toList(),
      page: ProductsPage(
        number: (productsList.skip / productsListPaginationLimit).toInt(),
        totalProducts: productsList.total,
        totalPages: (productsList.total / productsListPaginationLimit).ceil(),
      ),
    );
  }

  Product _fromProductModel(ProductModel productModel) => Product(
    id: productModel.id,
    title: productModel.title,
    description: productModel.description,
    price: productModel.price,
    discountPercentage: productModel.discountPercentage,
    rating: productModel.rating,
    stock: productModel.stock,
    tags: productModel.tags
        .map((e) => ProductCategory.fromId(e))
        .nonNulls
        .toList(),
    images: productModel.images.map(Uri.tryParse).nonNulls.toList(),
    thumbnail: Uri.parse(productModel.thumbnail),
  );

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

  @override
  Future<Product> getSingleProduct({required int id}) async {
    return _fromProductModel(await dataSource.getSingleProuduct(id: id));
  }
}
