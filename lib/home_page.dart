import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:weather/weather.dart';
import 'shared_prefs.dart';
import 'package:geolocator/geolocator.dart';
import 'instant_location.dart';

const kGoogleApiKey = "AIzaSyBsJSWotej3zidCHU5Nnpf_BexRidQYdNU";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String key = '247c8340cf1d2b45c5f816a9da633caf';
  int _curIndex = 1;
  List<String> cityListId = [];
  List<Weather> _data = [];
  WeatherFactory ws;
  @override
  void initState() {
    ws = new WeatherFactory(key);
    setState(() {
      cityListId = SharedPrefs.getCities() == null
          ? cityListId = ['ChIJsS1zINVH0xQRjSuEwLBX3As']
          : SharedPrefs.getCities();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Widget> queryForecast(String placeId) async {
    double lat, lon;
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);

    lat = detail.result.geometry.location.lat;
    lon = detail.result.geometry.location.lng;
    Weather w = await ws.currentWeatherByLocation(lat, lon);
    return Text(w.temperature.celsius.round().toString() + "° C");
  }

  Future<Widget> queryCity(String placeId) async {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
    detail.result.hashCode;
    return Text(detail.result.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.search),
        label: Text('Location Search'),
        onPressed: () async {
          Prediction p = await PlacesAutocomplete.show(
            context: context,
            apiKey: kGoogleApiKey,
            mode: Mode.fullscreen, // Mode.fullscreen
          );
          print("p string i :" + p.placeId);
          if (p != null) {
            setState(() {
              cityListId.add(p.placeId);
            });
            SharedPrefs.saveCities(cityListId);
            print(cityListId);
          }
        },
      ),
      appBar: AppBar(
        title: Center(child: Text('WEATHER')),
        automaticallyImplyLeading: false,
      ),
      body: cityListId.length > 1
          ? Container(
              child: ListView.builder(
                  itemCount: cityListId.length - 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: queryCity(cityListId[index + 1]),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('Loading');
                              }
                              return snapshot.data;
                            },
                          ),
                          FutureBuilder(
                            future: queryForecast(cityListId[index + 1]),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('Loading');
                              }
                              return snapshot.data;
                            },
                          )
                        ],
                      ),
                    );
                  }),
            )
          : Center(child: Text('Yer ekleyin!!')),
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

//Todo ["ankara","istanbul"]

//Todo "ankara"
