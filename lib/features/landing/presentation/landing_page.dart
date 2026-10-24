import 'package:digi_meh/features/cart/presentation/bloc/cart_prefs_bloc.dart';
import 'package:digi_meh/features/cart/presentation/cart_page.dart';
import 'package:digi_meh/features/category/presentation/category_page.dart';
import 'package:digi_meh/features/home/presentation/bloc/products_bloc.dart';
import 'package:digi_meh/features/home/presentation/bloc/search_products_bloc.dart';
import 'package:digi_meh/features/home/presentation/home_page.dart';
import 'package:digi_meh/features/landing/presentation/widgets/custom_navigation_bar.dart';
import 'package:digi_meh/features/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatefulWidget {
  static const String route = "/landing";
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int selectedPage = 0;
  final List<Widget> children = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    ProfilePage(),
  ];
  final pageController = PageController();
  // final double offset = 100;
  // double mouseStartOffset = 0;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductsBloc()),
        BlocProvider(create: (_) => SearchProductsBloc()),
      ],
      child: Scaffold(
        bottomNavigationBar: CustomNavigationBar(
          initialSelection: selectedPage,
          onChanged: (index) {
            setState(() {
              selectedPage = index;
              pageController.animateToPage(
                selectedPage,
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
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
        body: GestureDetector(
          // onPanStart: (details) {
          //   mouseStartOffset = pageController.offset + details.localPosition.dx;
          // },
          // onPanUpdate: (details) {
          //   var position = pageController.position;
          //   double toOffset =
          //       (pageController.offset +
          //               (mouseStartOffset - details.localPosition.dx))
          //           .clamp(0, position.maxScrollExtent);
          //   pageController.jumpTo(toOffset);
          // },
          child: PageView(controller: pageController, children: children),
        ),
      ),
    );
  }
}
