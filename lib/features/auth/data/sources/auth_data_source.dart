import 'dart:convert';

import 'package:digi_meh/features/auth/data/models/auth_tokens_model.dart';
import 'package:digi_meh/features/auth/data/models/login_user_model.dart';
import 'package:dio/dio.dart';

import 'package:digi_meh/core/data/configs/api_config.dart';
import 'package:digi_meh/features/auth/data/models/user_model.dart';
import 'package:flutter/rendering.dart';

abstract class AuthDataSource {
  Future<LoginUserModel> login({
    required String username,
    required String password,
  });
  Future<UserModel> getAuthUser({required String accessToken});
  Future<AuthTokensModel> refreshAuthSession({required String refreshToken});
}

class AuthDataSourceImpl extends AuthDataSource {
  AuthDataSourceImpl({required this.apiConfig, required this.dio});
  ECommerceApiConfig apiConfig;
  Dio dio;
  @override
  Future<LoginUserModel> login({
    required String username,
    required String password,
  }) async {
    final uri = apiConfig.uri("/auth/login");
    debugPrint("POST : $uri");
    final result = await dio.postUri(
      uri,
      data: jsonEncode({"username": username, "password": password}),
    );
    final json = result.data as Map<String, dynamic>;
    return LoginUserModel.fromJson(json);
  }

  @override
  Future<UserModel> getAuthUser({required String accessToken}) async {
    final uri = apiConfig.uri("/auth/me");
    debugPrint("GET : $uri");
    final result = await dio.getUri(
      uri,
      options: Options(
        headers: {
          "Authorization": accessToken,
          "Content-Type": "application/json",
        },
      ),
    );
    final json = result.data as Map<String, dynamic>;
    return UserModel.fromJson(json);
  }

  @override
  Future<AuthTokensModel> refreshAuthSession({
    required String refreshToken,
  }) async {
    final uri = apiConfig.uri("/auth/me");
    debugPrint("POST : $uri");
    final result = await dio.postUri(
      uri,
      data: jsonEncode({"refreshToken": refreshToken}),
    );

    final json = result.data as Map<String, dynamic>;

    return AuthTokensModel.fromJson(json);
  }
}
