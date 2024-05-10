import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mad2_etr/model/weatherModel.dart';
import 'package:mad2_etr/model/weatherService.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({super.key});

  @override
  State<WeatherDisplay> createState() => WeatherDisplayState();
}

class WeatherDisplayState extends State<WeatherDisplay> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weatherStatus();
  }

  final _weatherServices = WeatherServices('de1fb5334de6d614fdf68d14aa4e7d81');
  int currentTimeStamp = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  Weather? _weather;
  var weatherController = TextEditingController();

  weatherStatus() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      String? city = placemark[0].locality;

      final weather =
          await _weatherServices.weatherUpdate(city!, currentTimeStamp);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Location'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
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
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold),
                  ),
                  if (_weather?.temperature != null)
                    Text(
                      '${_weather!.temperature.toString()} ° ',
                      style: TextStyle(
                          fontSize: 40,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold),
                    ),
                  Text(
                    _weather?.condition ?? "",
                    style: TextStyle(
                        fontSize: 40,
                        color: const Color.fromARGB(255, 0, 0, 0),
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
