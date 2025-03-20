import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled/models/weather_model.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final respose = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (respose.statusCode == 200) {
      return Weather.fromJSON(jsonDecode(respose.body));
    } else {
      throw Exception("Failed To Load Weather Data");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high
    );

    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemark[0].locality;
    return city ?? "";

  }
  
}