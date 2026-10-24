import 'package:digi_meh/core/data/sources/preferences_data_source.dart';
import 'package:digi_meh/features/cart/data/models/cart_item_model.dart';
import 'package:digi_meh/features/cart/domain/entities/cart_item_entity.dart';
import 'package:digi_meh/features/home/data/repositories/products_repository.dart';

abstract class PreferencesRepository {
  List<Future<CartItem>> getCartItems();
  void saveCartItems(List<CartItem> items);
}

class PreferencesRepositoryImpl extends PreferencesRepository {
  PreferencesDataSource dataSource;
  ProductsRepository productsRepository;
  PreferencesRepositoryImpl({
    required this.dataSource,
    required this.productsRepository,
  });
  @override
  List<Future<CartItem>> getCartItems() {
    List<CartItemModel> cartItemPrefs = dataSource.getCartItems();
    if (cartItemPrefs.isEmpty) return [];
    return cartItemPrefs
        .map(
          (e) async => CartItem(
            product: await productsRepository.getSingleProuduct(
              id: e.productId,
            ),
            numberOfItem: e.numberOfItems,
          ),
        )
        .toList();
  }

  @override
  void saveCartItems(List<CartItem> items) {
    dataSource.saveCartItems(
      items
          .map(
            (e) => CartItemModel(
              productId: e.product.id,
              numberOfItems: e.numberOfItem,
            ),
          )
          .toList(),
    );
  }
}
