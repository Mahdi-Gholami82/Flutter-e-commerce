import 'package:flutter/material.dart';

class PageViewIndicated extends StatefulWidget {
  const PageViewIndicated({
    super.key,
    required this.pages,
    this.initalPageIndex = 0,
  });
  final List<Widget> pages;
  final int initalPageIndex;

  @override
  State<PageViewIndicated> createState() => _PageViewIndicatedState();
}

class _PageViewIndicatedState extends State<PageViewIndicated>
    with TickerProviderStateMixin {
  late final PageController pageController;
  late final TabController tabController;
  final duration = Duration(milliseconds: 200);
  final curve = Curves.ease;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.pages.length, vsync: this);
    pageController = PageController(initialPage: widget.initalPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              children: widget.pages,
              onPageChanged: (value) {
                tabController.animateTo(
                  value,
                  duration: duration,
                  curve: curve,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  pageController.previousPage(duration: duration, curve: curve);
                },
                icon: Icon(Icons.arrow_left_rounded),
              ),
              TabPageSelector(
                color: colorScheme.surface,
                selectedColor: colorScheme.primary,
                controller: tabController,
              ),
              IconButton(
                onPressed: () {
                  pageController.nextPage(duration: duration, curve: curve);
                },
                icon: Icon(Icons.arrow_right_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
