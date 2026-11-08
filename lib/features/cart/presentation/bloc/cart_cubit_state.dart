import 'package:digi_meh/features/cart/domain/entities/cart_item_entity.dart';

class CartCubitState {
  CartCubitState() : items = [];
  final List<CartItem> items;

  CartCubitState.fromItems({required this.items});

  CartCubitState copy() => CartCubitState.fromItems(items: items);
}
