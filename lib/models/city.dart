class City {
  final String name;
  final String country;
  final String state;
  final double lat;
  final double lon;

  City({required this.name, required this.country, required this.state, required this.lat, required this.lon});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      country: json['country'],
      state: json['state'] ?? '',
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}
