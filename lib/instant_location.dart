import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/home_page.dart';
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
  @override
  initState() {
    ws = new WeatherFactory(key);

    super.initState();
  }

  Future<void> bul() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

    lat = position.latitude;
    lon = position.longitude;
    Weather w = await ws.currentWeatherByLocation(lat, lon);
    return Text(w.temperature.celsius.round().toString() + "° C");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: bul(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print(lat);
            return Text('Loading');
          }
          return snapshot.data;
        },
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstantLocation()));
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
