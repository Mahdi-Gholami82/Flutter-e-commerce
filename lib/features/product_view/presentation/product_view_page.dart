import 'package:collection/collection.dart';
import 'package:digi_meh/core/presentation/widgets/default_shimmer_network_image.dart';
import 'package:digi_meh/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/core/presentation/widgets/item_counter.dart';
import 'package:digi_meh/features/product_view/presentation/widgets/page_view_indicated.dart';
import 'package:digi_meh/features/product_view/presentation/widgets/shrikable_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_builder/shimmer_builder.dart';

class ProductViewPage extends StatefulWidget {
  const ProductViewPage({super.key, required this.product});
  static const String route = "/product_view";
  final Product product;

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  Product get product => widget.product;
  int numberOfItem = 1;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: PageViewIndicated(
                  pages: List.generate(
                    product.images.length,
                    (index) => ShrikableCircle(
                      color: colorScheme.onSecondaryContainer,
                      inPaddingAll: 25,
                      child: Center(
                        child: Shimmer(
                          enable: true,
                          child: DefaultShimmerNetworkImage(
                            uriString: product.images[index].toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${(product.price * (1 - product.discountPercentage / 100)).toStringAsFixed(2)} \$",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    style: const TextStyle(fontSize: 13),
                                    children: [
                                      TextSpan(text: "${product.rating}"),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.star_rate_rounded,
                                          size: 20,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Text(
                              "${product.price} \$",
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurfaceVariant,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      product.description,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              product.stock > 0
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              size: 18,
                              color: product.stock > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              product.stock > 0
                                  ? '${product.stock} in stock'
                                  : 'Out of stock',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: product.stock > 0
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Text("Comments"),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: SizedBox(
                  width: 300,
                  child: Card(
                    shape: StadiumBorder(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: FittedBox(
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      width: 2,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                                child: BlocBuilder<CartCubit, CartCubitState>(
                                  builder: (context, state) {
                                    numberOfItem =
                                        state.items
                                            .firstWhereOrNull(
                                              (e) => e.product == product,
                                            )
                                            ?.numberOfItem ??
                                        1;
                                    return ItemCounter(
                                      enable: product.stock > 0,
                                      initialCount: numberOfItem,
                                      onChanged: (int number) {
                                        numberOfItem = number;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: FittedBox(
                              child: TextButton(
                                onPressed: product.stock > 0
                                    ? () {
                                        BlocProvider.of<CartCubit>(
                                          context,
                                        ).addOrUpdateNumberOfItem(
                                          product,
                                          numberOfItem,
                                        );
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Add to Cart"),
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
            ),
          ],
        ),
      ),
    );
  }
}
