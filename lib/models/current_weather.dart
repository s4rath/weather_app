class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final String description;
  final String icon;

  CurrentWeather({required this.temperature, required this.feelsLike, required this.description, required this.icon});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
