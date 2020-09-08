import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ScreenArguments{

  ScreenArguments(this.main, this.hourlyForecast);
  final Map<String, dynamic> main;
  final Map<String, dynamic> hourlyForecast;
}

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  double latitude;
  double longitude;
  Map<String, dynamic> data;
  Map<String, dynamic> forecast;


  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    try {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      getWeather();
    } catch (e) {
      print(e);
    }
  }

  Future getWeather() async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=[Your Api Key]&units=metric');
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      forecast= await getForecast();
      Navigator.pushNamed(context, '/home', arguments: ScreenArguments(data,forecast));
    } else {
      print(response.statusCode);
    }
  }

  Future getForecast() async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=[Your Api Key]&units=metric');
    if (response.statusCode == 200) {
      return(jsonDecode(response.body));
    } else {
      print(response.statusCode);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/thunderstorm.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.white12,
        body: Center(
          child: SizedBox(
            height: 100.0,
            width: 100.0,
            child:
                CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
