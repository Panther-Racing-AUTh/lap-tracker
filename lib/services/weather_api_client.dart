import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherApiClient {
  double? longitude;
  double? latitude;
  Future<Weather>? getCurrentWeather(String? location) async {
    //get coordinates for the desired location
    var coordsEndpoint = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$location&count=1');

    var coordsResponse = await http.get(coordsEndpoint);
    var coordsBody = jsonDecode(coordsResponse.body);
    //extract and store coordinates
    if (coordsBody['results'] != null) {
      latitude = coordsBody['results'][0]['latitude'];

      var locationCountry = coordsBody['results'][0]['country_code'];
      location = coordsBody['results'][0]['name'];
      longitude = coordsBody['results'][0]['longitude'];

      //use the above coords to search again for the weather details
      var weatherEndpoint = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&daily=temperature_2m_max,winddirection_10m_dominant,temperature_2m_min,sunrise,sunset,precipitation_sum,windspeed_10m_max&hourly=temperature_2m,relativehumidity_2m,windspeed_10m,winddirection_10m,weathercode,precipitation&timezone=auto');
      var weatherResponse = await http.get(weatherEndpoint);
      var weatherBody = jsonDecode(weatherResponse.body);
      //send the information for decoding back to class
      return Weather.fromJson(weatherBody, location, locationCountry);
    } else
      return Weather(cityName: 'notACity');
  }
}
