import 'package:flutter_complete_guide/models/race.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<dynamic> searchData(
    {required DateTime dateTime, required RaceTrack race}) async {
  List list = [];
  final List data = await supabase
      .from('session')
      .select('''id, session_order, type, event_date!inner ( date )''').eq(
          'racetrack_id', race.id);
  print(data);
  data.forEach(
    (element) {
      print(element['event_date']['date'].runtimeType);
      print(
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}T');
      if (element['event_date']['date'].toString().contains(
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}T')) {
        list.add(element);

        if (DateTime.parse(element['event_date']['date']).year ==
                dateTime.year &&
            DateTime.parse(element['event_date']['date']).month.toString() ==
                dateTime.month.toString().padLeft(2, '0') &&
            DateTime.parse(element['event_date']['date']).day.toString() ==
                dateTime.day.toString().padLeft(2, '0')) list.add(element);
      }
      ;
    },
  );
}

Future<List<RaceTrack>> getRaceTracks() async {
  List<RaceTrack> list = [];
  final List data = await supabase
      .from('racetrack')
      .select('id, name, country, country_code');

  data.forEach(
    (element) {
      list.add(
        RaceTrack(
          id: element['id'],
          name: element['name'],
          country: element['country'],
          countryCode: element['country_code'],
        ),
      );
    },
  );

  return list;
}
