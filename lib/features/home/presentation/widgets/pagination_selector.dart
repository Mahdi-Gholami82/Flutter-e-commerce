import 'package:digi_meh/features/home/presentation/widgets/page_button.dart';
import 'package:flutter/material.dart';

class PaginationSelector extends StatefulWidget {
  const PaginationSelector({
    super.key,
    required this.numberOfOptions,
    required this.maxPage,
    required this.selected,
    this.minPage = 0,
  });
  final int numberOfOptions;
  final int maxPage;
  final int selected;
  final int minPage;

  @override
  State<PaginationSelector> createState() => _PaginationSelectorState();
}

class _PaginationSelectorState extends State<PaginationSelector> {
  late int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant PaginationSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    print("SELECTED: $selected");
    print("MAX: ${widget.maxPage}");
    var begin = (selected - (widget.numberOfOptions / 2).floor()).clamp(
      widget.minPage,
      widget.maxPage - (widget.numberOfOptions - 1),
    );
    print("BEGIN: $begin");

    List<int?> childrenIndexes = List.generate(
      widget.numberOfOptions,
      (index) => begin + index,
    );
    if (begin > widget.minPage ||
        widget.minPage > begin + widget.numberOfOptions - 1) {
      childrenIndexes.removeAt(0);
      childrenIndexes.insert(0, null);
      childrenIndexes.insert(0, 0);
    }
    if (begin > widget.maxPage ||
        widget.maxPage > begin + widget.numberOfOptions - 1) {
      childrenIndexes.removeLast();
      childrenIndexes.add(null);
      childrenIndexes.add(widget.maxPage);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: childrenIndexes
          .map(
            (index) => Flexible(
              child: FittedBox(
                child: index == null
                    ? Text("•", style: TextStyle(fontWeight: FontWeight.w900))
                    : PageButton(selected: index == selected, index: index),
              ),
            ),
          )
          .toList(),
    );
  }
}
