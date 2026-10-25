import 'package:digi_meh/features/auth/data/repositories/auth_repository.dart';
import 'package:digi_meh/features/auth/domain/entities/auth_token_entity.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  const LoginUseCase(this._authRepository);

  Future<AuthTokens> execute({
    required String userName,
    required String password,
  }) {
    return _authRepository.login(userName: userName, password: password);
  }
}
