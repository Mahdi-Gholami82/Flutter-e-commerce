import 'package:digi_meh/core/data/configs/api_config.dart';
import 'package:digi_meh/features/home/data/models/products_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

const String _selectProductFieldsQuery =
    "id,title,description,price,discountPercentage,rating,stock,tags,images,thumbnail";

abstract class ProductsSource {
  Future<ProductsListModel> getProducts({
    required int limit,
    required int skip,
  });

  Future<ProductsListModel> searchProducts({required String query});
}

class ProductsSourceImpl extends ProductsSource {
  ProductsSourceImpl({required this.dio, required this.apiConfig});
  final Dio dio;
  final ECommerceApiConfig apiConfig;

  @override
  Future<ProductsListModel> getProducts({
    required int limit,
    required int skip,
  }) async {
    var uri = apiConfig.uri(
      "/products",
      queryParameters: {
        "limit": limit.toString(),
        "skip": skip.toString(),
        "select": _selectProductFieldsQuery,
      },
    );
    debugPrint("GET: $uri");
    Response<dynamic> response = await dio.getUri(uri);
    Map<String, dynamic> json = response.data;
    return ProductsListModel.fromJson(json);
  }

  @override
  Future<ProductsListModel> searchProducts({required String query}) async {
    var uri = apiConfig.uri(
      "/products/search",
      queryParameters: {"q": query, "select": _selectProductFieldsQuery},
    );
    debugPrint("GET: $uri");
    Response<dynamic> response = await dio.getUri(uri);
    Map<String, dynamic> json = response.data;
    return ProductsListModel.fromJson(json);
  }
}
