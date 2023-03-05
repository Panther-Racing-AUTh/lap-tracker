import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart' as names;
import 'package:flutter_complete_guide/services/weather_api_client.dart';
import '../models/weather.dart';

class WeatherWidget extends StatefulWidget {
  WeatherWidget({bool this.appbar = false, required this.screenWidth});
  final bool appbar;
  double screenWidth;
  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

var cardHeight = 10.0; //height of the widget
var cardWidth = 200.0; //width of the widget
var edgeRadius = 30.0; //radius for the rounded corners look
//all values initally are set to zero or null as information is not yet fetched
var cityName = ''; //name of the location that weather info is fetched for
var cityCountry = '';
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
var dailyHighTemperatures = [];
var dailyLowTemperatures = [];
var dailyPrecipitation = [];

WeatherApiClient client =
    WeatherApiClient(); //api declaration for weather data fetching
Weather data = Weather(); // weather class declaration where data is stored

class _WeatherWidgetState extends State<WeatherWidget> {
  TextEditingController cityNameController = TextEditingController();

  Future<void> getData(String city) async {
    data =
        await client.getCurrentWeather(city)!; //search the weather for a city

    if (data.cityName != 'notACity') {
      //check for invalid city name

      Future.delayed(Duration(seconds: 1), () {});
      //all values are stored locally for depiction on the widget
      setState(() {
        cityName = data.cityName!;
        cityNameController.text =
            cityName; //set controller value to the name of the city
        cityCountry = data.cityCountry!;
        currentTemperature = data.currenttemp!.round();
        currentHumidity = data.currenthumidity!.round();
        currentWindSpeed = data.currentWindSpeed!.round();
        dailyHighTemperature = data.temp_max!.round();
        dailyLowTemperature = data.temp_min!.round();
        dailyMaxWindSpeed = data.maxWind!.round();
        currentWindDirection = data.currentWindDirection!.round();
        mainWindDirection = data.mainWindDirection!.round();
        dailyTotalPrecipitation = data.totalPrecipitation!.round();
        sunrise = data.sunrise!;
        sunset = data.sunset!;

        hourlyTemperatures = data.hourlyTemps!;
        hourlyWindDirections = data.hourlyWindDirections!;
        hourlyWindSpeeds = data.hourlyWindSpeeds!;
        hourlyHumidity = data.hourlyHumidity!;
        hourlyPrecipitation = data.hourlyPrecipitation!;
        hourlyWeatherCodes = data.hourlyWeatherCodes!;
        dailyHighTemperatures = data.dailyTempsHigh!;
        dailyLowTemperatures = data.dailyTempsLow!;
        dailyPrecipitation = data.dailyPrecipitation!;

        //determining which icon to use according to data codes and hour of the day
        if (sunset.contains(
          DateTime.now().day.toString() +
              'T' +
              (DateTime.now().hour - 1).toString(),
        )) {
          weatherIcon = Icons.star_half;
        } else if (data.code == 2 || data.code == 3) {
          weatherIcon = Icons.cloud;
        } else if (data.code == 0 || data.code == 1) {
          if (DateTime.now().hour > DateTime.parse(sunset).hour ||
              DateTime.now().hour < DateTime.parse(sunrise).hour) {
            weatherIcon = Icons.dark_mode;
          } else {
            weatherIcon = Icons.sunny;
          }
        } else if (data.code == 45 || data.code == 48) {
          weatherIcon = Icons.foggy;
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
    } else {
      //show alert dialog if city does not exist
      cityNameController.text = cityName;
      showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: Text(names.not_city),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            )),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    cityName = 'Thessaloniki';
    getData(cityName);
  }

  @override
  void dispose() {
    super.dispose();
    cityNameController.dispose();
  }

  bool expanded = true;
  bool hourly = true;
  @override
  Widget build(BuildContext context) {
    return widget.appbar
        ? Container(
            child: Row(
              children: [
                if (widget.screenWidth > 800)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('D ',
                              style: TextStyle(
                                  color: Theme.of(context).selectedRowColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 40,
                            height: 20,
                            child: Switch(
                                value: hourly,
                                onChanged: (_) => setState(() {
                                      hourly = !hourly;
                                    }),
                                activeColor:
                                    Theme.of(context).selectedRowColor),
                          ),
                          Text(' H',
                              style: TextStyle(
                                  color: Theme.of(context).selectedRowColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      GestureDetector(
                        child: Text(cityName + ' (' + cityCountry + ')',
                            style: TextStyle(
                                color: Theme.of(context).selectedRowColor,
                                fontSize: 20)),
                        onTap: _changeLocation,
                      ),
                    ],
                  ),
                SizedBox(width: 10),
                GestureDetector(
                  child: Container(
                    width: (widget.screenWidth > 800) ? 300 : 100,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: hourly
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.spaceBetween,
                        children: hourly
                            ? _hourlyWeather(appbar: true)
                            : nextThreeDays(),
                      ),
                    ),
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(actions: [
                      WeatherWidget(
                        screenWidth: widget.screenWidth,
                      )
                    ]),
                  ),
                  onDoubleTap: () => _changeLocation(),
                ),
              ],
            ),
          )
        : GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).selectedRowColor,
                ),
              ),
              padding: EdgeInsets.all(10),
              width: cardWidth * 2.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cityName + ' (' + cityCountry + ')',
                              style: TextStyle(
                                color: Theme.of(context).selectedRowColor,
                                fontSize: 27,
                              ),
                            ),
                            Text(
                              '$currentTemperature˚',
                              style: TextStyle(
                                color: Theme.of(context).selectedRowColor,
                                fontSize: 55,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              weatherIcon,
                              color: Theme.of(context).selectedRowColor,
                              size: 30,
                            ),
                            Text(
                              description,
                              style: TextStyle(
                                color: Theme.of(context).selectedRowColor,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'H:$dailyHighTemperature˚ L:$dailyLowTemperature˚',
                              style: TextStyle(
                                color: Theme.of(context).selectedRowColor,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
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
            onTap: (() => setState(
                  () {
                    expanded = !expanded;
                  },
                )), //the widget refreshed when tapped
          );
  }

  //logic for the generation of the hourly weather information for one day ahead according to current time
  List<Widget> _hourlyWeather({bool appbar = false}) {
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
            appbar: appbar,
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
    bool appbar = false,
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
                  color: Theme.of(context).selectedRowColor,
                  fontSize: appbar ? 15 : 23,
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
                color: Theme.of(context).selectedRowColor,
                size: appbar ? 20 : 35,
              ),
              Text(
                '$temperature˚',
                style: TextStyle(
                  color: Theme.of(context).selectedRowColor,
                  fontSize: appbar ? 20 : 23,
                ),
              ),
            ],
          ),
          if (expanded && !appbar)
            Row(
              children: [
                Icon(
                  Icons.water_drop,
                  color: Theme.of(context).selectedRowColor,
                  size: 24,
                ),
                Text(
                  '$precipitation mm',
                  style: TextStyle(
                    color: Theme.of(context).selectedRowColor,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
          if (expanded && !appbar)
            Row(
              children: [
                Icon(
                  Icons.air,
                  color: Theme.of(context).selectedRowColor,
                  size: 24,
                ),
                Text(
                  '$windSpeed km/h',
                  style: TextStyle(
                    color: Theme.of(context).selectedRowColor,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
          if (expanded && !appbar)
            Row(
              children: [
                Icon(
                  Icons.compare_arrows,
                  color: Theme.of(context).selectedRowColor,
                  size: 24,
                ),
                Text(
                  '$windDirection˚',
                  style: TextStyle(
                    color: Theme.of(context).selectedRowColor,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
          Text(
            names.humidity + ': $humidity%',
            style: TextStyle(
              color: Theme.of(context).selectedRowColor,
              fontSize: appbar ? 12 : 18,
            ),
          ),
        ],
      );
  List<Widget> nextThreeDays() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      String day = '';
      switch (DateTime.now().weekday + i) {
        case 1:
          day = 'M';
          break;
        case 2:
          day = 'T';
          break;
        case 3:
          day = 'W';
          break;
        case 4:
          day = 'T';
          break;
        case 5:
          day = 'F';
          break;
        case 6:
          day = 'S';
          break;
        case 7:
          day = 'S';
          break;
        case 8:
          day = 'M';
          break;
        case 9:
          day = 'T';
          break;
      }
      list.add(
        Container(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(day,
                  style: TextStyle(
                      color: Theme.of(context).selectedRowColor, fontSize: 18)),
              SizedBox(height: 1),
              Text(
                'H:' +
                    dailyHighTemperatures[i].round().toString() +
                    '˚' +
                    '  L:' +
                    dailyLowTemperatures[i].round().toString() +
                    '˚',
                style: TextStyle(
                    color: Theme.of(context).selectedRowColor, fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop_rounded,
                      size: 17, color: Theme.of(context).selectedRowColor),
                  SizedBox(width: 3),
                  Text(dailyPrecipitation[i].toString() + 'mm',
                      style: TextStyle(
                          color: Theme.of(context).selectedRowColor,
                          fontSize: 14))
                ],
              )
            ],
          ),
        ),
      );
    }
    return list;
  }

  void _changeLocation() {
    print(widget.screenWidth);
    showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: Text(names.enter_city),
              actions: [
                Column(
                  children: [
                    TextField(
                      controller: cityNameController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () {
                              cityNameController.text = cityName;
                              Navigator.of(ctx).pop();
                            },
                            child: Text(names.cancel)),
                        TextButton(
                          onPressed: () {
                            getData(cityNameController.text);

                            Navigator.of(ctx).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )));
  }
}
