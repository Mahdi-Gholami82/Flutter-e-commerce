class LoginUserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final Uri image;
  final String accessToken;
  final String refreshToken;

  const LoginUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json["id"] as int,
      username: json["username"] as String,
      email: json["email"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      image: Uri.parse(json["image"] as String),
      accessToken: json["accessToken"] as String,
      refreshToken: json["refreshToken"] as String,
    );
  }
}
