import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/weather_api_client.dart';
import '../models/weather.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

var cardHeight = 300.0; //height of the widget
var cardWidth = 300.0; //width of the widget
var edgeRadius = 30.0; //radius for the rounded corners look
//all values initally are set to zero or null as information is not yet fetched
var cityName = ''; //name of the location that weather info is fetched for
var currentHumidity = 0; //current humidity in %
var currentTemperature = 0; //current temperature in celsius
var currentWindSpeed = 0; //current wind speed in km/h
var dailyHighTemperature = 0; //maximum temperature for the day in celsius
var dailyLowTemperature = 0; //minimum temperature for the day in celsius
var dailyMaxWindSpeed = 0; //maximum wind speed for the day in km/h
var currentWindDirection =
    0; //current wind direction in degrees starting from north = 0˚
var mainWindDirection = 0; //main wind direction for the day measured in degrees
var dailyTotalPrecipitation =
    0; //total precipitation for the day measured in mm
var description =
    ''; //description for the weather according to the data.code variable
var sunrise =
    ''; //time for the sunrise of the next day, is a string in iso8601 format
var sunset =
    ''; //time for the sunset of the next day, is a string in iso8601 format
var weatherIcon = Icons.stop; //icon for the weather

var hourlyTemperatures = []; //list of the hourly temperatures for the day
var hourlyWindSpeeds = []; //list of the hourly wind speeds of the day
var hourlyWindDirections = []; //list of hourly wind directions of the day
var hourlyHumidity = []; //list of hourly humidity percentage of the day
var hourlyPrecipitation =
    []; //list of the hourly mm of precipitation of the day
var hourlyWeatherCodes = []; //list of the hourly weather codes

//list for the colors of the widget according to weather
List<List<Color>> weatherGradients = [
  [
    //normal colors for weather widget
    Color.fromARGB(255, 10, 66, 94),
    Color.fromARGB(255, 123, 187, 238),
  ],
  [
    //colors for cloudy weather
    Color.fromARGB(255, 47, 47, 48),
    Color.fromARGB(255, 124, 128, 131),
  ],
  [
    //colors for night
    Color.fromARGB(255, 6, 16, 98),
    Color.fromARGB(255, 86, 73, 35),
  ],
  [
    //colors for sunset
    Color.fromARGB(255, 32, 44, 96),
    Color.fromARGB(255, 118, 93, 19),
  ],
  [
    //colors for night
    Color.fromARGB(255, 4, 26, 67),
    Color.fromARGB(255, 46, 88, 136),
  ]
];
var weatherColorIndex =
    0; // index to point to specific color for the widget in the above list

WeatherApiClient client =
    WeatherApiClient(); //api declaration for weather data fetching
Weather data = Weather(); // weather class declaration where data is stored

