// models/weather.dart
class Weather {
  final String? location;
  final double? temperature;
  final String? condition;
  final String? unit;
  final String? date;

  Weather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.unit,
    required this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      unit: '°C', // Default to Celsius
      date: json['dt_txt'],
    );
  }
}
