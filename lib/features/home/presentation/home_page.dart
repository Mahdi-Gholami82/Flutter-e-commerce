import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/core/presentation/widgets/default_shimmer_network_image.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';
import 'package:digi_meh/features/home/presentation/bloc/products_bloc.dart';
import 'package:digi_meh/features/home/presentation/bloc/search_products_bloc.dart';
import 'package:digi_meh/features/home/presentation/widgets/pagination_selector.dart';
import 'package:digi_meh/features/product_view/presentation/product_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_builder/shimmer_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchController = SearchController();
  var scrollController = ScrollController();
  int currentPageNumber = 0;
  final int carouselLimit = 3;
  List<Product>? randProducts;
  final double carouselHeight = 250;

  void _getProducts(BuildContext context, int pageIndex) {
    BlocProvider.of<ProductsBloc>(
      context,
    ).add(GetProductsEvent(pageNumber: pageIndex));
  }

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
      body: BlocConsumer<ProductsBloc, ProductsBlocState>(
        listener: (context, state) {
          var messenger = ScaffoldMessenger.of(context);
          switch (state) {
            case ProductsError error:
              {
                debugPrint(error.message);
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text("Failed to load products"),
                    action: SnackBarAction(
                      label: "Retry",
                      onPressed: () {
                        _getProducts(context, currentPageNumber);
                      },
                    ),
                  ),
                );
              }
            case ProductsLoading _:
              {
                if (scrollController.position.hasContentDimensions) {
                  scrollController.jumpTo(0);
                }
              }
            case ProductsLoaded loaded:
              {
                currentPageNumber = loaded.result.page.number;
                final products = loaded.result.products;
                randProducts = [...products]..shuffle();
                randProducts = randProducts!.sublist(0, carouselColors.length);
              }
            case ProductsInitial():
          }
          messenger.hideCurrentSnackBar();
        },
        builder: (context, state) {
          if (state is ProductsInitial) {
            _getProducts(context, currentPageNumber);
          }
          ProductsLoaded? loadedState = state is ProductsLoaded ? state : null;
          ProductsList? productsList = loadedState?.result;
          bool productsLoaded = loadedState != null;
          List<Product> suggestions = [];

          return Shimmer(
            enable: !productsLoaded,
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
                                          await Navigator.of(context).pushNamed(
                                            ProductViewPage.route,
                                            arguments: product,
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
                                return Container(
                                  padding: .symmetric(
                                    horizontal: 40,
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
                                        child: FittedBox(
                                          child: Text(
                                            _getMinString(product, 20),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: .w500,
                                              color: carouselColors[index]
                                                  .foreground,
                                              overflow: .ellipsis,
                                            ),
                                            maxLines: 1,
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
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Product? currentProduct =
                              loadedState?.result.products[index];
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
                                      if (currentProduct != null) {
                                        Navigator.of(context).pushNamed(
                                          ProductViewPage.route,
                                          arguments: currentProduct,
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
                                                          uriString:
                                                              currentProduct!
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
                                                productsLoaded
                                                    ? currentProduct!.title
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
                                                "${productsLoaded ? currentProduct!.price : "11.29"} \$",
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
                              if (productsLoaded &&
                                  currentProduct!.discountPercentage != 0)
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
                                      "${currentProduct.discountPercentage.toStringAsFixed(1)} %",
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                        childCount: productsLoaded
                            ? productsList!.products.length
                            : productsListPaginationLimit,
                      ),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        maxCrossAxisExtent: 150,
                        mainAxisExtent: 175,
                      ),
                    ),
                    if (productsLoaded && productsList!.page.totalPages > 0)
                      SliverPadding(
                        padding: EdgeInsetsGeometry.directional(
                          top: 20,
                          bottom: 10,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: PaginationSelector(
                            numberOfOptions: 5,
                            maxPage: productsLoaded
                                ? productsList.page.totalPages - 1
                                : 10,
                            selected: productsLoaded
                                ? productsList.page.number
                                : 1,
                            onTap: ({required int pageIndex}) {
                              _getProducts(context, pageIndex);
                            },
                          ),
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
