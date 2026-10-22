import 'dart:convert';

import 'package:digi_meh/core/data/configs/api_config.dart';
import 'package:digi_meh/features/home/data/models/product_model.dart';
import 'package:dio/dio.dart';

abstract class ProductsSource {
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  });
}

class ProductsSourceImpl extends ProductsSource {
  ProductsSourceImpl({required this.dio, required this.apiConfig});
  final Dio dio;
  final ECommerceApiConfig apiConfig;

  @override
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  }) async {
    Response<dynamic> response = await dio.getUri(
      apiConfig.uri(
        "/products",
        queryParameters: {"limit": limit.toString(), "skip": skip.toString()},
      ),
    );
    List<dynamic> json = jsonDecode(response.data);
    return json.map((e) => ProductModel.fromJson(e)).toList();
  }
}
