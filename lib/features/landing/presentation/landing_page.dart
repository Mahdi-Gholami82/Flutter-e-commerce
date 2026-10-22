import 'package:digi_meh/features/cart/presentation/cart_page.dart';
import 'package:digi_meh/features/category/presentation/category_page.dart';
import 'package:digi_meh/features/home/presentation/home_page.dart';
import 'package:digi_meh/features/landing/presentation/widgets/custom_navigation_bar.dart';
import 'package:digi_meh/features/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  static const String route = "/landing";
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        initialSelection: selectedPage,
        onChanged: (index) {
          setState(() {
            selectedPage = index;
          });
        },
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
            label: Text("Profile"),
          ),
        ],
      ),
      body: [
        HomePage(),
        CategoryPage(),
        CartPage(),
        ProfilePage(),
      ][selectedPage],
    );
  }
}
