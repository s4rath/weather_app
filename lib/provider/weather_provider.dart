import 'package:flutter/material.dart';
import '../models/current_weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';


class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  CurrentWeather? _currentWeather;
  List<Forecast>? _forecast;

  CurrentWeather? get currentWeather => _currentWeather;
  List<Forecast>? get forecast => _forecast;

  Future<void> fetchWeather(double lat, double lon) async {
    _currentWeather = await _weatherService.getCurrentWeather(lat, lon);
    _forecast = await _weatherService.getForecast(lat, lon);
    notifyListeners();
  }
}
