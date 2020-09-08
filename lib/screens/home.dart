import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/screens/loader.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/components/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String temp;
  String feelsLike;
  String city;
  String country;
  String windSpeed;
  String humidity;
  String pressure;
  String main;
  int sunrise;
  int sunset;

  Map<String, dynamic> data;
  Map<String, dynamic> forecast;
  String image;
  String forecastIcon;

  String getClockInUtcPlus3Hours(int timeSinceEpochInSec) {
    final time = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000,
            isUtc: false)
        .toLocal();
    return '${time.hour}:${time.second}';
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    if (args != null) {
      data = args.main;
      forecast = args.hourlyForecast;
    }

    temp = data['main']['temp'].toStringAsFixed(0);
    feelsLike = data['main']['feels_like'].toStringAsFixed(0);
    pressure = data['main']['pressure'].toString();
    humidity = data['main']['humidity'].toString();
    windSpeed = (data['wind']['speed'] * 3.6).toStringAsFixed(0);
    city = data['name'];
    country = data['sys']['country'];
    main = data['weather'][0]['main'];
    sunrise = data['sys']['sunrise'];
    sunset = data['sys']['sunset'];

    if (main == 'Clear') {
      image = 'clear';
    } else if (main == 'Rain') {
      image = 'rain';
    } else if (main == 'Snow') {
      image = 'snow';
    } else if (main == 'Thunderstorm') {
      image = 'thunderstorm';
    } else {
      image = 'clouds';
    }

    String forecastIconFunc(String forecastMain) {
      if (forecastMain == 'Clear') {
        return forecastIcon = 'solar';
      } else if (forecastMain == 'Rain') {
        return forecastIcon = 'rain';
      } else if (forecastMain == 'Snow') {
        return forecastIcon = 'snow';
      } else if (forecastMain == 'Thunderstorm') {
        return forecastIcon = 'flash';
      } else {
        return forecastIcon = 'cloud1';
      }
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/$image.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(children: [
                    Container(
                      padding:
                          EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 25.0,
                                  color: Colors.redAccent,
                                ),
                                Text(
                                  '$city, $country',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Ubuntu',
                                      color: main == 'Snow'
                                          ? Colors.grey
                                          : Colors.white),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/search');
                            },
                            child: Icon(
                              Icons.clear_all,
                              size: 30.0,
                              color:
                                  main == 'Snow' ? Colors.grey : Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(child: SizedBox(height: 150.0)),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                temp,
                                style: kTempText
                              ),
                              Text(
                                '\u2103',
                                style: kTempFeelsLike),
                            ],
                          ),
                        ),
                        Text(
                          main,
                          style: kWeatherMain
                        ),
                        Text(
                          'Feels $feelsLike' + '\u00B0',
                          style: kTempFeelsLike
                        ),
                      ],
                    ),
                  ]),
                ),
                Container(
                  color: Colors.white12,
                  child: Column(
                    children: [
                      Row(
                        children: [
                         WeatherCards(text: '${getClockInUtcPlus3Hours(sunrise)}',icon: 'sun',),
                          Div(height: 25.0),
                          WeatherCards(text: '${getClockInUtcPlus3Hours(sunset)}',icon: 'sunrise',)
                        ],
                      ),
                      Row(
                        children: [
                          WeatherCards(text: '$humidity %',icon:'humidity'),
                          Div(height: 20.0),
                          WeatherCards(text: '$windSpeed km/h',icon:'wind1'),
                          Div(height: 20.0),
                          WeatherCards(text: '$pressure Pa',icon:'pressure'),
                        ],
                      ),
                      Container(
                        height: 90.0,
                        width: double.infinity,
                        padding:
                            EdgeInsets.only(top: 8.0, bottom: 8.0, left: 10.0),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var i = 2; i <= 21; i++)
                              Container(
                                margin:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/${forecastIconFunc(forecast['list'][i]['weather'][0]['main'])}.png',
                                      scale: 10.0,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                        forecast['list'][i]['main']['temp']
                                                .toStringAsFixed(0) +
                                            '\u00B0',
                                        style: kForecastText
                                    ),
                                    Text(
                                      forecast['list'][i]['dt_txt']
                                          .toString()
                                          .substring(11, 16),
                                      style: kForecastText
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

