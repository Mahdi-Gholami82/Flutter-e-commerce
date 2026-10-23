import 'package:digi_meh/features/home/domain/entities/product_entity.dart';

class CartItem {
  Product product;
  int numberOfItem;
  CartItem({required this.product, required this.numberOfItem});

  @override
  bool operator ==(covariant CartItem other) {
    if (identical(this, other)) return true;
    return other.product == product && other.numberOfItem == numberOfItem;
  }

  @override
  int get hashCode => Object.hash(product, numberOfItem);
}
