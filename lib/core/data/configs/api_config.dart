class ECommerceApiConfig {
  ECommerceApiConfig({required this.host});
  final String host;

  Uri uri(String path, {Map<String, String>? queryParameters}) =>
      Uri.https(host, path, queryParameters);
}
