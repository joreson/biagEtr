import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class Weather {
  final String location;
  final double temperature;
  final String condition;
  final String sunRise;
  final String sunSet;
  final int humidity;
  final double windSpeed; // New field for wind speed

  Weather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.sunRise,
    required this.sunSet,
    required this.humidity,
    required this.windSpeed, // New field for wind speed
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    tzdata.initializeTimeZones();
    final phTimeZone = tz.getLocation('Asia/Manila');

    return Weather(
      location: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      sunRise: _formatUnixTimestamp(json['sys']['sunrise'], phTimeZone),
      sunSet: _formatUnixTimestamp(json['sys']['sunset'], phTimeZone),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'], // Parsing wind speed from JSON
    );
  }

  static String _formatUnixTimestamp(int timestamp, tz.Location timeZone) {
    final dateTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(timeZone, timestamp * 1000);
    final formattedTime = DateFormat('HH:mm a').format(dateTime);
    return formattedTime;
  }
}
