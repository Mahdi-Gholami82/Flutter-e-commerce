import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageSource {
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
}

class SecureStorageSourceImpl extends SecureStorageSource {
  FlutterSecureStorage secureStorage;
  SecureStorageSourceImpl({required this.secureStorage});
  @override
  Future<void> saveRefreshToken(String refreshToken) =>
      secureStorage.write(key: "refreshToken", value: refreshToken);

  @override
  Future<String?> getRefreshToken() => secureStorage.read(key: "refreshToken");
}
