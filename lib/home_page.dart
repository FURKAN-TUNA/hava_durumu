import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:hava_durumu/const.dart';
import 'package:weather/weather.dart';
import 'shared_prefs.dart';
import 'package:geolocator/geolocator.dart';
import 'instant_location.dart';
import 'select_location_widget.dart';
import 'advert_services.dart';

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
  List<String> cityListId = new List<String>();
  List<Weather> _data = [];
  List<String> sol = new List<String>();
  List<String> sag = new List<String>();
  WeatherFactory ws;
  Language language = Language.TURKISH;
  final AdvertService _advertService = AdvertService();
  @override
  void initState() {
    _advertService.showIntersitial();

    setState(() {
      cityListId = SharedPrefs.getCities() == null
          ? cityListId = ['ChIJsS1zINVH0xQRjSuEwLBX3As']
          : SharedPrefs.getCities();
    });
    bol(cityListId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> queryForecast(String placeId) async {
    Locale l = Localizations.localeOf(context);
    l.languageCode == 'tr'
        ? language = Language.TURKISH
        : language = Language.ENGLISH;
    ws = new WeatherFactory(key, language: language);
    double lat, lon;
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
    detail.result.hashCode;
    lat = detail.result.geometry.location.lat;
    lon = detail.result.geometry.location.lng;
    Weather w = await ws.currentWeatherByLocation(lat, lon);
    List<Weather> weatherList = await ws.fiveDayForecastByLocation(lat, lon);
    // print(weatherList[0].areaName);
    // for (var i = 0; i < weatherList.length; i++) {
    //   if (weatherList[i].date.day == DateTime.now().day) {
    //     day.add(weatherList[i]);
    //   }
    // }
    return [detail.result.name, w, weatherList];
  }

  bol(List<String> cityList) {
    for (var i = 1; i < cityList.length; i++) {
      i % 2 == 0 ? sag.add(cityList[i]) : sol.add(cityList[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'images/background.jpg',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Color(0xFF2196F3).withOpacity(0.5),
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
                    sol.clear();
                    sag.clear();
                    bol(cityListId);
                  });
                  SharedPrefs.saveCities(cityListId);
                  print(cityListId);
                }
              },
            ),
            body: ListView.builder(
              itemCount: sol.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: queryForecast(sol[index]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Loading');
                        }
                        return SelectLocationWidget(
                            cityName: snapshot.data[0],
                            gif: 'gifNight/',
                            w: snapshot.data[1],
                            weatherList: snapshot.data[2]);
                      },
                    ),
                    sag.length > index
                        ? FutureBuilder(
                            future: queryForecast(sag[index]),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('Loading');
                              }
                              return SelectLocationWidget(
                                cityName: snapshot.data[0],
                                gif: 'gifNight/',
                                w: snapshot.data[1],
                                weatherList: snapshot.data[2],
                              );
                            },
                          )
                        : Container(
                            height: 100,
                            width: 150,
                            margin: EdgeInsets.only(top: 10, right: 10),
                            padding: EdgeInsets.all(5),
                          ),
                  ],
                );
              },
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
          ),
        )
      ],
    );
  }
}

//Todo ["ankara","istanbul"]

//Todo "ankara"
