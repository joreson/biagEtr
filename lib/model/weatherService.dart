import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mad2_etr/model/weatherModel.dart';

class WeatherServices {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> weatherUpdate(String cityName, int currentTimeStamp) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      //debugging

      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
