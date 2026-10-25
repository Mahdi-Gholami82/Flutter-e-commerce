import 'package:digi_meh/core/domain/use_cases/refresh_token_storage_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/get_auth_user_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/login_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/refresh_auth_session_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
      String? token = await getIt<LoadRefreshTokenStorageUseCase>().execute();
      if (token != null) {
        try {
          AuthTokens authTokens = await getIt<RefreshAuthSessionUseCase>()
              .execute(refreshToken: token);
          emit(
            AuthStatusAuthenticated(
              user: await getIt<GetAuthUserUseCase>().execute(
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
        var getIt = GetIt.instance;
        final authTokens = await getIt<LoginUseCase>().execute(
          userName: event.userName,
          password: event.password,
        );
        final user = await getIt<GetAuthUserUseCase>().execute(
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
        await GetIt.instance<SignUpUseCase>().execute(
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

  @override
  void onChange(Change<AuthStatus> change) {
    super.onChange(change);
    if (change.nextState case AuthStatusAuthenticated statusAuthenticated) {
      GetIt.instance<SaveRefreshTokenStorageUseCase>().execute(
        statusAuthenticated.authTokens.refreshToken,
      );
    }
  }
}
