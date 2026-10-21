import 'package:digi_meh/home/presentation/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        onChanged: (index) {},
        items: [
          CustomNavigationItem(icon: Icon(Icons.home), label: Text("Home")),
          CustomNavigationItem(
            icon: Icon(Icons.category),
            label: Text("Category"),
          ),
          CustomNavigationItem(
            icon: Icon(Icons.shopping_cart),
            label: Text("Cart"),
          ),
          CustomNavigationItem(
            icon: Icon(Icons.account_circle_rounded),
            label: Text("Me"),
          ),
        ],
        initialSelection: 1,
      ),
    );
  }
}
