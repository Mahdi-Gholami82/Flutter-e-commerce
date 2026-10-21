import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CustomNavigationItem {
  const CustomNavigationItem({required this.label, required this.icon});
  final Icon icon;
  final Widget label;
}

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({
    super.key,
    required this.initialSelection,
    required this.items,
    required this.onChanged,
  });
  final List<CustomNavigationItem> items;
  final int initialSelection;
  final void Function(int index) onChanged;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late int selected;
  List<WidgetStatesController> stateControllers = [];

  void updateStateControllers() {
    stateControllers = List.generate(
      widget.items.length,
      (_) => WidgetStatesController(),
    );
  }

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelection;
    updateStateControllers();
  }

  @override
  void didUpdateWidget(covariant CustomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateStateControllers();
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(20);
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.items.mapIndexed((index, item) {
          bool isSelected = selected == index;
          return Flexible(
            child: FittedBox(
              child: IntrinsicHeight(
                child: Material(
                  borderRadius: radius,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isSelected ? theme.highlightColor : null,
                      borderRadius: radius,
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            spreadRadius: -1,
                            blurRadius: 5,
                            blurStyle: BlurStyle.outer,
                          ),
                      ],
                    ),
                    child: Ink(
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onTap: () {
                          setState(() {
                            selected = index;
                            widget.onChanged(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconTheme(
                            data: IconThemeData(color: colorScheme.secondary),
                            child: DefaultTextStyle(
                              style: TextStyle(color: colorScheme.secondary),
                              child: SizedBox(
                                width: 60,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [item.icon, item.label],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
