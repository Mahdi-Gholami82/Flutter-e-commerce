import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:digi_meh/features/auth/data/repositories/auth_repository.dart';
import 'package:digi_meh/features/auth/data/repositories/secure_storage_repository.dart';
import 'package:digi_meh/features/auth/domain/entities/auth_token_entity.dart';
import 'package:digi_meh/features/auth/domain/entities/user_entity.dart';

sealed class AuthStatus {}

class AuthStatusAuthenticated extends AuthStatus {
  final User user;
  final AuthTokens authTokens;
  AuthStatusAuthenticated({required this.user, required this.authTokens});
}

class AuthStatusNotAuthenticated extends AuthStatus {}

class AuthStatusInProgress extends AuthStatus {}

class AuthStatusLocalFailed extends AuthStatus {}

class AuthStatusFailed extends AuthStatus {
  final bool fallBackToLoginPage;
  final String? message;
  AuthStatusFailed({this.fallBackToLoginPage = false, this.message});
}

sealed class AuthEvent {}

class AuthEventDoAuthenticateFromLocalToken extends AuthEvent {}

class AuthEventDoAuthenticate extends AuthEvent {
  final String userName;
  final String password;
  final bool checkOutWhenDone;
  AuthEventDoAuthenticate({
    required this.userName,
    required this.password,
    this.checkOutWhenDone = false,
  });
}

class AuthBloc extends Bloc<AuthEvent, AuthStatus> {
  AuthBloc() : super(AuthStatusNotAuthenticated()) {
    on<AuthEventDoAuthenticateFromLocalToken>((event, emit) async {
      var getIt = GetIt.instance;
      String? token = await getIt<SecureStorageRepository>().getRefreshToken();
      if (token != null) {
        var authRepository = getIt<AuthRepository>();
        try {
          AuthTokens authTokens = await authRepository.refreshAuthSession(
            refreshToken: token,
          );
          emit(
            AuthStatusAuthenticated(
              user: await authRepository.getAuthUser(
                accessToken: authTokens.accessToken,
              ),
              authTokens: authTokens,
            ),
          );
        } catch (error, stackTrace) {
          emit(
            AuthStatusFailed(message: "error : $error \nstack : $stackTrace"),
          );
        }
        return;
      }
      emit(AuthStatusLocalFailed());
    });
    on<AuthEventDoAuthenticate>((event, emit) async {
      emit(AuthStatusInProgress());
      try {
        final authRepository = GetIt.instance<AuthRepository>();
        final authTokens = await authRepository.login(
          userName: event.userName,
          password: event.password,
        );
        final user = await authRepository.getAuthUser(
          accessToken: authTokens.accessToken,
        );
        emit(AuthStatusAuthenticated(user: user, authTokens: authTokens));
      } catch (error, stackTrace) {
        emit(AuthStatusFailed(message: "error : $error \nstack : $stackTrace"));
      }
    });
  }
}
