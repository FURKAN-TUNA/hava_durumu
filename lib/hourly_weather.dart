import 'package:flutter/material.dart';
import 'package:hava_durumu/const.dart';
import 'package:weather/weather.dart';

class HourlyWeather extends StatelessWidget {
  HourlyWeather({this.clock, this.image, this.temp, this.gif, this.textColor});
  final String clock;
  final String image;
  final String temp;
  final String gif;
  final TextStyle textColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(clock, style: textColor),
        Image(
          image: AssetImage('${gif + image}.gif'),
          width: 75,
        ),
        Text(temp + "°", style: textColor)
      ],
    );
  }

  Widget hourly(List<Weather> w, String gif, TextStyle textColor) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(width: 2), bottom: BorderSide(width: 2))),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HourlyWeather(
                clock: w[0].date.hour.toString(),
                image: w[0].weatherMain,
                temp: w[0].temperature.celsius.round().toString(),
                gif: gif,
                textColor: textColor,
              ),
              HourlyWeather(
                clock: w[1].date.hour.toString(),
                image: w[1].weatherMain,
                temp: w[1].temperature.celsius.round().toString(),
                gif: gif,
                textColor: textColor,
              ),
              HourlyWeather(
                clock: w[2].date.hour.toString(),
                image: w[2].weatherMain,
                temp: w[2].temperature.celsius.round().toString(),
                gif: gif,
                textColor: textColor,
              ),
              HourlyWeather(
                clock: w[3].date.hour.toString(),
                image: w[3].weatherMain,
                temp: w[3].temperature.celsius.round().toString(),
                gif: gif,
                textColor: textColor,
              ),
              HourlyWeather(
                clock: w[5].date.hour.toString(),
                image: w[5].weatherMain,
                temp: w[5].temperature.celsius.round().toString(),
                gif: gif,
                textColor: textColor,
              ),
              HourlyWeather(
                clock: w[6].date.hour.toString(),
                image: w[6].weatherMain,
                temp: w[6].temperature.celsius.round().toString(),
                gif: gif,
                textColor: textColor,
              ),
              HourlyWeather(
                clock: w[7].date.hour.toString(),
                image: w[7].weatherMain,
                temp: w[7].temperature.celsius.round().toString(),
                gif: gif,
                textColor: textColor,
              ),
              HourlyWeather(
                clock: w[8].date.hour.toString(),
                image: w[8].weatherMain,
                temp: w[8].temperature.celsius.round().toString(),
                gif: gif,
                textColor: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
