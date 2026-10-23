import 'package:digi_meh/core/data/configs/api_config.dart';
import 'package:digi_meh/features/home/data/repositories/products_repository.dart';
import 'package:digi_meh/features/home/data/sources/products_source.dart';
import 'package:digi_meh/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:digi_meh/features/landing/presentation/landing_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  //prefs
  var prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton(ECommerceApiConfig(host: "dummyjson.com"));
  getIt.registerSingleton(Dio());

  // home
  getIt.registerLazySingleton<ProductsSource>(
    () => ProductsSourceImpl(dio: getIt(), apiConfig: getIt()),
  );
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetProductsUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => SearchProductsUseCase(repository: getIt()));
}

Future<void> main() async {
  await configureDependencies();
  runApp(const DigiMehApp());
}

class DigiMehApp extends StatelessWidget {
  const DigiMehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DigiMeh",
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const LandingPage(),
    );
  }
}
