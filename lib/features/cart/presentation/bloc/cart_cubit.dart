import 'package:collection/collection.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:digi_meh/features/cart/domain/entities/cart_item_entity.dart';

class CartCubitState {
  CartCubitState() : items = [];
  final List<CartItem> items;

  CartCubitState.fromItems({required this.items});

  CartCubitState copy() => CartCubitState.fromItems(items: items);
}

class CartCubit extends Cubit<CartCubitState> {
  CartCubit() : super(CartCubitState());

  void addOrUpdateNumberOfItem(Product product, int numberOfItem) {
    assert(numberOfItem >= 0);
    final result = state.items.firstWhereOrNull((e) => e.product == product);
    if (result == null) {
      state.items.add(CartItem(product: product, numberOfItem: numberOfItem));
    } else if (result.numberOfItem != numberOfItem) {
      result.numberOfItem = numberOfItem;
    } else {
      return;
    }
    emit(state.copy());
  }

  void updateNumberOfItem(Product product, int numberOfItem) {
    assert(numberOfItem >= 0);
    state.items.firstWhere((e) => e.product == product).numberOfItem =
        numberOfItem;
    emit(state.copy());
  }

  bool remove(Product product) {
    bool result = state.items.remove(
      state.items.firstWhereOrNull((e) => e.product == product),
    );
    if (result) {
      emit(state.copy());
    }
    return result;
  }

  void add(Product product, int numberOfItem) {
    assert(numberOfItem >= 0);
    remove(product);
    state.items.add(CartItem(product: product, numberOfItem: numberOfItem));
    emit(state.copy());
  }
}
