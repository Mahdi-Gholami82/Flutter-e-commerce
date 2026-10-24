class AuthTokensModel {
  String refreshToken;
  String accessToken;
  AuthTokensModel({required this.refreshToken, required this.accessToken});

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      refreshToken: json["refreshToken"] as String,
      accessToken: json["accessToken"] as String,
    );
  }
}
