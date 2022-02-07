import 'package:flutter/material.dart';
import 'package:haa_durumu/search_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'daily_weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sehir = "Ankara";
  double sicaklik;
  var locationData;
  var woeid;
  var weatherData;
  var weather;
  String havaDurumuKisaltmasi = 'c.jpg';
  List temps = [12, 12, 12, 12, 12];
  List temps_abb = ['a', 'a', 'a', 'a', 'a'];
  List<String> dates = List(5);

  Future<void> getLocationData() async {
    locationData = await http
        .get('https://www.metaweather.com/api/location/search/?query=$sehir');
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]["woeid"];
  }

  Future<void> getLocationWeather() async {
    weatherData =
        await http.get('https://www.metaweather.com/api/location/$woeid/');
    var weatherDataParsed = jsonDecode(weatherData.body);

    setState(() {
      sicaklik = weatherDataParsed["consolidated_weather"][0]["the_temp"];
      havaDurumuKisaltmasi =
          weatherDataParsed['consolidated_weather'][0]['weather_state_abbr'];

      for (int i = 0; i < temps.length; i++) {
        temps[i] = weatherDataParsed['consolidated_weather'][i + 1]['the_temp']
            .round();

        temps_abb[i] = weatherDataParsed['consolidated_weather'][i + 1]
            ['weather_state_abbr'];

        dates[i] =
            weatherDataParsed['consolidated_weather'][i + 1]['applicable_date'];
      }
    });
  }

  void getDatFromAPI() async {
    await getLocationData();
    getLocationWeather();
  }

  void initState() {
    getDatFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/$havaDurumuKisaltmasi.jpg')),
      ),
      child: sicaklik == null
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 60,
                      child: Image.network(
                          'https://www.metaweather.com/static/img/weather/png/${havaDurumuKisaltmasi}.png'),
                    ),
                    Text(
                      "${sicaklik.round()} C",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 70),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sehir,
                          style: TextStyle(fontSize: 30),
                        ),
                        IconButton(
                            onPressed: () async {
                              sehir = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage()));

                              getDatFromAPI();
                              setState(() {
                                sehir = sehir;
                              });
                            },
                            icon: Icon(Icons.search))
                      ],
                    ),
                    SizedBox(
                      height: 120,
                    ),
                    buildDailyWeatherCards(context),
                  ],
                ),
              ),
            ),
    );
  }

  Container buildDailyWeatherCards(BuildContext context) {
    List<Widget> cards = List(5);

    for (int i = 0; i < cards.length; i++) {
      cards[i] = DailyWeather(
        wallpaper: temps_abb[i],
        temp: temps[i].toString(),
        date: dates[i],
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: cards,
      ),
    );
  }
}
