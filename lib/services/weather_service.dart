import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/current_weather.dart';
import '../models/forecast.dart';

class WeatherService {
  final String apiKey = dotenv.env["API_KEY"]!;

  Future<CurrentWeather> getCurrentWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      data['main']['temp'] = (data['main']['temp'] - 273.15).toStringAsFixed(2);
      data['main']['feels_like'] =
          (data['main']['feels_like'] - 273.15).toStringAsFixed(2);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? country = prefs.getString('country');
      String? city = prefs.getString('city');
      data['country'] = country;
      data['city'] = city;
      return CurrentWeather.fromJson(data);
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  Future<List<Forecast>> getForecast(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['list'];
      data.forEach((forecastJson) {
        forecastJson['main']['temp'] =
            (forecastJson['main']['temp'] - 273.15).toStringAsFixed(2);
      });
      print(data);
      return data
          .map((forecastJson) => Forecast.fromJson(forecastJson))
          .toList();
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}
