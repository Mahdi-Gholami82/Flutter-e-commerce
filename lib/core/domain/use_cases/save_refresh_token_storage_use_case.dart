import 'package:digi_meh/features/auth/data/repositories/secure_storage_repository.dart';

class SaveRefreshTokenStorageUseCase {
  final SecureStorageRepository _secureStorageRepository;
  SaveRefreshTokenStorageUseCase({required this._secureStorageRepository});
  Future<void> execute(String refreshToken) =>
      _secureStorageRepository.saveRefreshToken(refreshToken);
}
