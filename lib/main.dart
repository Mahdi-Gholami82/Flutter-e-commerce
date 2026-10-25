import 'package:digi_meh/core/data/configs/api_config.dart';
import 'package:digi_meh/core/data/repositories/preferences_repository.dart';
import 'package:digi_meh/core/data/sources/preferences_data_source.dart';
import 'package:digi_meh/core/domain/use_cases/load_refresh_token_storage_use_case.dart';
import 'package:digi_meh/core/domain/use_cases/save_refresh_token_storage_use_case.dart';
import 'package:digi_meh/core/presentation/theme/theme.dart';
import 'package:digi_meh/features/auth/data/repositories/auth_repository.dart';
import 'package:digi_meh/features/auth/data/repositories/secure_storage_repository.dart';
import 'package:digi_meh/features/auth/data/sources/auth_data_source.dart';
import 'package:digi_meh/features/auth/data/sources/secure_storage_source.dart';
import 'package:digi_meh/features/auth/domain/use_cases/get_auth_user_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/login_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:digi_meh/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:digi_meh/features/auth/presentation/pages/sign_in_page.dart';
import 'package:digi_meh/features/auth/presentation/pages/sign_up_page.dart';
import 'package:digi_meh/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:digi_meh/features/cart/presentation/bloc/cart_prefs_bloc.dart';
import 'package:digi_meh/features/home/data/repositories/products_repository.dart';
import 'package:digi_meh/features/home/data/sources/products_source.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:digi_meh/features/home/domain/use_cases/get_single_product_use_case.dart';
import 'package:digi_meh/features/home/domain/use_cases/search_products_use_case.dart';
import 'package:digi_meh/features/landing/presentation/landing_page.dart';
import 'package:digi_meh/features/product_view/presentation/product_view_page.dart';
import 'package:digi_meh/features/settings/presentation/bloc/theme_mode_cubit.dart';
import 'package:digi_meh/features/settings/presentation/settings_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  //prefs
  var prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerSingleton(ECommerceApiConfig(host: "dummyjson.com"));
  getIt.registerSingleton(
    BaseOptions(
      sendTimeout: Duration(seconds: 4),
      receiveTimeout: Duration(seconds: 4),
      connectTimeout: Duration(seconds: 4),
    ),
  );
  getIt.registerSingleton(Dio(getIt()));

  // home
  getIt.registerLazySingleton<ProductsSource>(
    () => ProductsSourceImpl(dio: getIt(), apiConfig: getIt()),
  );
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetProductsUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => SearchProductsUseCase(repository: getIt()));
  getIt.registerLazySingleton(
    () => GetSingleProductUseCase(repository: getIt()),
  );

  //prefs repo
  getIt.registerLazySingleton<PreferencesDataSource>(
    () => PreferencesDataSourceImpl(prefs: prefs),
  );
  getIt.registerLazySingleton<PreferencesRepository>(
    () => PreferencesRepositoryImpl(
      dataSource: getIt(),
      productsRepository: getIt(),
    ),
  );

  // secure storage
  getIt.registerSingleton(FlutterSecureStorage());
  getIt.registerLazySingleton<SecureStorageSource>(
    () => SecureStorageSourceImpl(secureStorage: getIt()),
  );
  getIt.registerLazySingleton<SecureStorageRepository>(
    () => SecureStorageRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton(
    () => LoadRefreshTokenStorageUseCase(secureStorageRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => SaveRefreshTokenStorageUseCase(secureStorageRepository: getIt()),
  );

  // auth
  getIt.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(apiConfig: getIt(), dio: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetAuthUserUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const DigiMehApp());
}

class DigiMehApp extends StatelessWidget {
  const DigiMehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeModeCubit(
            GetIt.instance<PreferencesRepository>().getThemeMode(),
          ),
          lazy: false,
        ),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => PrefsCartBloc()..add(PrefsCartBlocLoad())),
        BlocProvider(
          create: (_) =>
              AuthBloc()..add(AuthEventDoAuthenticateFromLocalToken()),
        ),
      ],
      child: BlocListener<PrefsCartBloc, PrefsCartBlocState>(
        listenWhen: (previous, current) =>
            previous is CartBlocPrefsLoading &&
            current is PrefsCartBlocFullyLoaded,
        listener: (context, state) {
          if (state is PrefsCartBlocFullyLoaded) {
            BlocProvider.of<CartCubit>(
              context,
            ).addAllCartItems(state.cartItems);
          }
        },
        child: BlocBuilder<ThemeModeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: "DigiMeh",
              themeMode: themeMode,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              home: const LandingPage(),
              routes: {
                SettingsPage.route: (_) => SettingsPage(),
                SignUpPage.route: (_) => SignUpPage(),
              },
              onGenerateRoute: (settings) => switch (settings.name) {
                ProductViewPage.route => MaterialPageRoute(
                  builder: (_) {
                    return ProductViewPage(
                      product: settings.arguments as Product,
                    );
                  },
                ),
                SignInPage.route => MaterialPageRoute(
                  builder: (_) {
                    return SignInPage(
                      checkOutWhenDone: settings.arguments as bool?,
                    );
                  },
                ),
                _ => null,
              },
            );
          },
        ),
      ),
    );
  }
}
