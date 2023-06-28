import 'package:flutter_complete_guide/models/race.dart';

class Event {
  int id;
  DateTime date;
  String description;
  List<Session> sessions = [];

  Event({
    required this.id,
    required this.date,
    required this.description,
    required this.sessions,
  });

  Event.fromJson(Map json, List<Session> sessions)
      : id = json['id'],
        date = DateTime.parse(json['date']),
        description = json['description'],
        sessions = sessions;

  Event.empty()
      : id = 0,
        date = DateTime.now(),
        description = '',
        sessions = [];
}

class Session {
  int id;
  String type;
  RaceTrack raceTrack;
  List<Lap> laps;

  Session({
    required this.id,
    required this.type,
    required this.raceTrack,
    required this.laps,
  });

  Session.fromJson(Map json, List<Lap> laps)
      : id = json['id'],
        type = json['type'],
        raceTrack = RaceTrack.fromJson(json['racetrack']),
        laps = laps;

  Session.empty()
      : id = 0,
        type = '',
        raceTrack = RaceTrack(id: 0, name: '', country: '', countryCode: ''),
        laps = [];
}

class Lap {
  int id;
  String order;

  Lap({required this.id, required this.order});

  Lap.fromJson(Map json)
      : id = json['id'],
        order = json['lap_order'];
}
