import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/weather_provider.dart';
import '../widgets/search.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return Column(
            children: [
              CitySearchDropdown(),
              weatherProvider.currentWeather == null
                  ? Container()
                  : Column(
                      children: [
                        Text('Temperature: ${weatherProvider.currentWeather!.temperature}'),
                        Text('Feels Like: ${weatherProvider.currentWeather!.feelsLike}'),
                        Text('Description: ${weatherProvider.currentWeather!.description}'),
                      ],
                    ),
              weatherProvider.forecast == null
                  ? Container()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: weatherProvider.forecast!.length,
                        itemBuilder: (context, index) {
                          final forecast = weatherProvider.forecast![index];
                          return ListTile(
                            title: Text(forecast.dateTime.toString()),
                            subtitle: Text('Temp: ${forecast.temperature}, Desc: ${forecast.description}'),
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
