import 'package:flutter/material.dart';
import 'package:mad2_etr/model/weatherModel.dart';
import 'package:mad2_etr/model/weatherService.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({super.key});

  @override
  State<WeatherDisplay> createState() => WeatherDisplayState();
}

class WeatherDisplayState extends State<WeatherDisplay> {
  final _weatherServices = WeatherServices('de1fb5334de6d614fdf68d14aa4e7d81');
  Weather? _weather;
  var weatherController = TextEditingController();
  void onPressed() {
    weatherStatus(weatherController.text);
  }

  weatherStatus(String cityName) async {
    weatherController.clear();
    try {
      final weather = await _weatherServices.weatherUpdate(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Location Input'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          'https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: weatherController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(
                      'Enter Location',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    'Enter',
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    _weather?.location ?? "",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  if (_weather?.temperature != null)
                    Text(
                      '${_weather!.temperature.toString()} ° ',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  Text(
                    _weather?.condition ?? "",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
