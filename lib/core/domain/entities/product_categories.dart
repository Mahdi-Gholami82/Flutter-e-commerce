import 'package:collection/collection.dart';

enum ProductCategory {
  beauty(id: "beauty", title: "Beauty"),
  fragrances(id: "fragrances", title: "Fragrances"),
  furniture(id: "furniture", title: "Furniture"),
  groceries(id: "groceries", title: "Groceries"),
  homeDecoration(id: "home-decoration", title: "Home Decoration"),
  kitchenAccessories(id: "kitchen-accessories", title: "Kitchen Accessories"),
  laptops(id: "laptops", title: "Laptops"),
  mensShirts(id: "mens-shirts", title: "Men\"s Shirts"),
  mensShoes(id: "mens-shoes", title: "Men\"s Shoes"),
  mensWatches(id: "mens-watches", title: "Men\"s Watches"),
  mobileAccessories(id: "mobile-accessories", title: "Mobile Accessories"),
  motorcycle(id: "motorcycle", title: "Motorcycle"),
  skinCare(id: "skin-care", title: "Skin Care"),
  smartphones(id: "smartphones", title: "Smartphones"),
  sportsAccessories(id: "sports-accessories", title: "Sports Accessories"),
  sunglasses(id: "sunglasses", title: "Sunglasses"),
  tablets(id: "tablets", title: "Tablets"),
  tops(id: "tops", title: "Tops"),
  vehicle(id: "vehicle", title: "Vehicle"),
  womensBags(id: "womens-bags", title: "Women\"s Bags"),
  womensDresses(id: "womens-dresses", title: "Women\"s Dresses"),
  womensJewellery(id: "womens-jewellery", title: "Women\"s Jewellery"),
  womensShoes(id: "womens-shoes", title: "Women\"s Shoes"),
  womensWatches(id: "womens-watches", title: "Women\"s Watches");

  const ProductCategory({required this.id, required this.title});

  final String id;
  final String title;

  static ProductCategory? fromId(String? id) {
    return id == null
        ? null
        : values.firstWhereOrNull((e) => e.id.trim() == id.trim());
  }
}
