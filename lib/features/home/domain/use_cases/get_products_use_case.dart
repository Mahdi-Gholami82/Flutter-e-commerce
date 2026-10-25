import 'package:digi_meh/features/home/data/repositories/products_repository.dart';
import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;
  GetProductsUseCase({required this._repository});
  Future<ProductsList> execute({required int pageNumber}) =>
      _repository.getProducts(pageNumber: pageNumber);
}
