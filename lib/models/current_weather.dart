class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final String description;
  final String icon;

  CurrentWeather({required this.temperature, required this.feelsLike, required this.description, required this.icon});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: double.parse((json['main']['temp']??'').toString()),
      feelsLike: double.parse((json['main']['feels_like']??'').toString()),
      description: json['weather'][0]['description']??'',
      icon: json['weather'][0]['icon']??'',
    );
  }
}
