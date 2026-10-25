import 'package:digi_meh/features/auth/data/repositories/auth_repository.dart';
import 'package:digi_meh/features/auth/domain/entities/auth_token_entity.dart';

class RefreshAuthSessionUseCase {
  final AuthRepository _authRepository;
  RefreshAuthSessionUseCase({required this._authRepository});
  Future<AuthTokens> execute({required String refreshToken}) {
    return _authRepository.refreshAuthSession(refreshToken: refreshToken);
  }
}
