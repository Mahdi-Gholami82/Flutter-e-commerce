import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';
import 'package:digi_meh/features/home/presentation/bloc/products_bloc.dart';
import 'package:digi_meh/features/home/presentation/widgets/pagination_selector.dart';
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

  void getProducts(BuildContext context, int pageIndex) {
    BlocProvider.of<ProductsBloc>(
      context,
    ).add(GetProductsEvent(pageNumber: pageIndex));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
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
                        getProducts(context, currentPageNumber);
                      },
                    ),
                  ),
                );
              }
            case ProductsLoading _:
              {
                scrollController.jumpTo(0);
              }
            case ProductsLoaded loaded:
              {
                currentPageNumber = loaded.result.page.number;
              }
            case ProductsInitial():
          }
          messenger.hideCurrentSnackBar();
        },
        builder: (context, state) {
          if (state is ProductsInitial) {
            getProducts(context, currentPageNumber);
          }
          ProductsLoaded? loadedState = state is ProductsLoaded ? state : null;
          ProductsList? productsList = loadedState?.result;
          bool productsLoaded = loadedState != null;
          return Shimmer(
            enable: !productsLoaded,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsetsGeometry.all(10),
                  sliver: SliverFloatingHeader(
                    child: SearchAnchor(
                      searchController: searchController,
                      viewOnChanged: (value) {},
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
                        return [];
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsetsGeometry.all(10),
                  sliver: SliverToBoxAdapter(
                    child: Card(
                      child: SizedBox(
                        width: 400,
                        height: 300,
                        child: Center(
                          child: Text(
                            "MEH BANNER",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Product? currentProduct =
                            loadedState?.result.products[index];
                        Widget getTempImageBox() =>
                            SizedBox(width: 226, height: 226);

                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: colorScheme.surfaceContainer,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: ShimmerBuilder(
                                        childBuilder: (context) {
                                          return Image.network(
                                            currentProduct!.thumbnail
                                                .toString(),
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return ShimmerPaintOver(
                                                    child: FittedBox(
                                                      child: getTempImageBox(),
                                                    ),
                                                  );
                                                },
                                          );
                                        },
                                        sampleBuilder: (context) =>
                                            getTempImageBox(),
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
                                            overflow: TextOverflow.ellipsis,
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
                                              theme.textTheme.titleSmall ??
                                              TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: colorScheme.onSurface,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                        selected: productsLoaded ? productsList.page.number : 1,
                        onTap: ({required int pageIndex}) {
                          getProducts(context, pageIndex);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