class _WeatherWidgetState extends State<WeatherWidget> {
  Future<void> getData() async {
    data = await client
        .getCurrentWeather('Thessaloniki')!; //search the weather for a city
    Future.delayed(Duration(seconds: 1), () {});
    //all values are checked for null and are stored locally for depiction on the widget
    setState(() {
      cityName = (data.currenttemp == null) ? '' : data.cityName!;
      currentTemperature =
          (data.currenttemp == null) ? 0 : data.currenttemp!.round();
      currentHumidity =
          (data.currenthumidity == null) ? 0 : data.currenthumidity!.round();
      currentWindSpeed =
          (data.currentWindSpeed == null) ? 0 : data.currentWindSpeed!.round();
      dailyHighTemperature =
          (data.temp_max == null) ? 0 : data.temp_max!.round();
      dailyLowTemperature =
          (data.temp_min == null) ? 0 : data.temp_min!.round();
      dailyMaxWindSpeed = (data.maxWind == null) ? 0 : data.maxWind!.round();

      currentWindDirection = (data.currentWindDirection == null)
          ? 0
          : data.currentWindDirection!.round();
      mainWindDirection = (data.mainWindDirection == null)
          ? 0
          : data.mainWindDirection!.round();
      dailyTotalPrecipitation = (data.totalPrecipitation == null)
          ? 0
          : data.totalPrecipitation!.round();
      description = (data.description == null) ? '' : data.description!;
      sunrise = (data.sunrise == null) ? '' : data.sunrise!;
      sunset = (data.sunset == null) ? '' : data.sunset!;

      hourlyTemperatures = (data.hourlyTemps == null) ? [] : data.hourlyTemps!;
      hourlyWindDirections =
          (data.hourlyWindDirections == null) ? [] : data.hourlyWindDirections!;
      hourlyWindSpeeds =
          (data.hourlyWindSpeeds == null) ? [] : data.hourlyWindSpeeds!;
      hourlyHumidity =
          (data.hourlyHumidity == null) ? [] : data.hourlyHumidity!;
      hourlyPrecipitation =
          (data.hourlyPrecipitation == null) ? [] : data.hourlyPrecipitation!;
      hourlyWeatherCodes =
          (data.hourlyWeatherCodes == null) ? [] : data.hourlyWeatherCodes!;
      //determining which color and icon to use according to data codes and hour of the day
      if (sunset.contains(
        DateTime.now().day.toString() +
            'T' +
            (DateTime.now().hour - 1).toString(),
      )) {
        weatherIcon = Icons.star_half;
        weatherColorIndex = 3;
      } else if (data.code == 2 || data.code == 3) {
        weatherIcon = Icons.cloud;
        weatherColorIndex = 1;
      } else if (data.code == 0 || data.code == 1) {
        if (DateTime.now().hour > DateTime.parse(sunset).hour ||
            DateTime.now().hour < DateTime.parse(sunrise).hour) {
          weatherIcon = Icons.dark_mode;
          weatherColorIndex = 4;
        } else {
          weatherIcon = Icons.sunny;
          weatherColorIndex = 0;
        }
      } else if (data.code == 45 || data.code == 48) {
        weatherIcon = Icons.foggy;
        weatherColorIndex = 1;
      } else if (data.code == 51 ||
          data.code == 53 ||
          data.code == 55 ||
          data.code == 61 ||
          data.code == 63 ||
          data.code == 65) {
        weatherIcon = Icons.water_drop_sharp;
      } else if (data.code == 56 ||
          data.code == 57 ||
          data.code == 66 ||
          data.code == 67) {
        weatherIcon = Icons.snowing;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: (MediaQuery.of(context).size.width <
              1300) //check for screen size and show compact or detailed version of weather widget
          ? Container(
              padding: EdgeInsets.all(20),
              height: cardHeight,
              width: cardWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: weatherGradients[weatherColorIndex],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(edgeRadius),
                  topRight: Radius.circular(edgeRadius),
                  bottomLeft: Radius.circular(edgeRadius),
                  bottomRight: Radius.circular(edgeRadius),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      cityName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    //color: Colors.yellow,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$currentTemperature˚',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: cardWidth * 0.2,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.air,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' $currentWindSpeed km/h',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.compare_arrows,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' $currentWindDirection ˚',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Humidity: $currentHumidity%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: cardHeight * 0.15,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.air,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '$dailyMaxWindSpeed km/h',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth * 0.2,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.compare_arrows,
                              color: Colors.white,
                            ),
                            Text(
                              '$mainWindDirection˚',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '$dailyTotalPrecipitation mm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    child: Text(
                      '$description \nH:$dailyHighTemperature˚ L:$dailyLowTemperature˚',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            )
          //show detailed version
          : Container(
              padding: EdgeInsets.all(20),
              height: cardHeight * 1.2,
              width: cardWidth * 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: weatherGradients[weatherColorIndex],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(edgeRadius),
                  topRight: Radius.circular(edgeRadius),
                  bottomLeft: Radius.circular(edgeRadius),
                  bottomRight: Radius.circular(edgeRadius),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cityName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                              ),
                            ),
                            Text(
                              '$currentTemperature˚',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 55,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: cardWidth * 1.4,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              weatherIcon,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'H:$dailyHighTemperature˚ L:$dailyLowTemperature˚',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                            _hourlyWeather(), //generate dynamically the list of hourly weather details in another function
                      ),
                    ),
                  )
                ],
              ),
            ),
      onTap: (() => setState(() {})), //the widget refreshed when tapped
    );
  }

  //logic for the generation of the hourly weather information for one day ahead according to current time
  List<Widget> _hourlyWeather() {
    List<Widget> list = [];
    if (hourlyTemperatures.isEmpty) return list;
    DateTime now = DateTime.now();
    int nowIndex = now.hour;

    for (int i = 0; i <= 47; i++) {
      if ((i % 2).toInt() != 0) {
        list.add(
          SizedBox(
            width: 30,
          ),
        );
      } else
        list.add(
          weatherColumn(
            hour: (i == 0)
                ? 'Now'
                : ((i ~/ 2) + nowIndex > 23)
                    ? ((i ~/ 2) + nowIndex - 24).toString()
                    : ((i ~/ 2) + nowIndex).toString(),
            icon: getIconForWeatherCode(
                hourlyWeatherCodes[(i ~/ 2) + nowIndex], (i ~/ 2)),
            temperature: hourlyTemperatures[(i ~/ 2) + nowIndex].round(),
            windSpeed: hourlyWindSpeeds[(i ~/ 2) + nowIndex].round(),
            windDirection: hourlyWindDirections[(i ~/ 2) + nowIndex].round(),
            humidity: hourlyHumidity[(i ~/ 2) + nowIndex].round(),
            precipitation: hourlyPrecipitation[(i ~/ 2) + nowIndex].round(),
          ),
        );
    }
    return list;
  }

  IconData getIconForWeatherCode(int code, int index) {
    if (code == 2 || code == 3)
      return Icons.cloud;
    else if (code == 0 || code == 1) {
      if (DateTime.now().add(Duration(hours: index)).hour >
              DateTime.parse(sunset).hour ||
          DateTime.now().add(Duration(hours: index)).hour <
              DateTime.parse(sunrise).hour) {
        return Icons.dark_mode;
      } else {
        return Icons.sunny;
      }
    } else if (code == 45 || code == 48) {
      return Icons.foggy;
    } else if (data.code == 51 ||
        data.code == 53 ||
        data.code == 55 ||
        data.code == 61 ||
        data.code == 63 ||
        data.code == 65) {
      return Icons.water_drop_sharp;
    } else if (data.code == 56 ||
        data.code == 57 ||
        data.code == 66 ||
        data.code == 67) {
      return Icons.snowing;
    }
    return Icons.stop;
  }

  //ui of one column where weather details are displayed per hour
  Widget weatherColumn({
    required String hour,
    required IconData icon,
    required dynamic temperature,
    dynamic windSpeed = 0,
    dynamic windDirection = 0,
    dynamic precipitation = 0,
    dynamic humidity = 0,
  }) =>
      Column(
        children: [
          Row(
            children: [
              Text(
                hour.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ],
          ),
          SizedBox(
            height: cardHeight * 0.02,
          ),
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 35,
              ),
              Text(
                '$temperature˚',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.water_drop,
                color: Colors.white,
                size: 24,
              ),
              Text(
                '$precipitation mm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.air,
                color: Colors.white,
                size: 24,
              ),
              Text(
                '$windSpeed km/h',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.compare_arrows,
                color: Colors.white,
                size: 24,
              ),
              Text(
                '$windDirection˚',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ],
          ),
          Text(
            'Humidity: $humidity%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: cardHeight * 0.02,
          ),
        ],
      );
}
