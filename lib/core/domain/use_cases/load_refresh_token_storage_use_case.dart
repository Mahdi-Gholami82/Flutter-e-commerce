import 'package:digi_meh/features/auth/data/repositories/secure_storage_repository.dart';

class LoadRefreshTokenStorageUseCase {
  final SecureStorageRepository _secureStorageRepository;
  LoadRefreshTokenStorageUseCase({required this._secureStorageRepository});
  Future<String?> execute() => _secureStorageRepository.getRefreshToken();
}
