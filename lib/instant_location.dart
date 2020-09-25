import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/home_page.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'five_days.dart';
import 'hourly_weather.dart';
import 'const.dart';
import 'package:sunrise_sunset/sunrise_sunset.dart';

const kGoogleApiKey = "AIzaSyBsJSWotej3zidCHU5Nnpf_BexRidQYdNU";

class InstantLocation extends StatefulWidget {
  @override
  _InstantLocationState createState() => _InstantLocationState();
}

class _InstantLocationState extends State<InstantLocation> {
  String key = '247c8340cf1d2b45c5f816a9da633caf';
  String background = 'images/after_noon.png';
  String gifAsset = 'gifAfterNoon/';
  TextStyle textColor = afterNoon;
  TextStyle textTemp = afterNoonTemp;
  int _curIndex = 0;
  double lat, lon;
  WeatherFactory ws;
  final f = new DateFormat.MMMMd();
  final f2 = new DateFormat.Hm();
  @override
  initState() {
    ws = new WeatherFactory(key, language: Language.TURKISH);

    super.initState();
  }

  Future<void> bul() async {
    List<Weather> day = new List<Weather>();
    Position position = await getCurrentPosition(
      desiredAccuracy: LocationAccuracy.lowest,
      forceAndroidLocationManager: mounted,
    );
    lat = position.latitude;
    lon = position.longitude;
    Weather w = await ws.currentWeatherByLocation(lat, lon);
    List<Weather> weather = await ws.fiveDayForecastByLocation(lat, lon);
    for (var i = 0; i < weather.length; i++) {
      if (weather[i].date.day == DateTime.now().day) {
        day.add(weather[i]);
      }
    }
    setState(() {
      if (w.sunrise.isAfter(DateTime.now())) {
        background = 'images/night.png';
        textColor = night;
        textTemp = nightTemp;
        gifAsset = 'gifNight/';
      } else if (w.sunset.isBefore(DateTime.now())) {
        background = 'images/night.png';
      }
    });
    return [
      w.temperature.celsius.round().toString() + "° C",
      w.areaName,
      w.weatherMain,
      w.country,
      w.weatherDescription,
      w.temperature.celsius.round() >= FiveDays().minMax(day)[0]
          ? FiveDays().minMax(day)[0].toString()
          : w.temperature.celsius.round().toString(),
      w.temperature.celsius.round() <= FiveDays().minMax(day)[1]
          ? FiveDays().minMax(day)[1].toString()
          : w.temperature.celsius.round().toString(),
      weather,
      w.date.toString(),
      w.sunrise,
      w.sunset
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          background,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   automaticallyImplyLeading: false,
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(DateFormat('EEE').format(DateTime.now()) +
          //           ", " +
          //           f.format(DateTime.now())),
          //       Text('°C')
          //     ],
          //   ),
          // ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              child: Column(
                children: [
                  FutureBuilder(
                    future: bul(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('Loading'));
                      }
                      return Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(f.format(DateTime.now()),
                                              style: textColor),
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data[0],
                                            style: textTemp,
                                          ),
                                        ]),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data[1] + ", ",
                                          style: textColor,
                                        ),
                                        Text(snapshot.data[3],
                                            style: textColor),
                                      ],
                                    ),
                                    Text(
                                        'Max:' +
                                            snapshot.data[6] +
                                            "°" +
                                            ' Min:' +
                                            snapshot.data[5] +
                                            "°",
                                        style: textColor),
                                    Text(
                                        'GD: ' +
                                            f2.format(snapshot.data[9]) +
                                            ' GB: ' +
                                            f2.format(snapshot.data[10]),
                                        style: textColor),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          '${gifAsset}${snapshot.data[2]}.gif'),
                                      width: 225,
                                    ),
                                    Text(snapshot.data[4], style: textColor),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: HourlyWeather()
                                .hourly(snapshot.data[7], gifAsset, textColor),
                          ),
                          FiveDays()
                              .fiveDays(snapshot.data[7], gifAsset, textColor),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _curIndex,
              onTap: (index) {
                setState(() {
                  _curIndex = index;
                  switch (_curIndex) {
                    case 0:
                      break;
                    case 1:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                      break;
                  }
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text("instant location")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add), title: Text('selected locations'))
              ],
            ),
          ),
        )
      ],
    );
  }
}
