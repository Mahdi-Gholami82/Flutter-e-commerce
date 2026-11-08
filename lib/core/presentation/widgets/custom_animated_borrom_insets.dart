import 'package:flutter/material.dart';

class CustomAnimatedBottomInsets extends StatelessWidget {
  const CustomAnimatedBottomInsets({
    super.key,
    required this.child,
    this.duration = Duration.zero,
  });
  final Widget child;
  final Duration duration;
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: duration,
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: child,
    );
  }
}
