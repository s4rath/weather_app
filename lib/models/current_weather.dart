class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final String description;
  final String icon;
  final int humidity;
  final String city;
  final String country;

  CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.city,
    required this.country,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: double.parse((json['main']['temp'] ?? '').toString()),
      feelsLike: double.parse((json['main']['feels_like'] ?? '').toString()),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: int.parse((json['main']['humidity'] ?? '').toString()),
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
