import 'package:digi_meh/features/auth/data/repositories/auth_repository.dart';
import 'package:digi_meh/features/auth/domain/entities/auth_token_entity.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  const SignInUseCase(this._authRepository);

  Future<AuthTokens> execute({
    required String userName,
    required String password,
  }) {
    return _authRepository.login(userName: userName, password: password);
  }
}
