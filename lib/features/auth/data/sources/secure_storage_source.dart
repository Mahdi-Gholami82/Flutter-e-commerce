import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageSource {
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
}

class SecureStorageSourceImpl extends SecureStorageSource {
  final FlutterSecureStorage _secureStorage;
  SecureStorageSourceImpl({required this._secureStorage});
  @override
  Future<void> saveRefreshToken(String refreshToken) =>
      _secureStorage.write(key: "refreshToken", value: refreshToken);

  @override
  Future<String?> getRefreshToken() => _secureStorage.read(key: "refreshToken");
}
