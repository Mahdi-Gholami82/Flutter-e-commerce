import 'package:digi_meh/features/auth/data/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  const SignUpUseCase(this._authRepository);

  Future<void> execute({
    required String username,
    required String password,
    required String email,
    required String phone,
  }) {
    return _authRepository.signUp(
      username: username,
      password: password,
      email: email,
      phone: phone,
    );
  }
}
