import 'package:digi_meh/features/auth/data/models/address_model.dart';
import 'package:digi_meh/features/auth/data/models/auth_tokens_model.dart';
import 'package:digi_meh/features/auth/data/models/sign_in_user_model.dart';
import 'package:digi_meh/features/auth/data/models/user_model.dart';
import 'package:digi_meh/features/auth/data/sources/auth_data_source.dart';
import 'package:digi_meh/features/auth/domain/entities/address_entity.dart';
import 'package:digi_meh/features/auth/domain/entities/auth_token_entity.dart';
import 'package:digi_meh/features/auth/domain/entities/coordinates_entity.dart';
import 'package:digi_meh/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<AuthTokens> login({
    required String userName,
    required String password,
  });

  Future<void> signUp({
    required String username,
    required String password,
    required String email,
    required String phone,
  });

  Future<User> getAuthUser({required String accessToken});
  Future<AuthTokens> refreshAuthSession({required String refreshToken});
}

class AuthRepositoryImpl extends AuthRepository {
  AuthDataSource dataSource;
  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<User> getAuthUser({required String accessToken}) async {
    UserModel user = await dataSource.getAuthUser(accessToken: accessToken);
    AddressModel address = user.address;
    return User(
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: user.phone,
      userName: user.username,
      password: user.password,
      image: Uri.parse(user.image),
      address: Address(
        location: address.location,
        city: address.city,
        state: address.state,
        stateCode: address.stateCode,
        postalCode: address.postalCode,
        country: address.country,
        coordinates: Coordinates(
          latitude: address.coordinates.$1,
          longtitude: address.coordinates.$2,
        ),
      ),
    );
  }

  @override
  Future<AuthTokens> login({
    required String userName,
    required String password,
  }) async {
    SignInUserModel user = await dataSource.signIn(
      username: userName,
      password: password,
    );
    return AuthTokens(
      refreshToken: user.refreshToken,
      accessToken: user.accessToken,
    );
  }

  @override
  Future<AuthTokens> refreshAuthSession({required String refreshToken}) async {
    AuthTokensModel authTokens = await dataSource.refreshAuthSession(
      refreshToken: refreshToken,
    );
    return AuthTokens(
      refreshToken: authTokens.refreshToken,
      accessToken: authTokens.accessToken,
    );
  }

  @override
  Future<void> signUp({
    required String username,
    required String password,
    required String email,
    required String phone,
  }) async {
    await dataSource.signUp(
      username: username,
      password: password,
      email: email,
      phone: phone,
    );
  }
}
