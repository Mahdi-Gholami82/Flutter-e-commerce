import 'package:carousel_slider/carousel_slider.dart';
import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/core/presentation/widgets/default_shimmer_network_image.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/features/home/presentation/bloc/products_bloc.dart';
import 'package:digi_meh/features/home/presentation/bloc/products_paging_event.dart';
import 'package:digi_meh/features/home/presentation/bloc/products_paging_state.dart';
import 'package:digi_meh/features/home/presentation/bloc/search_products_bloc.dart';
import 'package:digi_meh/features/home/presentation/bloc/search_products_event.dart';
import 'package:digi_meh/features/home/presentation/bloc/search_products_state.dart';
import 'package:digi_meh/features/product_view/presentation/product_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer_builder/shimmer_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchController = SearchController();
  var scrollController = ScrollController();
  final int carouselLimit = 3;
  List<Product>? randProducts;
  final double carouselHeight = 250;

  void _triggerSearchViewRebuild() {
    const String zeroWidthSpace = '\u200B';
    final previousText = searchController.text;
    searchController.text = "$zeroWidthSpace$previousText";
    searchController.text = previousText;
  }

  String _getMinString(Product product, int limit) {
    return product.title.length <= limit
        ? product.title
        : product.title.substring(0, limit).replaceAll(RegExp(r".{3}$"), "...");
  }

  Future<void> _pushToProductViewPage(
    BuildContext context, {
    required Product product,
  }) => Navigator.of(
    context,
    rootNavigator: true,
  ).pushNamed(ProductViewPage.route, arguments: product);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var carouselColors = [
      (background: colorScheme.primary, foreground: colorScheme.onPrimary),
      (background: colorScheme.tertiary, foreground: colorScheme.onTertiary),
      (background: colorScheme.inverseSurface, foreground: colorScheme.surface),
    ];
    return Scaffold(
      body: BlocConsumer<ProductsPagingBloc, ProductsPagingState>(
        listener: (context, state) {
          var messenger = ScaffoldMessenger.of(context);
          if (state.error != null) {
            debugPrint(state.error.toString());
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(
              SnackBar(
                content: Text("Failed to load products"),
                persist: false,
                action: SnackBarAction(
                  label: "Refresh",
                  onPressed: () {
                    BlocProvider.of<ProductsPagingBloc>(
                      context,
                    ).add(ProductsPagingRefresh());
                  },
                ),
              ),
            );
          } else {
            if (state.pages?.isNotEmpty ?? false) {
              final products = state.pages!.first;
              if (randProducts?.isEmpty ?? true) {
                randProducts = [...products.nonNulls]..shuffle();
                randProducts = randProducts!.sublist(0, carouselColors.length);
              }
            }
          }
          messenger.hideCurrentSnackBar();
        },
        builder: (context, state) {
          bool isEmpty = state.pages?.isEmpty ?? true;
          bool productsFirstPageLoaded = !isEmpty;
          if (isEmpty && !state.isLoading) {
            BlocProvider.of<ProductsPagingBloc>(
              context,
            ).add(ProductsPagingRefresh());
          }
          List<Product> suggestions = [];

          return Shimmer(
            enable: !productsFirstPageLoaded,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsetsGeometry.all(10),
                      sliver: SliverFloatingHeader(
                        child:
                            BlocConsumer<
                              SearchProductsBloc,
                              SearchProductsState
                            >(
                              listener:
                                  (
                                    BuildContext context,
                                    SearchProductsState productsSearchState,
                                  ) {
                                    if (productsSearchState
                                        is SearchProductsLoaded) {
                                      suggestions =
                                          productsSearchState.result.products;
                                    } else {
                                      suggestions = [];
                                    }
                                    _triggerSearchViewRebuild();
                                  },
                              builder: (context, productsSearchState) {
                                return SearchAnchor(
                                  searchController: searchController,
                                  viewOnChanged: (value) {
                                    final query = value.trim();
                                    if (query.isNotEmpty) {
                                      BlocProvider.of<SearchProductsBloc>(
                                        context,
                                      ).add(SearchProducts(query: query));
                                    } else {
                                      suggestions = [];
                                      _triggerSearchViewRebuild();
                                    }
                                  },
                                  builder: (context, controller) => SearchBar(
                                    hintText: "Search products...",
                                    onTap: () {
                                      searchController.openView();
                                    },
                                    controller: controller,
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.search),
                                    ),
                                  ),
                                  suggestionsBuilder: (context, controller) {
                                    return suggestions.map(
                                      (product) => ListTile(
                                        title: Text(product.title),
                                        onTap: () async {
                                          await _pushToProductViewPage(
                                            context,
                                            product: product,
                                          );
                                          controller.closeView("");
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 30),
                      sliver: SliverToBoxAdapter(
                        child: ShimmerBuilder(
                          sampleBuilder: (context) => SizedBox(
                            height: carouselHeight,
                            width: double.infinity,
                          ),
                          childBuilder: (BuildContext context) {
                            return CarouselSlider(
                              items: List.generate(randProducts!.length, (
                                index,
                              ) {
                                var product = randProducts![index];
                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      _pushToProductViewPage(
                                        context,
                                        product: product,
                                      );
                                    },
                                    child: Container(
                                      padding: .symmetric(
                                        horizontal: 10,
                                        vertical: 20,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: carouselColors[index].background,
                                        borderRadius: .circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: .spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 4,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsGeometry.directional(
                                                    end: 5,
                                                    start: 10,
                                                  ),
                                              child: Column(
                                                mainAxisAlignment: .center,
                                                children: [
                                                  Flexible(
                                                    child: FittedBox(
                                                      child: Text(
                                                        _getMinString(
                                                          product,
                                                          20,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: .w500,
                                                          color:
                                                              carouselColors[index]
                                                                  .foreground,
                                                          overflow: .ellipsis,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Flexible(
                                                    child: FittedBox(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: colorScheme
                                                              .surfaceContainer,
                                                          borderRadius:
                                                              .circular(25),
                                                        ),
                                                        alignment: .center,
                                                        width: 80,
                                                        height: 30,
                                                        child: Text("View"),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 5,
                                            child: FittedBox(
                                              child: DefaultShimmerNetworkImage(
                                                uriString: product.thumbnail
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              options: CarouselOptions(
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                                height: carouselHeight,
                                pageViewKey: PageStorageKey<String>(
                                  'carousel_slider',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    PagedSliverGrid(
                      state: isEmpty
                          ? state.copyWith(
                              pages: [
                                List.filled(productsListPaginationLimit, null),
                              ],
                              keys: [0],
                              isLoading: false,
                            )
                          : state,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 175,
                      ),
                      fetchNextPage: () {
                        BlocProvider.of<ProductsPagingBloc>(
                          context,
                        ).add(ProductsPagingFetchNext());
                      },
                      builderDelegate: PagedChildBuilderDelegate<Product?>(
                        itemBuilder: (context, product, index) {
                          final border = BorderRadius.circular(15);
                          return Stack(
                            children: [
                              Material(
                                color: colorScheme.surfaceContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: border,
                                  side: BorderSide(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                                child: Ink(
                                  child: InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: border,
                                    ),
                                    onTap: () {
                                      if (product != null) {
                                        _pushToProductViewPage(
                                          context,
                                          product: product,
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: ShimmerBuilder(
                                              childBuilder: (context) {
                                                return SizedBox.fromSize(
                                                  size: defaultImageSize,
                                                  child: Shimmer(
                                                    enable: true,
                                                    child:
                                                        DefaultShimmerNetworkImage(
                                                          uriString: product!
                                                              .thumbnail
                                                              .toString(),
                                                        ),
                                                  ),
                                                );
                                              },
                                              sampleBuilder: (context) =>
                                                  SizedBox.fromSize(
                                                    size: defaultImageSize,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ShimmerPaintOver(
                                              child: Text(
                                                productsFirstPageLoaded
                                                    ? product!.title
                                                    : "sample txt",
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          FittedBox(
                                            child: ShimmerPaintOver(
                                              child: Text(
                                                "${productsFirstPageLoaded ? product!.price : "11.29"} \$",
                                                style:
                                                    theme
                                                        .textTheme
                                                        .titleSmall ??
                                                    TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          colorScheme.onSurface,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (productsFirstPageLoaded &&
                                  product!.discountPercentage != 0)
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: colorScheme.tertiary,
                                    ),
                                    child: Text(
                                      style: TextStyle(
                                        color: colorScheme.onTertiary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      "${product.discountPercentage.toStringAsFixed(1)} %",
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
