import 'package:flutter/material.dart';

class CustomAnimatedBottomInsets extends StatelessWidget {
  const CustomAnimatedBottomInsets({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: child,
    );
  }
}
