import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hava_durumu/const.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

final f = new DateFormat.d();

class FiveDays extends StatelessWidget {
  const FiveDays(
      {this.image,
      this.maxTemp,
      this.day,
      this.minTemp,
      this.gif,
      this.textColor});
  final String image;
  final String maxTemp;
  final String minTemp;
  final String day;
  final String gif;
  final TextStyle textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Text(
            day,
            style: textColor,
          ),
          width: 75,
        ),
        Image(
          image: AssetImage('${gif + image}.gif'),
          width: 100,
        ),
        Row(
          children: [
            Text(maxTemp + "°", style: textColor),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(minTemp + "°",
                  style: textColor == afterNoon ? afterNoonMin : nightMin),
            ),
          ],
        )
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

  Widget fiveDays(List<Weather> w, String gif, TextStyle textColor) {
    List<Weather> day1 = new List<Weather>();
    List<Weather> day2 = new List<Weather>();
    List<Weather> day3 = new List<Weather>();
    List<Weather> day4 = new List<Weather>();
    List<Weather> day5 = new List<Weather>();

    for (var i = 0; i < w.length; i++) {
      if (w[i].date.day == DateTime.now().day + 1) {
        day1.add(w[i]);
      } else if (w[i].date.day == DateTime.now().day + 2) {
        day2.add(w[i]);
      } else if (w[i].date.day == DateTime.now().day + 3) {
        day3.add(w[i]);
      } else if (w[i].date.day == DateTime.now().day + 4) {
        day4.add(w[i]);
      } else if (w[i].date.day == DateTime.now().day + 5) {
        day5.add(w[i]);
      }
    }
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                FiveDays(
                  day: DateFormat('EEEE').format(day1[0].date),
                  image: day1[0].weatherMain,
                  maxTemp: minMax(day1)[1].toString(),
                  minTemp: minMax(day1)[0].toString(),
                  gif: gif,
                  textColor: textColor,
                ),
                FiveDays(
                  day: DateFormat('EEEE').format(day2[0].date),
                  image: day2[0].weatherMain,
                  maxTemp: minMax(day2)[1].toString(),
                  minTemp: minMax(day2)[0].toString(),
                  gif: gif,
                  textColor: textColor,
                ),
                FiveDays(
                  day: DateFormat('EEEE').format(day3[0].date),
                  image: day3[0].weatherMain,
                  maxTemp: minMax(day3)[1].toString(),
                  minTemp: minMax(day3)[0].toString(),
                  gif: gif,
                  textColor: textColor,
                ),
                FiveDays(
                  day: DateFormat('EEEE').format(day4[0].date),
                  image: day4[0].weatherMain,
                  maxTemp: minMax(day4)[1].toString(),
                  minTemp: minMax(day4)[0].toString(),
                  gif: gif,
                  textColor: textColor,
                ),
                day5.length != 0
                    ? FiveDays(
                        day: DateFormat('EEEE').format(day5[0].date),
                        image: day5[0].weatherMain,
                        maxTemp: minMax(day5)[1].toString(),
                        minTemp: minMax(day5)[0].toString(),
                        gif: gif,
                        textColor: textColor,
                      )
                    : Text(' '),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
