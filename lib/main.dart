import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:location/location.dart';
import 'package:weather2/Utill/loc_service.dart';
import 'package:weather2/Utill/weather_service.dart';
import 'package:weather2/UI/main_ui.dart';
// import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Weather app '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(content: const Text('Refreshed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(child: main_display()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _search(),
          _showToast(context),
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _search() async{
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
    setState(() {});
  }
}
