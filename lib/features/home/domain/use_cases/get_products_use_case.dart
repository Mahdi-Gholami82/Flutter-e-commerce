import 'package:digi_meh/features/home/data/repositories/products_repository.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';

class GetProductsUseCase {
  ProductsRepository repository;
  GetProductsUseCase({required this.repository});
  Future<List<Product>> execute({required int limit, required int skip}) =>
      repository.getProducts(limit: limit, skip: skip);
}
