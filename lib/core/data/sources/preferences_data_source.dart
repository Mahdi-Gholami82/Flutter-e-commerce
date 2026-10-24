import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:digi_meh/features/cart/data/models/cart_item_model.dart';

abstract class PreferencesDataSource {
  List<CartItemModel> getCartItems();
  void saveCartItems(List<CartItemModel> items);
}

class PreferencesDataSourceImpl extends PreferencesDataSource {
  PreferencesDataSourceImpl({required this.prefs});
  final SharedPreferences prefs;
  @override
  List<CartItemModel> getCartItems() {
    return prefs
            .getStringList("cartItemList")
            ?.map((e) => CartItemModel.fromJson(jsonDecode(e)))
            .toList() ??
        [];
  }

  @override
  void saveCartItems(List<CartItemModel> items) {
    prefs.setStringList(
      "cartItemList",
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
