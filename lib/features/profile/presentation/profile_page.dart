import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/core/presentation/widgets/default_shimmer_network_image.dart';
import 'package:digi_meh/features/auth/domain/entities/user_entity.dart';
import 'package:digi_meh/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:digi_meh/features/auth/presentation/pages/sign_in_page.dart';
import 'package:digi_meh/features/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_builder/shimmer_builder.dart';

class ProfilePage extends StatelessWidget {
  static const String route = "/profile";

  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return BlocBuilder<AuthBloc, AuthStatus>(
      builder: (context, state) {
        User? user = state is AuthStatusAuthenticated ? state.user : null;
        bool loggedIn = user != null;
        return Shimmer(
          enable: !loggedIn,
          child: Stack(
            children: [
              Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                color: colorScheme.secondaryFixedDim,
                                height: 150,
                              ),
                              SizedBox(height: 90),
                            ],
                          ),
                          Positioned.fill(
                            top: 20,
                            child: Center(
                              child: ShimmerPaintOver(
                                child: SizedBox.fromSize(
                                  size: .square(170),
                                  child: CircleAvatar(
                                    backgroundColor: colorScheme.onSurface,
                                    child: loggedIn
                                        ? DefaultShimmerNetworkImage(
                                            uriString: user.image.toString(),
                                          )
                                        : SizedBox.fromSize(
                                            size: defaultImageSize,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          ShimmerPaintOver(
                            child: Row(
                              mainAxisSize: .min,
                              mainAxisAlignment: .center,
                              children: [
                                SizedBox.fromSize(size: .square(40)),
                                Text(
                                  loggedIn
                                      ? "${user.firstName} ${user.lastName}"
                                      : "sample namess",
                                  style: TextStyle(fontSize: 18),
                                ),
                                if (loggedIn)
                                  SizedBox.fromSize(
                                    size: .square(40),
                                    child: IconButton(
                                      iconSize: 20,
                                      onPressed: () {},

                                      icon: Icon(Icons.edit),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          ShimmerPaintOver(
                            child: Text(
                              loggedIn ? user.email : "sample@opmain.dodo",
                              style: TextStyle(
                                color: colorScheme.outline,
                                overflow: .ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ShimmerPaintOver(
                            child: Text(
                              loggedIn ? user.phone : "+44 857 828 2288",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 70),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SizedBox(
                              width: 260,
                              child: Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsGeometry.directional(
                                        top: 10,
                                        start: 10,
                                      ),
                                      child: Align(
                                        alignment: .topStart,
                                        child: Icon(
                                          Icons.location_on,
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 10,
                                      ),
                                      child: ShimmerPaintOver(
                                        child: Column(
                                          children: [
                                            Text(
                                              loggedIn
                                                  ? user.address.location
                                                  : "some location i dont know",
                                              style: theme.textTheme.titleSmall,
                                            ),
                                            Text(
                                              loggedIn
                                                  ? "${user.address.country} ${user.address.city}"
                                                  : "some location i dont know ssss",
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                            Text(
                                              loggedIn
                                                  ? user.address.postalCode
                                                  : "421824",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 250,
                              child: Card(
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: .start,
                                      mainAxisAlignment: .start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.shopping_bag,
                                                color: colorScheme.outline,
                                              ),
                                              Text(
                                                "Orders",
                                                style: theme
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                      color:
                                                          colorScheme.outline,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // THE API DOESNT PROVIDE ANY
                                        if (!loggedIn)
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: ListView.builder(
                                                scrollDirection: .horizontal,
                                                itemCount: 4,
                                                itemBuilder: (context, index) =>
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            10,
                                                          ),
                                                      child: ShimmerPaintOver(
                                                        child: SizedBox(
                                                          height:
                                                              double.infinity,
                                                          width: 150,
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (loggedIn)
                                      Center(
                                        child: Text(
                                          "Nothing!",
                                          style: theme.textTheme.titleSmall!
                                              .copyWith(
                                                color: colorScheme.outline,
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!loggedIn) ...[
                Positioned.fill(
                  child: const ModalBarrier(
                    dismissible: false,
                    color: Colors.black26,
                  ),
                ),
                Positioned.fill(
                  top: 40,
                  child: Center(
                    child: Container(
                      height: 180,
                      padding: const .all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: .circular(25),
                        boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: -3)],
                      ),
                      child: Column(
                        mainAxisSize: .min,
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              spacing: 20,
                              children: [
                                Text("Sign in", style: textTheme.titleLarge!),
                                Text(
                                  "Please Sign in to access your profile.",
                                  style: textTheme.bodyMedium!,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamed(SignInPage.route);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                              ),
                              child: Text("Ok"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SettingsPage.route);
                  },
                  icon: Icon(Icons.settings),
                  style: IconButton.styleFrom(
                    foregroundColor: colorScheme.onSurface,
                    backgroundColor: colorScheme.surfaceContainer,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
