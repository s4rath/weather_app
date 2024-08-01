import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/current_weather.dart';
import '../provider/weather_provider.dart';
import '../widgets/search.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? country;
  String? city;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    Provider.of<WeatherProvider>(context, listen: false).loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CitySearchDropdown(),
                if (weatherProvider.currentWeather != null)
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Current Weather in ${weatherProvider.currentWeather!.city}, ${weatherProvider.currentWeather!.country}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'Temperature: ${weatherProvider.currentWeather!.temperature}°C',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                              'Feels Like: ${weatherProvider.currentWeather!.feelsLike}°C',
                              style: TextStyle(fontSize: 16)),
                          Text(
                              'Description: ${weatherProvider.currentWeather!.description}',
                              style: TextStyle(fontSize: 16)),
                          Text(
                              'Humidity: ${weatherProvider.currentWeather!.humidity}%',
                              style: TextStyle(fontSize: 16)),
                          Image.asset(
                              'assets/images/${weatherProvider.currentWeather!.icon}.png',
                              width: 50,
                              height: 50),
                        ],
                      ),
                    ),
                  ),
                if (weatherProvider.forecast != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: weatherProvider.forecast!.length,
                      itemBuilder: (context, index) {
                        final forecast = weatherProvider.forecast![index];
                        return Card(
                          child: ListTile(
                            leading: Image.asset(
                                'assets/images/${forecast.icon}.png',
                                width: 50,
                                height: 50),
                            title: Text(forecast.dateTime.toString()),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Temp: ${forecast.temperature}°C',
                                    style: TextStyle(fontSize: 16)),
                                Text('Desc: ${forecast.description}',
                                    style: TextStyle(fontSize: 14)),
                                Text('Humidity: ${forecast.humidity}%',
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
