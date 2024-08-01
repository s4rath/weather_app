import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/weather_provider.dart';
import '../widgets/search.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => loadData());
  }

  loadData() async {
    Provider.of<WeatherProvider>(context, listen: false).loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CitySearchDropdown(),
                //if loading it shows shimmer
                  if (weatherProvider.isLoading)
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: [
                        Card(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 20.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  width: double.infinity,
                                  height: 20.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  width: double.infinity,
                                  height: 20.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //if not loading and weather null then
                if (weatherProvider.currentWeather == null &&
                    (weatherProvider.forecast == null ||
                        weatherProvider.forecast!.isEmpty)&&!weatherProvider.isLoading)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No weather data available. Please search for a city.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (weatherProvider.currentWeather != null && !weatherProvider.isLoading)
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Current Weather in ${weatherProvider.currentWeather!.city}, ${weatherProvider.currentWeather!.country}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'Temperature: ${weatherProvider.currentWeather!.temperature}°C',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                              'Feels Like: ${weatherProvider.currentWeather!.feelsLike}°C',
                              style: const TextStyle(fontSize: 16)),
                          Text(
                              'Description: ${weatherProvider.currentWeather!.description}',
                              style: const TextStyle(fontSize: 16)),
                          Text(
                              'Humidity: ${weatherProvider.currentWeather!.humidity}%',
                              style: const TextStyle(fontSize: 16)),
                              //icon from the assets/images/
                          Image.asset(
                              'assets/images/${weatherProvider.currentWeather!.icon}.png',
                              width: 50,
                              height: 50),
                        ],
                      ),
                    ),
                  ),
                if (weatherProvider.forecast != null &&
                    weatherProvider.forecast!.isNotEmpty && !weatherProvider.isLoading)
                  Expanded(
                    child: ListView.builder(
                      itemCount: weatherProvider.forecast!.length,
                      itemBuilder: (context, index) {
                        final forecast = weatherProvider.forecast![index];
                        final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm')
                            .format(forecast.dateTime);
                        return Card(
                          child: ListTile(
                            leading: Image.asset(
                                'assets/images/${forecast.icon}.png',
                                width: 50,
                                height: 50),
                            title: Text(formattedDateTime),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Temp: ${forecast.temperature}°C',
                                    style: const TextStyle(fontSize: 16)),
                                Text('Desc: ${forecast.description}',
                                    style: const TextStyle(fontSize: 14)),
                                Text('Humidity: ${forecast.humidity}%',
                                    style: const TextStyle(fontSize: 14)),
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
