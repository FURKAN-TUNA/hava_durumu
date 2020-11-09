import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/advert_services.dart';
import 'package:hava_durumu/home_page.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'five_days.dart';
import 'hourly_weather.dart';
import 'const.dart';

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
  String languageCode;
  Language language = Language.TURKISH;
  final AdvertService _advertService = AdvertService();

  final f = new DateFormat.MMMMd();
  final f2 = new DateFormat.Hm();
  @override
  initState() {
    super.initState();
  }

  Future<void> bul() async {
    languageCode = Localizations.localeOf(context).toLanguageTag();
    Locale l = Localizations.localeOf(context);
    l.languageCode == 'tr'
        ? language = Language.TURKISH
        : language = Language.ENGLISH;
    ws = new WeatherFactory(key, language: language);
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
    if (day.length == 0) {
      day.add(w);
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
      w.temperature.celsius.round() >= minMax(day)[0]
          ? minMax(day)[0].toString()
          : w.temperature.celsius.round().toString(),
      w.temperature.celsius.round() <= minMax(day)[1]
          ? minMax(day)[1].toString()
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    FutureBuilder(
                      future: bul(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          background = 'images/weather.gif';
                          return Container();
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
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_drop_up,
                                                color: Colors.white,
                                              ),
                                              Text(f2.format(snapshot.data[9]),
                                                  style: textColor),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                              ),
                                              Text(f2.format(snapshot.data[10]),
                                                  style: textColor),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            '${gifAsset + snapshot.data[2]}.gif'),
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
                              child: HourlyWeather().hourly(
                                  snapshot.data[7], gifAsset, textColor),
                            ),
                            fiveDays(snapshot.data[7], gifAsset, textColor, 500,
                                75, true),
                          ],
                        );
                      },
                    ),
                  ],
                ),
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

  Widget fiveDays(List<Weather> w, String gif, TextStyle textColor,
      double width, double height, bool b) {
    List<Weather> day1 = new List<Weather>();
    List<Weather> day2 = new List<Weather>();
    List<Weather> day3 = new List<Weather>();
    List<Weather> day4 = new List<Weather>();
    List<Weather> day5 = new List<Weather>();
    for (var i = 0; i < w.length; i++) {
      if (w[i].date.day == DateTime.now().day + 1) {
        day1.add(w[i]);
      } else if (w[i].date.day == DateTime.now().add(Duration(days: 2)).day) {
        day2.add(w[i]);
      } else if (w[i].date.day == DateTime.now().add(Duration(days: 3)).day) {
        day3.add(w[i]);
      } else if (w[i].date.day == DateTime.now().add(Duration(days: 4)).day) {
        day4.add(w[i]);
      } else if (w[i].date.day == DateTime.now().add(Duration(days: 5)).day) {
        day5.add(w[i]);
      }
    }
    return Column(
      children: [
        day1.length != 0
            ? FiveDays(
                day: DateFormat('EEEE', languageCode).format(day1[0].date),
                image: day1[0].weatherMain,
                maxTemp: minMax(day1)[1].toString(),
                minTemp: minMax(day1)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day1,
                height: height,
                width: width,
                animated: b,
                iconWidth: 75,
              )
            : Text(' '),
        day2.length != 0
            ? FiveDays(
                day: DateFormat('EEEE', languageCode).format(day2[0].date),
                image: day2[0].weatherMain,
                maxTemp: minMax(day2)[1].toString(),
                minTemp: minMax(day2)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day2,
                height: height,
                width: width,
                animated: b,
                iconWidth: 75,
              )
            : Text(' '),
        day3.length != 0
            ? FiveDays(
                day: DateFormat('EEEE', languageCode).format(day3[0].date),
                image: day3[0].weatherMain,
                maxTemp: minMax(day3)[1].toString(),
                minTemp: minMax(day3)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day3,
                height: height,
                width: width,
                animated: b,
                iconWidth: 75,
              )
            : Text(' '),
        day4.length != 0
            ? FiveDays(
                day: DateFormat('EEEE', languageCode).format(day4[0].date),
                image: day4[0].weatherMain,
                maxTemp: minMax(day4)[1].toString(),
                minTemp: minMax(day4)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day4,
                height: height,
                width: width,
                animated: b,
                iconWidth: 75,
              )
            : Text(' '),
        day5.length != 0
            ? FiveDays(
                day: DateFormat('EEEE', languageCode).format(day5[0].date),
                image: day5[0].weatherMain,
                maxTemp: minMax(day5)[1].toString(),
                minTemp: minMax(day5)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day5,
                height: height,
                width: width,
                animated: b,
                iconWidth: 75,
              )
            : Text(' '),
      ],
    );
  }

  List<int> minMax(List<Weather> list) {
    int min = list[0].tempMin.celsius.round();
    int max = list[0].tempMax.celsius.round();
    for (int i = 0; i < list.length; i++) {
      list[i].tempMax.celsius.round() > max
          ? max = list[i].tempMax.celsius.round()
          : null;
      list[i].tempMin.celsius.round() < min
          ? min = list[i].tempMax.celsius.round()
          : null;
    }
    return [min, max];
  }
}
