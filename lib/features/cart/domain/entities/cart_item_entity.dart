import 'package:digi_meh/features/home/domain/entities/product_entity.dart';

class CartItem {
  Product product;
  int numberOfItem;

  CartItem({required this.product, required this.numberOfItem});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CartItem && other.product == product;

  @override
  int get hashCode => product.hashCode;
}
