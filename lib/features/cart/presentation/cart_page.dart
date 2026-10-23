import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/core/presentation/utils/default_image_loaders.dart';
import 'package:digi_meh/core/presentation/widgets/item_counter.dart';
import 'package:digi_meh/features/cart/domain/entities/cart_item_entity.dart';
import 'package:digi_meh/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  static const String route = "/cart";

  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<CartCubit, CartCubitState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              if (state.items.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    CartItem item = state.items[index];
                    Product product = item.product;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox(
                              height: (constraints.maxWidth / 2.5).clamp(
                                50,
                                140,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                spacing: 15,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 0,
                                    child: FittedBox(
                                      child: SizedBox.fromSize(
                                        size: defaultImageSize,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: colorScheme
                                                .surfaceContainerHigh,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Image.network(
                                            product.thumbnail.toString(),
                                            frameBuilder:
                                                defaultImageFrameBuilder,
                                            loadingBuilder:
                                                defaultImageLoadingBuilder,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentGeometry.bottomEnd,
                                          child: Container(
                                            decoration: ShapeDecoration(
                                              shape: StadiumBorder(),
                                              color: colorScheme
                                                  .surfaceContainerHigh,
                                            ),
                                            child: SizedBox(
                                              width: 100,
                                              child: FittedBox(
                                                child: ItemCounter(
                                                  enable:
                                                      item.numberOfItem <
                                                      product.stock,
                                                  initialCount:
                                                      item.numberOfItem,
                                                  textColor: colorScheme
                                                      .onSecondaryContainer,
                                                  onChanged: (number) {
                                                    BlocProvider.of<CartCubit>(
                                                      context,
                                                    ).updateNumberOfItem(
                                                      product,
                                                      number,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }, childCount: state.items.length),
                )
              else
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "Nothing Here!",
                      style: TextStyle(
                        fontSize: 26,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
