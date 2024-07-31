import 'package:flutter/material.dart';
import '../models/city.dart';
import '../services/geocoding_service.dart';

class CityProvider with ChangeNotifier {
  final GeocodingService _geocodingService = GeocodingService();
  List<City> _cities = [];

  List<City> get cities => _cities;

  Future<void> searchCity(String cityName) async {
    _cities = await _geocodingService.getCities(cityName);
    notifyListeners();
  }

  void clearCities() {
    _cities = [];
    notifyListeners();
  }
}