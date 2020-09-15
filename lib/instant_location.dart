import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/home_page.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

const kGoogleApiKey = "AIzaSyBsJSWotej3zidCHU5Nnpf_BexRidQYdNU";

class InstantLocation extends StatefulWidget {
  @override
  _InstantLocationState createState() => _InstantLocationState();
}

class _InstantLocationState extends State<InstantLocation> {
  String key = '247c8340cf1d2b45c5f816a9da633caf';
  int _curIndex = 0;
  double lat, lon;
  WeatherFactory ws;
  List<Weather> _data = [];
  final f = new DateFormat.MMMMd();
  @override
  initState() {
    ws = new WeatherFactory(key);

    super.initState();
  }

  Future<void> bul() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);

    lat = position.latitude;
    lon = position.longitude;
    print(lat);
    Weather w = await ws.currentWeatherByLocation(lat, lon);
    return [
      w.temperature.celsius.round().toString() + "° C",
      w.areaName,
      w.weatherMain,
      w.country
    ];
  }

  Future<void> fiveDayForecast() async {
    List<Weather> w = await ws.fiveDayForecastByLocation(lat, lon);
    setState(() {
      _data = w;
    });
    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 203, 4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('EEE').format(DateTime.now()) +
                ", " +
                f.format(DateTime.now())),
            Text('°C')
          ],
        ),
      ),
      body: Column(
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
                    color: Color.fromARGB(255, 251, 203, 4),
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(f.format(DateTime.now())),
                              ]),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data[0],
                                style: TextStyle(fontSize: 40),
                              ),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data[1] + ", ",
                            ),
                            Text(snapshot.data[3]),
                            // Text(snapshot.data[2]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Row(
            children: [
              Text('deneme'),
              Image(
                image: AssetImage('giff/sunny.gif'),
                width: 250,
              )
            ],
          ),
          // Column(
          //   children: [
          //     FutureBuilder(
          //         future: fiveDayForecast(),
          //         builder: (context, snapshot) {
          //           if (!snapshot.hasData) {
          //             return Center(child: Text('Loading'));
          //           }
          //           return Column(
          //             children: [
          //               ListView.builder(
          //                   itemCount: _data.length,
          //                   itemBuilder: (BuildContext context, int index) {
          //                     print(_data[index].date.toString());
          //                     return Container(
          //                         child: Text(_data[index].date.toString()));
          //                   }),
          //             ],
          //           );
          //         }),
          //   ],
          // ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
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
    );
  }
}
