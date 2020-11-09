import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hava_durumu/const.dart';
import 'package:hava_durumu/five_days.dart';
import 'package:hava_durumu/instant_location.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'home_page.dart';
import 'hourly_weather.dart';

class SelectLocationWidget extends StatefulWidget {
  const SelectLocationWidget(
      {this.cityName, this.w, this.gif, this.weatherList});
  final String cityName;
  final List<Weather> weatherList;
  final Weather w;
  final String gif;
  @override
  _SelectLocationWidgetState createState() => _SelectLocationWidgetState();
}

enum state { enabled, disabled }

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  state _state = state.disabled;
  MainAxisAlignment M = MainAxisAlignment.start;
  double height = 100;
  double width = 150;
  double padding = 0;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      margin: EdgeInsets.only(top: 10, right: 10),
      padding: EdgeInsets.all(5),
      alignment: Alignment.topLeft,
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Color(0xFF111111).withOpacity(0.7),
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          setState(() {
            if (_state == state.disabled) {
              height = 200;
              width = 180;
              padding = 50;
              _state = state.enabled;
            } else {
              height = 100;
              width = 150;
              padding = 0;
              _state = state.disabled;
            }
          });

          print(height.toString());
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.w.temperature.celsius.round().toString() + "°",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Image(
                    image:
                        AssetImage('${widget.gif + widget.w.weatherMain}.gif'),
                    width: 75,
                  ),
                ],
              ),
              AnimatedContainer(
                  duration: Duration(seconds: 1),
                  padding: EdgeInsets.only(left: padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.cityName, style: night),
                      SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ConstrainedBox(
                              constraints: BoxConstraints(),
                              child:
                                  Text(widget.w.weatherMain, style: nightMin))),
                    ],
                  )),
              _state == state.enabled
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(),
                        child: fiveDays(widget.weatherList, widget.gif, night,
                            170, 30, false),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
    // Text(snapshot.data[0].toString(),style: night),
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
                day: DateFormat('EEEE').format(day1[0].date),
                image: day1[0].weatherMain,
                maxTemp: minMax(day1)[1].toString(),
                minTemp: minMax(day1)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day1,
                height: height,
                width: width,
                animated: b,
                iconWidth: 37,
              )
            : Text(' '),
        day2.length != 0
            ? FiveDays(
                day: DateFormat('EEEE').format(day2[0].date),
                image: day2[0].weatherMain,
                maxTemp: minMax(day2)[1].toString(),
                minTemp: minMax(day2)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day2,
                height: height,
                width: width,
                animated: b,
                iconWidth: 37,
              )
            : Text(' '),
        day3.length != 0
            ? FiveDays(
                day: DateFormat('EEEE').format(day3[0].date),
                image: day3[0].weatherMain,
                maxTemp: minMax(day3)[1].toString(),
                minTemp: minMax(day3)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day3,
                height: height,
                width: width,
                animated: b,
                iconWidth: 37,
              )
            : Text(' '),
        day4.length != 0
            ? FiveDays(
                day: DateFormat('EEEE').format(day4[0].date),
                image: day4[0].weatherMain,
                maxTemp: minMax(day4)[1].toString(),
                minTemp: minMax(day4)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day4,
                height: height,
                width: width,
                animated: b,
                iconWidth: 37,
              )
            : Text(' '),
        day5.length != 0
            ? FiveDays(
                day: DateFormat('EEEE').format(day5[0].date),
                image: day5[0].weatherMain,
                maxTemp: minMax(day5)[1].toString(),
                minTemp: minMax(day5)[0].toString(),
                gif: gif,
                textColor: textColor,
                w: day5,
                height: height,
                width: width,
                animated: b,
                iconWidth: 37,
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
