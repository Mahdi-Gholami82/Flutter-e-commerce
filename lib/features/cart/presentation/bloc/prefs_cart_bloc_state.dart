import 'package:digi_meh/features/cart/domain/entities/cart_item_entity.dart';

sealed class PrefsCartBlocState {}

class CartBlocInitial extends PrefsCartBlocState {}

class CartBlocPrefsLoading extends PrefsCartBlocState {
  List<Future<CartItem>> cartItemsLoading;
  int lenght;
  CartBlocPrefsLoading({required this.cartItemsLoading, required this.lenght});
}

class PrefsCartBlocFullyLoaded extends PrefsCartBlocState {
  List<CartItem> cartItems;
  PrefsCartBlocFullyLoaded({required this.cartItems});
}
