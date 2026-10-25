import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:digi_meh/features/cart/data/models/cart_item_model.dart';

abstract class PreferencesDataSource {
  List<CartItemModel> getCartItems();
  void saveCartItems(List<CartItemModel> items);
  String? getThemeMode();
  Future<void> saveThemeMode(String newTheme);
}

class PreferencesDataSourceImpl extends PreferencesDataSource {
  PreferencesDataSourceImpl({required this._prefs});
  final SharedPreferences _prefs;
  @override
  List<CartItemModel> getCartItems() {
    return _prefs
            .getStringList("cartItemList")
            ?.map((e) => CartItemModel.fromJson(jsonDecode(e)))
            .toList() ??
        [];
  }

  @override
  void saveCartItems(List<CartItemModel> items) {
    _prefs.setStringList(
      "cartItemList",
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  String? getThemeMode() => _prefs.getString("themeMode");

  @override
  Future<void> saveThemeMode(String value) =>
      _prefs.setString("themeMode", value);
}
