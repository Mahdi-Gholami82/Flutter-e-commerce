import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  static const String route = "/cart";

  const CartPage({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text("Cart Page")));
}
