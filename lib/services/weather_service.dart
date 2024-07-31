import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/current_weather.dart';
import '../models/forecast.dart';


class WeatherService {
  final String apiKey = dotenv.env["API_KEY"]!;

  Future<CurrentWeather> getCurrentWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return CurrentWeather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  Future<List<Forecast>> getForecast(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['list'];
      return data.map((forecastJson) => Forecast.fromJson(forecastJson)).toList();
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}
