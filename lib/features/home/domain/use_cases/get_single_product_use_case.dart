import 'package:digi_meh/features/home/data/repositories/products_repository.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';

class GetSingleProductUseCase {
  final ProductsRepository _repository;
  GetSingleProductUseCase({required this._repository});
  Future<Product> execute({required int id}) =>
      _repository.getSingleProduct(id: id);
}
