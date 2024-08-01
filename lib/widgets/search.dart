import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import '../provider/city_provider.dart';
import '../provider/weather_provider.dart';

class CitySearchDropdown extends StatefulWidget {
  @override
  _CitySearchDropdownState createState() => _CitySearchDropdownState();
}

class _CitySearchDropdownState extends State<CitySearchDropdown> {
  TextEditingController _controller = TextEditingController();
   bool _isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTextFieldEmpty = _controller.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter city name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(_isTextFieldEmpty ? Icons.search : Icons.clear),
                onPressed: () {
                   if (!_isTextFieldEmpty) {
                    _controller.clear();
                    Provider.of<CityProvider>(context, listen: false).clearCities();
                  }
                },
              ),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                Provider.of<CityProvider>(context, listen: false).clearCities();
              } else {
                Provider.of<CityProvider>(context, listen: false).searchCity(value);
              }
            },
          ),
        ),
        Consumer<CityProvider>(
          builder: (context, cityProvider, child) {
            if (cityProvider.cities.isEmpty) {
              return Container();
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: cityProvider.cities.length,
                itemBuilder: (context, index) {
                  final city = cityProvider.cities[index];
                  return ListTile(
                    title: Text('${city.name}, ${city.state}, ${city.country}'),
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('city', city.name);
                      prefs.setString('country', city.country);
                      Provider.of<WeatherProvider>(context, listen: false).fetchWeather(
                        city.lat,
                        city.lon,
                        city: city.name,
                        country: city.country,
                      );
                      Provider.of<CityProvider>(context, listen: false).clearCities();
                      // _controller.clear();
                    },
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}