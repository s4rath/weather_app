import 'package:flutter/material.dart';
import '../database/weather_db.dart';
import '../models/current_weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  CurrentWeather? _currentWeather;
  List<Forecast>? _forecast;

  CurrentWeather? get currentWeather => _currentWeather;
  List<Forecast>? get forecast => _forecast;

  Future<void> fetchWeather(double lat, double lon, {String? city, String? country}) async {
    _currentWeather = await _weatherService.getCurrentWeather(lat, lon);
    _forecast = await _weatherService.getForecast(lat, lon);

    notifyListeners();
    

    if (city != null && country != null) {
      await WeatherDatabase.instance.deleteWeather();
      await WeatherDatabase.instance.deleteForecast();

      await WeatherDatabase.instance.insertWeather({
        'city': city,
        'country': country,
        'temperature': _currentWeather!.temperature,
        'feelsLike': _currentWeather!.feelsLike,
        'description': _currentWeather!.description,
        'icon': _currentWeather!.icon,
        'humidity': _currentWeather!.humidity,
      });

      for (var forecast in _forecast!) {
        await WeatherDatabase.instance.insertForecast({
          'dateTime': forecast.dateTime.toIso8601String(),
          'temperature': forecast.temperature,
          'description': forecast.description,
          'icon': forecast.icon,
          'humidity': forecast.humidity,
        });
      }
    }

    notifyListeners();
  }

  Future<void> loadSavedData() async {
    final weatherData = await WeatherDatabase.instance.fetchWeather();
    final forecastData = await WeatherDatabase.instance.fetchForecast();

    if (weatherData != null) {
      _currentWeather = CurrentWeather(
        temperature: weatherData['temperature'],
        feelsLike: weatherData['feelsLike'],
        description: weatherData['description'],
        icon: weatherData['icon'],
        humidity: weatherData['humidity'],
        city: weatherData['city'],
        country: weatherData['country'],
      );
    }

    _forecast = forecastData.map((data) {
      return Forecast(
        dateTime: DateTime.parse(data['dateTime']),
        temperature: data['temperature'],
        description: data['description'],
        icon: data['icon'],
        humidity: data['humidity'],
      );
    }).toList();

    notifyListeners();
  }
}
