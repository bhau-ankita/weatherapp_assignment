// services/weather_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp1/model.dart';

class WeatherService with ChangeNotifier {
  late Weather _currentWeather;
  late List<Weather> _forecast;

  Weather get currentWeather => _currentWeather;
  List<Weather> get forecast => _forecast;

  Future<void> fetchWeatherData() async {
    try {
      final apiKey = '467d9a66647665dbc6b423b31e47bb8f';
      final currentWeatherUrl =
          'https://api.openweathermap.org/data/2.5/weather?q=Chandigarh&appid=467d9a66647665dbc6b423b31e47bb8f&units=metric';
      final forecastUrl =
          'https://api.openweathermap.org/data/2.5/forecast?q=Chandigarh&appid=467d9a66647665dbc6b423b31e47bb8f&units=metric';

      final currentWeatherResponse =
          await http.get(Uri.parse(currentWeatherUrl));
      final forecastResponse = await http.get(Uri.parse(forecastUrl));

      if (currentWeatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        _currentWeather =
            Weather.fromJson(jsonDecode(currentWeatherResponse.body));
        _forecast = (jsonDecode(forecastResponse.body)['list'] as List)
            .map((item) => Weather.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }

  void toggleTemperatureUnit() {}
}

IconData getWeatherIcon(String condition) {
  switch (condition.toLowerCase()) {
    case 'clear':
      return Icons.wb_sunny;
    case 'clouds':
      return Icons.cloud;
    case 'rain':
      return Icons.beach_access; // You can change this to a rain icon
    case 'snow':
      return Icons.ac_unit; // You can change this to a snow icon
    default:
      return Icons.help; // Default icon for unknown conditions
  }
}
