import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  const PageButton({super.key, required this.selected, required this.index});

  final bool selected;
  final int index;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    assert(index >= 0);
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        elevation: 2,
        color: selected ? colorScheme.primary : colorScheme.secondaryFixedDim,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          splashColor: selected
              ? colorScheme.onPrimary.withValues(alpha: 0.16)
              : colorScheme.onSecondaryFixed.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Center(
            child: Text(
              "$index",
              style: TextStyle(
                color: selected
                    ? colorScheme.onPrimary
                    : colorScheme.onSecondaryFixed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
