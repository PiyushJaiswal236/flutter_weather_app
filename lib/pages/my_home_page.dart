import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:flutter_weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _myHomePageState();
}

class _myHomePageState extends State<MyHomePage> {
  final _weatherService = WeatherService("4cc659c18109806063d9c3d14c2b15c5");
  Weather? _weather;

  _fetchWeather() async{
    String city = await _weatherService.getCurrentCity();
    try{
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    }catch(e){
      print("an exception occured : ");
      print(e);
      print(e.toString());
    }
  }
  String getWeatherAnimation(String? maincondition){
    if(maincondition==null){
      return "lib/assets/WeatherSun.json";
    }
    switch(maincondition.toLowerCase()){
      case"clouds":
      case"mist":
      case"smoke":
      case"dust":
      case"haze":
      case"fog":
          return "lib/assets/WeatherCloud.json";
      case"rain":
      case"drizzle":
      case"shower rain":
        return "lib/assets/WeatherRainStorm.json";
      case"thunderstorm":
        return "lib/assets/WeatherRainStorm.json";
      case"clear":
        return "lib/assets/WeatherSun.json";

      default:
        return "lib/assets/WeatherSun.json";
    }
  }
  Future<void>_refresh()async{
    return await _fetchWeather();
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refresh  ,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_weather?.cityName??"loading city.."),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                  Text(_weather?.temperature!=null ?'${(_weather?.getTemperature())}°C': 'Loading Temperature..'),
                  Text(_weather?.mainCondition ?? "Loading..")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
