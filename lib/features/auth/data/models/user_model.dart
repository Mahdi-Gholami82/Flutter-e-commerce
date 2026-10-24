import "package:digi_meh/features/auth/data/models/address_model.dart";

class UserModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String username;
  String password;
  String image;
  AddressModel address;
  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.image,
    required this.address,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      email: json["email"] as String,
      phone: json["phone"] as String,
      username: json["username"] as String,
      password: json["password"] as String,
      image: json["image"] as String,
      address: AddressModel.fromJson(json["address"] as Map<String, dynamic>),
    );
  }
}
