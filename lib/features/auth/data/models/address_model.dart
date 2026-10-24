class AddressModel {
  String location;
  String city;
  String state;
  String stateCode;
  String postalCode;
  String country;
  (double lat, double lon) coordinates;
  AddressModel({
    required this.location,
    required this.city,
    required this.state,
    required this.stateCode,
    required this.postalCode,
    required this.country,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "location": location,
      "city": city,
      "state": state,
      "stateCode": stateCode,
      "postalCode": postalCode,
      "country": country,
      "coordinates": [coordinates.$1, coordinates.$2],
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      location: json["address"] as String,
      city: json["city"] as String,
      state: json["state"] as String,
      stateCode: json["stateCode"] as String,
      postalCode: json["postalCode"] as String,
      country: json["country"] as String,
      coordinates: (
        (json["coordinates"]["lat"] as num).toDouble(),
        (json["coordinates"]["lng"] as num).toDouble(),
      ),
    );
  }
}
