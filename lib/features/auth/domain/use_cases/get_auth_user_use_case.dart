import 'package:digi_meh/features/auth/data/repositories/auth_repository.dart';
import 'package:digi_meh/features/auth/domain/entities/user_entity.dart';

class GetAuthUserUseCase {
  final AuthRepository _authRepository;

  const GetAuthUserUseCase(this._authRepository);

  Future<User> execute({required String accessToken}) {
    return _authRepository.getAuthUser(accessToken: accessToken);
  }
}
