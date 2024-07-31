import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/city.dart';


class GeocodingService {
  final String apiKey = dotenv.env["API_KEY"]!;

  Future<List<City>> getCities(String cityName) async {
    final response = await http.get(
      Uri.parse('http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=3&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> data = json.decode(response.body);
      return data.map((cityJson) => City.fromJson(cityJson)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
