import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:user_app/data/weather_gps.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? cityName;
  num? temp;
  bool isLoading = false;
  @override
  void initState() {
    getWeather();
    isLoading = true;
    super.initState();
  }

  void getWeather() async {
    final weatherGps = await WeatherGps.determinePosition();

    getWeatherData(weatherGps);
  }

  Future<Map<String, dynamic>> getWeatherData(Position position) async {
    final dio = Dio();

    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=4128f081b01220fc8588aa62658f22bc',
    );
    final Map<String, dynamic> data = response.data;
    cityName = data['name'];
    temp = data['main']['temp'];
    log('joop --> $response');
    log('latitude --> ${position.latitude}');
    log('longitude --> ${position.longitude}');

    setState(() {});
    isLoading = false;
    return data;
  }

  Future<Map<String, dynamic>> getCityName(String cityName) async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=4128f081b01220fc8588aa62658f22bc',
    );
    final Map<String, dynamic> data = response.data;
    cityName = data['name'];
    temp = data['main']['temp'];
    log('joop --> $data');

    setState(() {});
    isLoading = false;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User App"),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    onChanged: (value) {
                      cityName = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      hintText: "Search Weather ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      prefix: IconButton(
                        onPressed: () {
                          getCityName(cityName!);
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Шаардын аты: $cityName',
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  'Температура: $temp',
                  style: TextStyle(fontSize: 35),
                ),
              ],
            ),
    );
  }
}
