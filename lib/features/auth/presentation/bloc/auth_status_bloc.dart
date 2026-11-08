import 'package:digi_meh/core/domain/use_cases/load_refresh_token_storage_use_case.dart';
import 'package:digi_meh/core/domain/use_cases/save_refresh_token_storage_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/get_auth_user_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/refresh_auth_session_use_case.dart';
import 'package:digi_meh/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:digi_meh/features/auth/presentation/bloc/auth_status_bloc_event.dart';
import 'package:digi_meh/features/auth/presentation/bloc/auth_status_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:digi_meh/features/auth/domain/entities/auth_token_entity.dart';

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
      emit(AuthStatusLocalFailed(keyFound: token != null));
    });
    on<AuthEventDoSignIn>((event, emit) async {
      emit(AuthStatusInProgress());
      try {
        var getIt = GetIt.instance;
        final authTokens = await getIt<SignInUseCase>().execute(
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
    on<AuthReset>((event, emit) {
      emit(AuthStatusNotAuthenticated());
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
