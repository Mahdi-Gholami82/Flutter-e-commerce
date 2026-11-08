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
