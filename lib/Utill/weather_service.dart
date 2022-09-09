import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Current_weather(Loc_Key) async {
    final queryParameters = {
      'apikey': 'drv6ecA9Oulm2jCe3EyoWjTFF47JdvIV',
      // 'q': Loc_Key,
      // 'units': 'imperial'
    };

    final uri = Uri.https('dataservice.accuweather.com',
        '/currentconditions/v1/${Loc_Key}', queryParameters);

    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    // print(json2);
    final json2 = json[0];
    return json2;
  }

  future_weather(Loc_Key) async {
    final queryParameters = {
      'apikey': 'drv6ecA9Oulm2jCe3EyoWjTFF47JdvIV',
    };

    final uri = Uri.https('dataservice.accuweather.com',
        '/forecasts/v1/daily/5day/${Loc_Key}', queryParameters);

    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    // print(json);
    // final json2 = json[0];
    return json;
  }
}
