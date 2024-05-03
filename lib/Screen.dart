import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp1/model.dart';
import 'package:weatherapp1/apiservice.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isCelsius = true;

  void toggleTemperatureUnit() {
    setState(() {
      isCelsius = !isCelsius;
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              weatherService.fetchWeatherData();
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: weatherService.fetchWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching weather data'));
          } else {
            return WeatherDisplay(isCelsius: isCelsius);
          }
        },
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final bool isCelsius;

  WeatherDisplay({required this.isCelsius});

  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);
    final currentWeather = weatherService.currentWeather;
    final forecast = weatherService.forecast;

    double temperature = isCelsius
        ? currentWeather.temperature ?? 0.0
        : (currentWeather.temperature ?? 0.0) * 9 / 5 + 32;

    String unit = isCelsius ? '°C' : '°F';
    IconData weatherIcon = getWeatherIcon(currentWeather.condition!);

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                ' ${currentWeather.location}',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Text(
          'Today',
          style: TextStyle(
              fontSize: 20, color: const Color.fromARGB(255, 87, 87, 87)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          ' $temperature $unit',
          style:
              TextStyle(fontSize: 60, color: Color.fromARGB(255, 23, 54, 112)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          ' ${currentWeather.condition}',
          style:
              TextStyle(fontSize: 25, color: Color.fromARGB(255, 94, 94, 94)),
        ),
        SizedBox(height: 20),
        // Forecast for the next 5 day
        Text(
          '5-Day Forecast',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: forecast.length,
            itemBuilder: (context, index) {
              final weather = forecast[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.date}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Temperature: ${weather.temperature} ${weather.unit}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Weather Condition: ${weather.condition}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Icon(
                        weatherIcon,
                        size: 50,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
