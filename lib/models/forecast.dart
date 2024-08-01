class Forecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final int humidity;  

  Forecast({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity, 
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: double.parse((json['main']['temp'] ?? '').toString()),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: int.parse((json['main']['humidity']??'').toString()),  
    );
  }
}