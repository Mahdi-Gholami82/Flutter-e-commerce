import 'package:digi_meh/core/data/configs/api_config.dart';
import 'package:digi_meh/core/data/repositories/preferences_repository.dart';
import 'package:digi_meh/core/data/sources/preferences_data_source.dart';
import 'package:digi_meh/features/auth/data/repositories/auth_repository.dart';
import 'package:digi_meh/features/auth/data/repositories/secure_storage_repository.dart';
import 'package:digi_meh/features/auth/data/sources/auth_data_source.dart';
import 'package:digi_meh/features/auth/data/sources/secure_storage_source.dart';
import 'package:digi_meh/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:digi_meh/features/auth/presentation/pages/sign_in_page.dart';
import 'package:digi_meh/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:digi_meh/features/cart/presentation/bloc/cart_prefs_bloc.dart';
import 'package:digi_meh/features/home/data/repositories/products_repository.dart';
import 'package:digi_meh/features/home/data/sources/products_source.dart';
import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:digi_meh/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:digi_meh/features/landing/presentation/landing_page.dart';
import 'package:digi_meh/features/product_view/presentation/product_view_page.dart';
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
  getIt.registerSingleton(Dio());

  // home
  getIt.registerLazySingleton<ProductsSource>(
    () => ProductsSourceImpl(dio: getIt(), apiConfig: getIt()),
  );
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(dataSource: getIt()),
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

  getIt.registerLazySingleton(() => GetProductsUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => SearchProductsUseCase(repository: getIt()));

  // secure storage
  getIt.registerSingleton(FlutterSecureStorage());
  getIt.registerLazySingleton<SecureStorageSource>(
    () => SecureStorageSourceImpl(secureStorage: getIt()),
  );
  getIt.registerLazySingleton<SecureStorageRepository>(
    () => SecureStorageRepositoryImpl(dataSource: getIt()),
  );

  // auth
  getIt.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(apiConfig: getIt(), dio: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: getIt()),
  );
}

Future<void> main() async {
  await configureDependencies();
  runApp(const DigiMehApp());
}

class DigiMehApp extends StatelessWidget {
  const DigiMehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
        child: MaterialApp(
          title: "DigiMeh",
          theme: ThemeData(
            colorScheme: .fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
          ),
          home: const LandingPage(),
          onGenerateRoute: (settings) => switch (settings.name) {
            ProductViewPage.route => MaterialPageRoute(
              builder: (context) {
                return ProductViewPage(product: settings.arguments as Product);
              },
            ),
            SignInPage.route => MaterialPageRoute(
              builder: (context) {
                return SignInPage(checkOutWhenDone: settings.arguments as bool);
              },
            ),
            _ => null,
          },
        ),
      ),
    );
  }
}
