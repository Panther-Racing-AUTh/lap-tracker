class Race {
  String gpName;
  String country;
  String date;

  Race({
    required this.gpName,
    required this.country,
    this.date = '1/1/2023',
  });
}

List<Race> races2023 = [
  Race(
    gpName: 'Gran Premio Animoca Brands de Aragón',
    country: 'es',
  ),
  Race(
    gpName: 'Grande Prémio de Portugal',
    country: 'pt',
  ),
  Race(
    gpName: 'Gran Premio Michelin® de la República Argentina',
    country: 'ar',
  ),
  Race(
    gpName: 'Red Bull Grand Prix of The Americas',
    country: 'us',
  ),
  Race(
    gpName: 'Gran Premio de España',
    country: 'es',
  ),
  Race(
    gpName: 'SHARK Grand Prix de France',
    country: 'fr',
  ),
  Race(
    gpName: 'Gran Premio d’Italia Oakley',
    country: 'it',
  ),
  Race(
    gpName: 'Liqui Moly Motorrad Grand Prix Deutschland',
    country: 'de',
  ),
  Race(
    gpName: 'Motul TT Assen',
    country: 'nl',
  ),
  Race(
    gpName: 'Grand Prix of Kazakhstan',
    country: 'kz',
  ),
  Race(
    gpName: 'Monster Energy British Grand Prix',
    country: 'gb',
  ),
  Race(
    gpName: 'CryptoDATA Motorrad Grand Prix von Österreich',
    country: 'at',
  ),
  Race(
    gpName: 'Gran Premi Monster Energy de Catalunya',
    country: 'es',
  ),
  Race(
    gpName: 'Gran Premio di San Marino e della Riviera di Rimini',
    country: 'it',
  ),
  Race(
    gpName: 'Grand Prix of India',
    country: 'in',
  ),
  Race(
    gpName: 'Motul Grand Prix of Japan',
    country: 'jp',
  ),
  Race(
    gpName: 'Pertamina Grand Prix of Indonesia',
    country: 'id',
  ),
  Race(
    gpName: 'Animoca Brands Australian Motorcycle Grand Prix',
    country: 'au',
  ),
  Race(
    gpName: 'OR Thailand Grand Prix',
    country: 'th',
  ),
  Race(
    gpName: 'PETRONAS Grand Prix of Malaysia',
    country: 'my',
  ),
  Race(
    gpName: 'Grand Prix of Qatar',
    country: 'qa',
  ),
  Race(
    gpName: 'Gran Premio Motul de la Comunitat Valenciana',
    country: 'es',
  ),
];

List<String> raceTrackUrls = [
  'https://photos.motogp.com/2019/track/ara.svg?1568716192?version=1568716192',
  'https://photos.motogp.com/2022/events/circuits/tracks/POR-track.svg',
  'https://photos.motogp.com/2023/track/arg.svg?1673426389?version=1673426389',
  'https://photos.motogp.com/2023/track/ame.svg?1673426389?version=1673426389',
  'https://photos.motogp.com/2022/events/circuits/tracks/JER-track.svg',
  'https://photos.motogp.com/2022/events/circuits/tracks/FRA-track.svg',
  'https://photos.motogp.com/2022/events/circuits/tracks/ITA-track.svg',
];
