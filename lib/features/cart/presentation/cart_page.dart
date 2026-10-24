import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/core/presentation/widgets/default_shimmer_network_image.dart';
import 'package:digi_meh/core/presentation/widgets/item_counter.dart';
import 'package:digi_meh/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:digi_meh/features/auth/presentation/pages/sign_in_page.dart';
import 'package:digi_meh/features/cart/domain/entities/cart_item_entity.dart';
import 'package:digi_meh/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:digi_meh/features/cart/presentation/bloc/cart_prefs_bloc.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_builder/shimmer_builder.dart';

class CartPage extends StatelessWidget {
  static const String route = "/cart";

  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<PrefsCartBloc, PrefsCartBlocState>(
        listener: (context, prefsCartBlocState) {},
        builder: (context, prefsCartBlocState) {
          return BlocBuilder<CartCubit, CartCubitState>(
            builder: (context, cartCubitState) {
              final bool isEmpty =
                  cartCubitState.items.isEmpty &&
                  switch (prefsCartBlocState) {
                    CartBlocPrefsLoading loading =>
                      loading.cartItemsLoading.isEmpty,
                    _ => true,
                  };
              var prefsCartLenght = switch (prefsCartBlocState) {
                CartBlocPrefsLoading loading => loading.cartItemsLoading.length,
                _ => 0,
              };
              final int childCount =
                  prefsCartLenght + cartCubitState.items.length;
              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      if (!isEmpty)
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            Future<CartItem> itemFuture =
                                prefsCartLenght - 1 < index
                                ? Future.value(
                                    cartCubitState.items[index -
                                        prefsCartLenght],
                                  )
                                : (prefsCartBlocState as CartBlocPrefsLoading)
                                      .cartItemsLoading[index];
                            return FutureBuilder(
                              future: itemFuture,
                              builder: (context, asyncSnapshot) {
                                Product? product;
                                CartItem? cartItem;
                                if (asyncSnapshot.hasData) {
                                  cartItem = asyncSnapshot.data!;
                                  product = cartItem.product;
                                }
                                return Shimmer(
                                  enable: !asyncSnapshot.hasData,
                                  child: Padding(
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
                                        color: colorScheme.surfaceContainer,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          return SizedBox(
                                            height: (constraints.maxWidth / 2.5)
                                                .clamp(50, 120),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              spacing: 15,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 0,
                                                  child: FittedBox(
                                                    child: SizedBox.fromSize(
                                                      size: defaultImageSize,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: colorScheme
                                                              .secondaryFixed,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                25,
                                                              ),
                                                        ),
                                                        child: ShimmerBuilder(
                                                          sampleBuilder: (context) =>
                                                              SizedBox.fromSize(
                                                                size:
                                                                    defaultImageSize,
                                                              ),
                                                          childBuilder: (context) {
                                                            return DefaultShimmerNetworkImage(
                                                              uriString: product!
                                                                  .thumbnail
                                                                  .toString(),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                        child: ShimmerPaintOver(
                                                          child: Text(
                                                            product?.title ??
                                                                "Some sample product title",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentGeometry
                                                                .bottomEnd,
                                                        child: Container(
                                                          decoration: ShapeDecoration(
                                                            shape:
                                                                StadiumBorder(),
                                                            color: colorScheme
                                                                .surfaceContainerHigh,
                                                          ),
                                                          child: SizedBox(
                                                            width: 100,
                                                            child: FittedBox(
                                                              child: ShimmerPaintOver(
                                                                child: ItemCounter(
                                                                  onDelete: () {
                                                                    var cartCubit =
                                                                        BlocProvider.of<
                                                                          CartCubit
                                                                        >(
                                                                          context,
                                                                        );
                                                                    cartCubit
                                                                        .remove(
                                                                          cartItem!,
                                                                        );
                                                                    ScaffoldMessenger.of(
                                                                      context,
                                                                    ).showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(
                                                                              "Item removed",
                                                                            ),
                                                                        action: SnackBarAction(
                                                                          label:
                                                                              "Undo",
                                                                          onPressed: () {
                                                                            cartCubit.add(
                                                                              cartItem!,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  enable:
                                                                      cartItem ==
                                                                          null
                                                                      ? false
                                                                      : cartItem.numberOfItem <
                                                                            product!.stock,
                                                                  initialCount:
                                                                      cartItem
                                                                          ?.numberOfItem ??
                                                                      1,
                                                                  textColor:
                                                                      colorScheme
                                                                          .onSecondaryContainer,
                                                                  onChanged: (number) {
                                                                    if (product !=
                                                                        null) {
                                                                      BlocProvider.of<
                                                                            CartCubit
                                                                          >(context)
                                                                          .updateNumberOfItem(
                                                                            product,
                                                                            number,
                                                                          );
                                                                    }
                                                                  },
                                                                ),
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
                                  ),
                                );
                              },
                            );
                          }, childCount: childCount),
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
                  ),

                  Positioned.directional(
                    bottom: 10,
                    end: 10,
                    textDirection: Directionality.of(context),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                      onPressed: isEmpty
                          ? null
                          : () {
                              var authBloc = BlocProvider.of<AuthBloc>(context);
                              if (authBloc.state is AuthStatusAuthenticated) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Success!")),
                                );
                              } else {
                                Navigator.of(
                                  context,
                                ).pushNamed(SignInPage.route, arguments: true);
                              }
                            },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 45),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 20,
                          children: [
                            Text("Checkout", style: TextStyle(fontSize: 15)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Icon(
                                Icons.arrow_forward_outlined,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
