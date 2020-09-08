import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';



class Div extends StatelessWidget {
  Div({this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 2.0,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white38),
      ),
    );
  }
}

class WeatherCards extends StatelessWidget {

  WeatherCards({@required this.text,this.icon});

  final String text;
  final String icon;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 70.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/$icon.png',
                scale: 8.0),
            SizedBox(width: 10.0),
            Text(text,
                style:kWeatherBoxesText)
          ],
        ),
      ),
    );
  }
}