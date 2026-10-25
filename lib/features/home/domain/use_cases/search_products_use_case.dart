import 'package:digi_meh/features/home/data/repositories/products_repository.dart';
import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';

class SearchProductsUseCase {
  final ProductsRepository _repository;
  SearchProductsUseCase({required this._repository});
  Future<ProductsList> execute({required String query}) =>
      _repository.searchProducts(query: query);
}
