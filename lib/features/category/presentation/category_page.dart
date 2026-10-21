import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  static const String route = "/category";

  const CategoryPage({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text("Category Page")));
}
