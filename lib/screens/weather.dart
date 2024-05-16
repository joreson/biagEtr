import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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

  DateTime now = DateTime.now();

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
    String formattedDate = DateFormat('EEE, d MMM').format(now);
    return Column(
      children: [
        Gap(20),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 190,
            width: 375,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.all(
                Radius.circular(35.0), // Uniform border radius
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today",
                        style: TextStyle(
                            fontSize: 26,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ),
                      Gap(10),
                      Row(
                        children: [
                          Icon(Icons.location_on_sharp),
                          Text(
                            _weather?.location ?? "",
                            style: TextStyle(
                                fontSize: 13,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Gap(10),
                      if (_weather?.temperature != null)
                        Row(
                          children: [
                            Text(
                              '${_weather!.temperature.toString()}°c',
                              style: TextStyle(
                                  fontSize: 50,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Image.asset(
                          "asset/image/cloudy.png",
                          width: 110,
                          height: 110,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Gap(15),
        Text(
          "Weather Information",
          style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
              height: 380,
              width: 375,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.all(
                  Radius.circular(35.0), // Uniform border radius
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          "asset/image/sunrise.png",
                          width: 110,
                          height: 110,
                        ),
                        Text(
                          _weather?.sunRise ?? " ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 85, 85, 85),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Sunrise",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 128, 128, 128),
                          ),
                        ),
                        Gap(15),
                        Image.asset(
                          "asset/image/humidity.png",
                          width: 110,
                          height: 110,
                        ),
                        Text(
                          "${_weather?.humidity.toString()}%" ?? " ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 85, 85, 85),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Humidity",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 128, 128, 128),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          "asset/image/sunset.png",
                          width: 110,
                          height: 110,
                        ),
                        Text(
                          _weather?.sunSet ?? " ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 85, 85, 85),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Sunset",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 128, 128, 128),
                          ),
                        ),
                        Gap(15),
                        Image.asset(
                          "asset/image/wind.png",
                          width: 110,
                          height: 110,
                        ),
                        Text(
                          "${_weather?.windSpeed.toString()}m/s " ?? " ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 85, 85, 85),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Wind Speed",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 128, 128, 128),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
