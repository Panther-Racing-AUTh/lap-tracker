class RaceTrack {
  int id;
  String name;
  String country;
  String countryCode;
  RaceTrack({
    required this.id,
    required this.name,
    required this.country,
    required this.countryCode,
  });
  RaceTrack.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        country = json['country'],
        countryCode = json['country_code'];
}

/*
List<Race> races2023 = [
  Race(
    gpName: 'Aragon',
    country: 'es',
  ),
  Race(
    gpName: 'Autodromo Internacional do Algarve',
    country: 'pt',
  ),
  Race(
    gpName: 'Termas de Rio Hondo',
    country: 'ar',
  ),
  Race(
    gpName: 'Circuit Of The Americas',
    country: 'us',
  ),
  Race(
    gpName: 'Circuito de Jerez',
    country: 'es',
  ),
  Race(
    gpName: 'Le Mans',
    country: 'fr',
  ),
  Race(
    gpName: 'Autodromo Internazionale del Mugello',
    country: 'it',
  ),
  Race(
    gpName: 'Sachsenring',
    country: 'de',
  ),
  Race(
    gpName: 'TT Circuit Assen',
    country: 'nl',
  ),
  Race(
    gpName: 'Sokol International Circuit',
    country: 'kz',
  ),
  Race(
    gpName: 'Silverstone Circuit',
    country: 'gb',
  ),
  Race(
    gpName: 'Red Bull Ring',
    country: 'at',
  ),
  Race(
    gpName: 'Circuit de Barcelona-Catalunya',
    country: 'es',
  ),
  Race(
    gpName: 'Misano World Circuit Marco Simoncelli',
    country: 'sm',
  ),
  Race(
    gpName: 'Buddh International Circuit',
    country: 'in',
  ),
  Race(
    gpName: 'Twin Ring Motegi',
    country: 'jp',
  ),
  Race(
    gpName: 'Mandalika International Street Circuit',
    country: 'id',
  ),
  Race(
    gpName: 'Phillip Island',
    country: 'au',
  ),
  Race(
    gpName: 'Chang International Circuit',
    country: 'th',
  ),
  Race(
    gpName: 'Sepang International Circuit',
    country: 'my',
  ),
  Race(
    gpName: 'Lusail International Circuit',
    country: 'qa',
  ),
  Race(
    gpName: 'Circuit Ricardo Tormo',
    country: 'es',
  ),
];
*/