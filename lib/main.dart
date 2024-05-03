// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp1/Screen.dart';
import 'package:weatherapp1/apiservice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherService(),
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: WeatherScreen(),
      ),
    );
  }
}
