import 'dart:convert';

class Weather {
  final String location;
  final double temperature;
  final String condition;

  Weather({
    required this.location,
    required this.temperature,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        location: json['name'],
        temperature: json['main']['temp'].toDouble(),
        condition: json['weather'][0]['main']);
  }
}
