import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city.dart';
import '../provider/city_provider.dart';
import '../provider/weather_provider.dart';


class CitySearchDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(hintText: 'Enter city name'),
          onChanged: (value) {
            if (value.isNotEmpty) {
              Provider.of<CityProvider>(context, listen: false).searchCity(value);
            }
          },
        ),
        Consumer<CityProvider>(
          builder: (context, cityProvider, child) {
            return cityProvider.cities.isEmpty
                ? Container()
                : DropdownButton<City>(
                    items: cityProvider.cities.map((City city) {
                      return DropdownMenuItem<City>(
                        value: city,
                        child: Text('${city.name}, ${city.state}, ${city.country}'),
                      );
                    }).toList(),
                    onChanged: (City? city) {
                      if (city != null) {
                        Provider.of<WeatherProvider>(context, listen: false).fetchWeather(city.lat, city.lon);
                      }
                    },
                  );
          },
        ),
      ],
    );
  }
}
