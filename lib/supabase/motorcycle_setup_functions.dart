import 'package:flutter_complete_guide/models/setupChange.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../models/vehicle.dart';

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

Stream<List<Vehicle>> getAllVehicles() {
  return supabase.from('vehicle').stream(primaryKey: ['id']).map(
    (maps) => maps.map((item) {
      return Vehicle.fromJson(
        item,
      );
    }).toList(),
  );
}

//for(var item in systems){
//    systemsList.add(System(id: item['id'],name: item['name'], description: item['description'], parts: parts))
//  }
Future<Vehicle> getVehicle(int id) async {
  List<System> systemsList = [];
  List<List<Part>> partsList = [];
  final vehicle = await supabase.from('vehicle').select().eq('id', id).single();
  print('object');
  final systems =
      await supabase.from('system').select().eq('vehicle_id', vehicle['id']);
  print('object');

  final systemIds = [];
  for (var item in systems) {
    systemIds.add(item['id']);
  }

  final parts =
      await supabase.from('part').select().in_('system_id', systemIds);
  final partIds = [];
  for (var item in parts) {
    partIds.add(item['id']);
  }
  final values =
      await supabase.from('part_values').select().in_('part_id', partIds);
  //assign value in current_value_id key temporarily
  for (int i = 0; i < parts.length; i++) {
    for (int j = 0; j < values.length; j++) {
      if (parts[i]['current_value_id'] == values[j]['id']) {
        parts[i]['current_value_id'] = values[j]['value'];
        break;
      }
    }
  }

  for (int i = 0; i < systems.length; i++) {
    partsList.add([]);
    for (int j = 0; j < parts.length; j++) {
      if (systems[i]['id'] == parts[j]['system_id']) {
        partsList[i].add(
          Part(
            name: parts[j]['name'],
            measurementUnit: parts[j]['measurement_unit'],
            value: parts[j]['current_value_id'],
          ),
        );
      }
    }
  }

  for (int i = 0; i < systems.length; i++) {
    systemsList.add(
      System(
        name: systems[i]['name'],
        description: systems[i]['description'],
        parts: partsList[i],
        id: systems[i]['id'],
      ),
    );
  }

  return Vehicle(
    name: vehicle['name'],
    year: vehicle['year'],
    description: vehicle['description'],
    systems: systemsList,
  );
}
