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

class AuthStatusSignUpSuccess extends AuthStatusNotAuthenticated {
  final String userName;
  final String password;
  AuthStatusSignUpSuccess({required this.userName, required this.password});
}

class AuthStatusInProgress extends AuthStatus {}

class AuthStatusInProgressSignUp extends AuthStatus {}

class AuthStatusLocalFailed extends AuthStatus {}

class AuthStatusFailedSignIn extends AuthStatus {
  final bool fallBackToLoginPage;
  final String? message;
  AuthStatusFailedSignIn({this.fallBackToLoginPage = false, this.message});
}

class AuthStatusFailedSignUp extends AuthStatus {
  final String? message;
  AuthStatusFailedSignUp({this.message});
}

sealed class AuthEvent {}

class AuthEventDoAuthenticateFromLocalToken extends AuthEvent {}

class AuthEventDoSignIn extends AuthEvent {
  final String userName;
  final String password;

  final bool checkOutWhenDone;
  AuthEventDoSignIn({
    required this.userName,
    required this.password,
    this.checkOutWhenDone = false,
  });
}

class AuthEventDoSignUp extends AuthEvent {
  final String userName;
  final String password;
  final String email;
  final String phone;
  AuthEventDoSignUp({
    required this.userName,
    required this.password,
    required this.email,
    required this.phone,
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
            AuthStatusFailedSignIn(
              message: "error : $error \nstack : $stackTrace",
            ),
          );
        }
        return;
      }
      emit(AuthStatusLocalFailed());
    });
    on<AuthEventDoSignIn>((event, emit) async {
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
        emit(
          AuthStatusFailedSignIn(
            message: "error : $error \nstack : $stackTrace",
          ),
        );
      }
    });
    on<AuthEventDoSignUp>((event, emit) async {
      emit(AuthStatusInProgressSignUp());
      try {
        final authRepository = GetIt.instance<AuthRepository>();
        await authRepository.signUp(
          username: event.userName,
          password: event.password,
          email: event.email,
          phone: event.phone,
        );
        emit(
          AuthStatusSignUpSuccess(
            userName: event.userName,
            password: event.password,
          ),
        );
      } catch (error, stackTrace) {
        emit(
          AuthStatusFailedSignUp(
            message: "error : $error \nstack : $stackTrace",
          ),
        );
      }
    });
  }
}
