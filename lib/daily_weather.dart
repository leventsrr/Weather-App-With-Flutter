import 'package:flutter/material.dart';

class DailyWeather extends StatelessWidget {
  String date;
  String temp;
  String wallpaper;

  DailyWeather({this.date, this.temp, this.wallpaper});

  @override
  Widget build(BuildContext context) {
    List<String> days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar'
    ];
    String day;

    day = days[DateTime.parse(date).weekday - 1];

    return Card(
      elevation: 2,
      color: Colors.transparent,
      child: Container(
        height: 120,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://www.metaweather.com/static/img/weather/png/${wallpaper}.png',
              height: 50,
              width: 50,
            ),
            Text(temp.toString()),
            Text(day),
          ],
        ),
      ),
    );
  }
}
