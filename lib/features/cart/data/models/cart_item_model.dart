class CartItemModel {
  int productId;
  int numberOfItems;
  CartItemModel({required this.productId, required this.numberOfItems});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as int,
      numberOfItems: json['numberOfItems'] as int,
    );
  }

  Map<String, int> toJson() => {
    'productId': productId,
    'numberOfItems': numberOfItems,
  };
}
