import 'package:flutter_complete_guide/models/race.dart';
import 'package:flutter_complete_guide/models/telemetry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

final supabase = Supabase.instance.client;

Future<dynamic> searchData(
    {required DateTime dateTime, required RaceTrack race}) async {
  List list = [];
  final List data = await supabase
      .from('session')
      .select('''id, session_order, type, event_date!inner ( date )''').eq(
          'racetrack_id', race.id);
  data.forEach(
    (element) {
      if (element['event_date']['date'].toString().contains(
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}'))
        list.add(element);
    },
  );
  return list;
}

Future<List> getLapFromSession(int id) async {
  final List data = await supabase
      .from('lap')
      .select('id, session_id, lap_order')
      .eq('session_id', id);
  return data;
}

Future<dynamic> getDataFromLap(int id) async {
  var d1 = await supabase
      .from('canbus_data')
      .select('*, canbus_data_timeline!inner(*)');
  print(d1[0]);
  List timelines = [];
  final List canbusTimelines =
      await supabase.from('canbus_timeline').select('id').eq('lap_id', id);

  for (int i = 0; i < canbusTimelines.length; i++) {
    timelines.add(canbusTimelines[i]['id']);
  }

  var data = await supabase
      .from('canbus_data')
      .select()
      .in_('canbus_timeline_id', timelines.sublist(149000))
      .onError((error, stackTrace) =>
          print(error!.toString() + stackTrace.toString() + 1.toString()));

  return data;
}

Future<dynamic> getData() async {
  final List<Data> l = [];
  final List data = await supabase
      .from('v_can_data')
      .select()
      .eq('canbus_id_name', 'APPS1_Raw');

  data.forEach((data) {
    DateTime dt = DateTime.parse(data['timestamp']);
    int hour = dt.hour;
    int minute = dt.minute;
    int second = dt.second;
    int millisecond = dt.millisecond;
    String st =
        '$hour:$minute:${second.toString().padLeft(2, '0')}.${millisecond.toString().padLeft(3, '0')}';
    l.add(Data(
        canbusId: data['canbus_id'],
        timestamp: st,
        value: data['value'],
        canbusIdName: '',
        canbusTimelineId: '',
        unit: ''));
  });
  l.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  print(l[0].canbusIdName);
  return l;
}

Future<dynamic> getDataFromList(List list) async {
  List<List<Data>> dataList = [];
  for (int i = 0; i < list.length; i++) {
    dataList.add([]);
    final data = await supabase
        .from('v_can_data')
        .select()
        .eq('canbus_id_name', list[i]);
    data.forEach((data) {
      DateTime dt = DateTime.parse(data['timestamp']);
      int hour = dt.hour;
      int minute = dt.minute;
      int second = dt.second;
      int millisecond = dt.millisecond;
      String st =
          '$hour:$minute:${second.toString().padLeft(2, '0')}.${millisecond.toString().padLeft(3, '0')}';
      dataList[i].add(Data(
          canbusId: data['canbus_id'],
          timestamp: st,
          value: data['value'],
          canbusIdName: '',
          canbusTimelineId: '',
          unit: ''));
    });
  }

  return dataList;
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
