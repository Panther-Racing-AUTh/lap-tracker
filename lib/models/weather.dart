class Weather {
  String? cityName;
  String? cityCountry;
  double? currenttemp;
  double? currentWindSpeed;
  double? maxWind;
  double? currentWindDirection;
  double? mainWindDirection;
  double? currenthumidity;
  double? totalPrecipitation;
  double? temp_max;
  double? temp_min;
  String? description;
  int? code;
  String? sunrise;
  String? sunset;
  List<dynamic>? hourlyTemps;
  List<dynamic>? hourlyWindSpeeds;
  List<dynamic>? hourlyWindDirections;
  List<dynamic>? hourlyHumidity;
  List<dynamic>? hourlyPrecipitation;
  List<dynamic>? hourlyWeatherCodes;
  List<dynamic>? dailyTempsHigh;
  List<dynamic>? dailyTempsLow;
  List<dynamic>? dailyPrecipitation;

  Weather({
    this.cityName,
    this.cityCountry,
    this.currenttemp,
    this.currentWindSpeed,
    this.maxWind,
    this.currentWindDirection,
    this.mainWindDirection,
    this.currenthumidity,
    this.totalPrecipitation,
    this.temp_max,
    this.temp_min,
    this.description,
    this.code,
    this.sunrise,
    this.sunset,
    this.hourlyTemps,
    this.hourlyWindDirections,
    this.hourlyWindSpeeds,
    this.hourlyHumidity,
    this.hourlyWeatherCodes,
    this.dailyPrecipitation,
    this.dailyTempsHigh,
    this.dailyTempsLow,
  });
  //decode json map and put values in variables
  Weather.fromJson(
      Map<String, dynamic> json, String? cityName, String? cityCountry) {
    this.cityName = cityName;
    this.cityCountry = cityCountry;
    currenttemp = json['current_weather']['temperature'];
    code = json['current_weather']['weathercode'];
    if (code == 0) description = 'Clear sky';
    if (code == 1) description = 'Mainly clear';
    if (code == 2) description = 'Partly cloudy';
    if (code == 3) description = 'Overcast';
    if (code == 45) description = 'Fog';
    if (code == 48) description = 'Rime fog';
    if (code == 51) description = 'Light drizzle';
    if (code == 53) description = 'Moderate drizzle';
    if (code == 55) description = 'Dense drizzle';
    if (code == 56) description = 'Light freezing drizzle';
    if (code == 57) description = 'Dense freezing Drizzle';
    if (code == 61) description = 'Slight rain';
    if (code == 63) description = 'Moderate rain';
    if (code == 65) description = 'Heavy rain';
    if (code == 66) description = 'Light freezing rain';
    if (code == 67) description = 'Heavy freezing rain';
    currentWindSpeed = json['current_weather']['windspeed'];
    currentWindDirection = json['current_weather']['winddirection'];
    temp_max = json['daily']['temperature_2m_max'][0];
    temp_min = json['daily']['temperature_2m_min'][0];
    sunrise = json['daily']['sunrise'][1];
    sunset = json['daily']['sunset'][0];
    totalPrecipitation = json['daily']['precipitation_sum'][0];
    maxWind = json['daily']['windspeed_10m_max'][0];
    mainWindDirection = json['daily']['winddirection_10m_dominant'][0];

    dailyTempsHigh = json['daily']['temperature_2m_max'];
    dailyTempsLow = json['daily']['temperature_2m_min'];
    dailyPrecipitation = json['daily']['precipitation_sum'];

    DateTime now = DateTime.now();
    int nowIndex = now.hour;

    currenthumidity = json['hourly']['relativehumidity_2m'][nowIndex];
    hourlyTemps = json['hourly']['temperature_2m'];
    hourlyHumidity = json['hourly']['relativehumidity_2m'];
    hourlyWindSpeeds = json['hourly']['windspeed_10m'];
    hourlyWindDirections = json['hourly']['winddirection_10m'];
    hourlyPrecipitation = json['hourly']['precipitation'];
    hourlyWeatherCodes = json['hourly']['weathercode'];
  }
}
