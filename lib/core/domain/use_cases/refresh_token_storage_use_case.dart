import 'package:digi_meh/features/auth/data/repositories/secure_storage_repository.dart';

class LoadRefreshTokenStorageUseCase {
  SecureStorageRepository secureStorageRepository;
  LoadRefreshTokenStorageUseCase({required this.secureStorageRepository});
  Future<String?> execute() => secureStorageRepository.getRefreshToken();
}

class SaveRefreshTokenStorageUseCase {
  SecureStorageRepository secureStorageRepository;
  SaveRefreshTokenStorageUseCase({required this.secureStorageRepository});
  Future<void> execute(String refreshToken) =>
      secureStorageRepository.saveRefreshToken(refreshToken);
}
