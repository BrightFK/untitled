import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/models/weather_model.dart';
import 'package:untitled/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("e334419b6b121981d20791d202b5b503");
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return "assets/lotie/sunny.json";
    }
    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "haze":
      case "dust":
      case "fog":
      case "smoke":
        return "assets/lotie/cloudy.json";
      case "rain":
      case "shower rain":
      case "drizzle":
        return "assets/lotie/rain.json";
      case "thunderstorm":
        return "assets/lotie/storm.json";
      case "clear":
        return "assets/lotie/sunny.json";
      default:
        return "assets/lotie/sunny.json";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900], // Deep blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City Name
            Text(
              _weather?.cityName ?? "Loading City...",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue[50], // Light blue text
              ),
            ),

            const SizedBox(height: 20),

            // Weather Animation
            Lottie.asset(
              getWeatherAnimation(_weather?.mainCondition),
              width: 200,
              height: 200,
            ),

            const SizedBox(height: 20),

            // Temperature
            Text(
              "${_weather?.temperature.round()}°C",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue[50], // Very light blue text
              ),
            ),

            const SizedBox(height: 10),

            // Weather Condition
            Text(
              _weather?.mainCondition ?? "",
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue[50], // Medium blue text
              ),
            ),
          ],
        ),
      ),
    );
  }
}