import 'package:digi_meh/features/cart/presentation/cart_page.dart';
import 'package:digi_meh/features/category/presentation/category_page.dart';
import 'package:digi_meh/features/home/presentation/bloc/products_bloc.dart';
import 'package:digi_meh/features/home/presentation/bloc/search_products_bloc.dart';
import 'package:digi_meh/features/home/presentation/home_page.dart';
import 'package:digi_meh/features/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class LandingPage extends StatefulWidget {
  static const String route = "/landing";
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // final double offset = 100;
  // double mouseStartOffset = 0;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductsBloc()),
        BlocProvider(create: (_) => SearchProductsBloc()),
      ],
      child: PersistentTabView(
        backgroundColor: colorScheme.surfaceContainer,
        tabs: [
          PersistentTabConfig(
            screen: HomePage(),
            item: ItemConfig(
              icon: Icon(Icons.home),
              title: "Home",
              activeForegroundColor: colorScheme.primary,
            ),
          ),
          PersistentTabConfig(
            screen: CategoryPage(),
            item: ItemConfig(
              icon: Icon(Icons.category),
              title: "Category",
              activeForegroundColor: colorScheme.primary,
            ),
          ),
          PersistentTabConfig(
            screen: CartPage(),
            item: ItemConfig(
              icon: Icon(Icons.shopping_cart),
              title: "Cart",
              activeForegroundColor: colorScheme.primary,
            ),
          ),
          PersistentTabConfig(
            screen: ProfilePage(),
            item: ItemConfig(
              icon: Icon(Icons.account_circle_rounded),
              title: "Profile",
              activeForegroundColor: colorScheme.primary,
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style2BottomNavBar(
          navBarConfig: navBarConfig,
          height: 60,
          itemPadding: .symmetric(vertical: 7, horizontal: 5),
          navBarDecoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(8),
            color: colorScheme.surfaceContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: -4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
