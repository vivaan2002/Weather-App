import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocService {
  String latlog = "";
  Current_add<String>() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final _locationData = await Geolocator.getCurrentPosition();

    latlog = "${_locationData.latitude},${_locationData.longitude}";
    print(latlog);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        _locationData.latitude, _locationData.longitude);
    Placemark pmark = placemarks[0];

    // this is all you need
    Placemark placeMark = placemarks[0];
    // var name = placeMark.name;
    var subLocality = placeMark.subLocality;
    var locality = placeMark.locality;
    var administrativeArea = placeMark.administrativeArea;
    var postalCode = placeMark.postalCode;
    var country = placeMark.country;
    // var address ="${name},${subLocality}, ${locality}, ${administrativeArea}, ${postalCode}, ${country}";
    var address ="${subLocality}, ${locality}, ${administrativeArea}, ${postalCode}, ${country}";

    // print(address);

    return address;
  }

  Current_Loc_key<String>() async {
    final queryParameters = {
      'apikey': 'drv6ecA9Oulm2jCe3EyoWjTFF47JdvIV',
      'q': latlog,
      'units': 'imperial'
    };

    final uri = Uri.https('dataservice.accuweather.com',
        '/locations/v1/cities/geoposition/search', queryParameters);

    final response = await http.get(uri);

    final json = jsonDecode(response.body);
    final lockey = json["Key"];
    // print(json);
    // print(lockey);
    return lockey;
    // print(json.coord);

    // return WeatherResponse.fromJson(json);
  }

  getWeather() {}
}
