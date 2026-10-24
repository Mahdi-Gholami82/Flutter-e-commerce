import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:digi_meh/core/presentation/widgets/default_shimmer_network_image.dart';
import 'package:digi_meh/features/auth/domain/entities/user_entity.dart';
import 'package:digi_meh/features/auth/presentation/bloc/auth_status_bloc.dart';
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
                          Positioned(
                            top: 10,
                            left: 10,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(SettingsPage.route);
                              },
                              icon: Icon(Icons.settings),
                              style: IconButton.styleFrom(
                                foregroundColor: colorScheme.onSecondary,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
