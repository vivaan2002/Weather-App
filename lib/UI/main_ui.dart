import 'package:flutter/material.dart';
// import 'package:location/location.dart';
import 'package:weather2/Utill/loc_service.dart';
import 'package:weather2/Utill/weather_service.dart';

final Loc_Service = LocService();
final Weather_Service = WeatherService();
String address = "Location";
String discription = "Description";
double Current_temp = 32;
String icon_url =
    "https://developer.accuweather.com/sites/default/files/01-s.png";
dynamic current_weather;
var day_temp = ["32°/16°", "32°/16°", "32°/16°", "32°/16°", "32°/16°"];
var days = ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5"];
var days_icon_url = [
  "https://developer.accuweather.com/sites/default/files/01-s.png",
  "https://developer.accuweather.com/sites/default/files/01-s.png",
  "https://developer.accuweather.com/sites/default/files/01-s.png",
  "https://developer.accuweather.com/sites/default/files/01-s.png",
  "https://developer.accuweather.com/sites/default/files/01-s.png"
];

Widget future_pred(dayNo) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Text(days[dayNo]),
        // color: Color.fromARGB(255, 0, 204, 255),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Text(day_temp[dayNo]),
        // color: Color.fromARGB(255, 0, 204, 255),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Image.network(days_icon_url[dayNo]),
        // color: Color.fromARGB(255, 0, 204, 255),
      ),
    ],
  );
}

Widget main_display() {
  return Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              Container(
                // height: 100,
                // width: 100,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                alignment: Alignment.centerLeft,
                // ignore: prefer_const_constructors
                child: Text(
                  '${Current_temp.toStringAsFixed(0)}°',
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    fontSize: 68,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // color: Color.fromARGB(255, 255, 0, 0),
              ),
              Container(
                // height: 150,
                width: 100,
                alignment: Alignment.center,
                child: Text(address),
                // color: Color.fromARGB(255, 38, 0, 255),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.network(icon_url),
          )
        ],
      ),
      Container(
        child: Divider(),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(discription),
        // color: Color.fromARGB(255, 0, 204, 255),
      ),
      Container(
        child: Divider(),
      ),
      Container(
        child: Divider(),
      ),
      future_pred(0),
      future_pred(1),
      future_pred(2),
      future_pred(3),
      future_pred(4),
    ],
  );
}

void search() async {
  address = await Loc_Service.Current_add();
  // print(address);
  final loc_key = await Loc_Service.Current_Loc_key();
  // print(loc_key);
  final current_weather = await Weather_Service.Current_weather(loc_key);
  // print(current_weather);

  discription = current_weather["WeatherText"];
  // print(discription);
  Current_temp = (((current_weather["Temperature"])["Metric"])["Value"]);
  print(Current_temp);
  int icon_no = current_weather["WeatherIcon"];
  if (icon_no < 10) {
    icon_url =
        "https://developer.accuweather.com/sites/default/files/0${icon_no}-s.png";
  } else {
    icon_url =
        "https://developer.accuweather.com/sites/default/files/${icon_no}-s.png";
  }

  final future_weather = await Weather_Service.future_weather(loc_key);
  final data_future_weather = future_weather["DailyForecasts"];
  print(data_future_weather[0]);

  for (var i = 0; i < 5; i++) {
    var day_future_weather = data_future_weather[i];
    var min_temp = (((day_future_weather["Temperature"])["Minimum"])["Value"]);
    min_temp = (min_temp - 32) * (0.5555);
    var max_temp = (((day_future_weather["Temperature"])["Maximum"])["Value"]);
    max_temp = (max_temp - 32) * (0.5555);
    day_temp[i] =
        "${max_temp.toStringAsFixed(0)}°/${min_temp.toStringAsFixed(0)}°";
    icon_no = (day_future_weather["Day"])["Icon"];
    if (icon_no < 10) {
      days_icon_url[i] =
          "https://developer.accuweather.com/sites/default/files/0${icon_no}-s.png";
    } else {
      days_icon_url[i] =
          "https://developer.accuweather.com/sites/default/files/${icon_no}-s.png";
    }
  }
}
