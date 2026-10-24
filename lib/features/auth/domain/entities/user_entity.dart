import 'package:digi_meh/features/auth/domain/entities/address_entity.dart';

class User {
  String firstName;
  String lastName;
  String email;
  String phone;
  String userName;
  String password;
  Uri image;
  Address address;
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.userName,
    required this.password,
    required this.image,
    required this.address,
  });
}
