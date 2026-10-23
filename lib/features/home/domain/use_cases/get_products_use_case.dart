import 'package:digi_meh/features/home/data/repositories/products_repository.dart';
import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';

class GetProductsUseCase {
  ProductsRepository repository;
  GetProductsUseCase({required this.repository});
  Future<ProductsList> execute({required int pageNumber}) =>
      repository.getProducts(pageNumber: pageNumber);
}

class SearchProductsUseCase {
  ProductsRepository repository;
  SearchProductsUseCase({required this.repository});
  Future<ProductsList> execute({required String query}) =>
      repository.searchProducts(query: query);
}
