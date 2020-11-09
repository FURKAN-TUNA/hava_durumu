import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hava_durumu/const.dart';
import 'package:hava_durumu/select_location_widget.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'hourly_weather.dart';

enum state { enabled, disabled }

class FiveDays extends StatefulWidget {
  const FiveDays(
      {this.image,
      this.maxTemp,
      this.day,
      this.minTemp,
      this.gif,
      this.textColor,
      this.w,
      this.height,
      this.width,
      this.animated,
      this.iconWidth});
  final String image;
  final String maxTemp;
  final String minTemp;
  final String day;
  final String gif;
  final List<Weather> w;
  final TextStyle textColor;
  final double height;
  final double width;
  final double iconWidth;
  final bool animated;
  @override
  _FiveDaysState createState() => _FiveDaysState();
}

class _FiveDaysState extends State<FiveDays> {
  state _state = state.disabled;
  final f = new DateFormat.d();

  @override
  Widget build(BuildContext context) {
    double height = widget.height;
    double width = widget.width;
    return GestureDetector(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Text(
                widget.day,
                style: widget.textColor,
              ),
              width: 75,
            ),
            Image(
              image: AssetImage('${widget.gif + widget.image}.gif'),
              width: widget.iconWidth,
            ),
            Row(
              children: [
                Text(widget.maxTemp + "°", style: widget.textColor),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(widget.minTemp + "°",
                      style: widget.textColor == afterNoon
                          ? afterNoonMin
                          : nightMin),
                ),
              ],
            )
          ],
        ),
        _state == state.enabled
            ? height == 175
                ? Container(
                    width: 300,
                    height: 100,
                    child: HourlyWeather()
                        .hourly(widget.w, widget.gif, widget.textColor))
                : Container()
            : Container()
      ],
    ));
  }
}
