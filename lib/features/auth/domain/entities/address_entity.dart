import 'package:digi_meh/features/auth/domain/entities/coordinates_entity.dart';

class Address {
  String location;
  String city;
  String state;
  String stateCode;
  String postalCode;
  String country;
  Coordinates coordinates;
  Address({
    required this.location,
    required this.city,
    required this.state,
    required this.stateCode,
    required this.postalCode,
    required this.country,
    required this.coordinates,
  });
}
