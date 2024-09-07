import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService( this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
        Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metrics'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (kDebugMode) {
        print("body object");
      }
      if (kDebugMode) {
        print(body);
      }
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Weather Data");
    }
  }

  Future<String> getCurrentCity() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;

    return city ?? "";
  }

}