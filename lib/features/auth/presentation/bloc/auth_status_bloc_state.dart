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

class AuthStatusLocalFailed extends AuthStatus {
  AuthStatusLocalFailed({required this.keyFound});
  bool keyFound;
}

class AuthStatusFailedSignIn extends AuthStatus {
  final bool fallBackToLoginPage;
  final String? message;
  AuthStatusFailedSignIn({this.fallBackToLoginPage = false, this.message});
}

class AuthStatusFailedSignUp extends AuthStatus {
  final String? message;
  AuthStatusFailedSignUp({this.message});
}
