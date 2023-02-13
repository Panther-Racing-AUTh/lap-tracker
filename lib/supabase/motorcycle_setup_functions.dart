import 'package:flutter_complete_guide/models/setupChange.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<dynamic> getCurrentSetup() async {
  final data = await supabase
      .from('motorcycle_setup')
      .select(
        'ECU, rear_suspension, brakes, front_suspension',
      )
      .single();

  return data;
}

Future<void> saveChanges(Map newData) async {
  final oldData = await getCurrentSetup();
  String newList = '', oldList = '', changes = '';

  for (int i = 0; i < oldData.length; i++) {
    if (oldData.values.toList()[i] != newData.values.toList()[i]) {
      if (newList.isEmpty) {
        newList = newData.values.toList()[i].toString();
        oldList = oldData.values.toList()[i].toString();
        changes = newData.keys.toList()[i].toString();
      } else {
        newList = newList + ',' + newData.values.toList()[i].toString();
        oldList = oldList + ',' + oldData.values.toList()[i].toString();
        changes = changes + ',' + newData.keys.toList()[i].toString();
      }
    }
  }
  print(newList);
  print(oldList);
  await supabase.from('setup_changes').insert({
    'previous_settings': oldList,
    'changed_settings': newList,
    'userId': (supabase.auth.currentUser == null)
        ? ''
        : supabase.auth.currentUser!.id.toString() +
            supabase.auth.currentUser!.email.toString(),
    'created_at': DateTime.now().toString(),
    'changes': changes,
  });
  await supabase.from('motorcycle_setup').update(newData).match({'id': 1});
}

Stream<List<SetupChange>> getSetupChanges() {
  return supabase
      .from('setup_changes')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .map(
        (maps) => maps.map((item) {
          return SetupChange.fromJson(item);
        }).toList(),
      );
}
