import 'package:digi_meh/features/auth/data/sources/secure_storage_source.dart';

abstract class SecureStorageRepository {
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
}

class SecureStorageRepositoryImpl extends SecureStorageRepository {
  SecureStorageSource dataSource;
  SecureStorageRepositoryImpl({required this.dataSource});
  @override
  Future<String?> getRefreshToken() => dataSource.getRefreshToken();

  @override
  Future<void> saveRefreshToken(String refreshToken) =>
      dataSource.saveRefreshToken(refreshToken);
}
