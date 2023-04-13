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
  Map<int, List<Subsystem>> subsystemsList = {};
  Map<int, List<Part>> partsList = {};
  final vehicle = await supabase.from('vehicle').select().eq('id', id).single();

  final systems =
      await supabase.from('system').select().eq('vehicle_id', vehicle['id']);

  final systemIds = [];
  for (var item in systems) {
    systemIds.add(item['id']);
  }

  final subsystems =
      await supabase.from('subsystem').select().in_('system_id', systemIds);
  final subsystemIds = [];

  for (var item in subsystems) {
    subsystemIds.add(item['id']);
  }

  final parts =
      await supabase.from('part').select().in_('subsystem_id', subsystemIds);
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

  for (int i = 0; i < parts.length; i++) {
    if (partsList.containsKey(parts[i]['subsystem_id'])) {
      partsList[parts[i]['subsystem_id']]!.add(
        Part(
          id: parts[i]['id'],
          name: parts[i]['name'],
          measurementUnit: parts[i]['measurement_unit'],
          value: parts[i]['current_value_id'],
        ),
      );
    } else
      partsList[parts[i]['subsystem_id']] = [
        Part(
          id: parts[i]['id'],
          name: parts[i]['name'],
          measurementUnit: parts[i]['measurement_unit'],
          value: parts[i]['current_value_id'],
        ),
      ];
  }

  for (int i = 0; i < subsystems.length; i++) {
    if (subsystemsList.containsKey(subsystems[i]['system_id'])) {
      subsystemsList[subsystems[i]['system_id']]!.add(
        Subsystem(
          id: subsystems[i]['id'],
          name: subsystems[i]['name'],
          description: subsystems[i]['description'],
          parts: partsList[subsystems[i]['id']]!,
        ),
      );
    } else
      subsystemsList[subsystems[i]['system_id']] = [
        Subsystem(
          id: subsystems[i]['id'],
          name: subsystems[i]['name'],
          description: subsystems[i]['description'],
          parts: partsList[subsystems[i]['id']]!,
        ),
      ];
  }

  for (int i = 0; i < systems.length; i++) {
    systemsList.add(
      System(
        id: systems[i]['id'],
        name: systems[i]['name'],
        description: systems[i]['description'],
        subsystems: subsystemsList[systems[i]['id']]!,
      ),
    );
  }

  return Vehicle(
    id: vehicle['id'],
    name: vehicle['name'],
    year: vehicle['year'],
    description: vehicle['description'],
    systems: systemsList,
  );
}

Future<bool> uploadVehicle({required Vehicle vehicle}) async {
  var vehicleResponse = await supabase
      .from('vehicle')
      .insert({
        'name': vehicle.name,
        'year': vehicle.year,
        'description': vehicle.description,
      })
      .select('id')
      .order('created_at', ascending: false)
      .single();
  var vehicleId = vehicleResponse['id'];
  for (int i = 0; i < vehicle.systems.length; i++) {
    var systemResponse = await supabase
        .from('system')
        .insert({
          'name': vehicle.systems[i].name,
          'description': vehicle.systems[i].description,
          'vehicle_id': vehicleId,
        })
        .select('id')
        .order('created_at', ascending: false)
        .single();
    var systemId = systemResponse['id'];
    for (int k = 0; k < vehicle.systems[i].subsystems.length; k++) {
      var subsystemResponse = await supabase
          .from('subsystem')
          .insert({
            'name': vehicle.systems[i].subsystems[k].name,
            'description': vehicle.systems[i].subsystems[k].description,
            'system_id': systemId,
          })
          .select('id')
          .order('created_at', ascending: false)
          .single();
      var subsystemId = subsystemResponse['id'];
      for (int j = 0; j < vehicle.systems[i].subsystems[k].parts.length; j++) {
        var partResponse = await supabase
            .from('part')
            .insert({
              'name': vehicle.systems[i].subsystems[k].parts[j].name,
              'measurement_unit':
                  vehicle.systems[i].subsystems[k].parts[j].measurementUnit,
              'subsystem_id': subsystemId,
            })
            .select('id')
            .order('created_at', ascending: false)
            .single();
        var partId = partResponse['id'];
        var partValueResponse = await supabase
            .from('part_values')
            .insert({
              'value': vehicle.systems[i].subsystems[k].parts[j].value,
              'part_id': partId,
            })
            .select('id')
            .order('created_at', ascending: false)
            .single();
        var partValueId = partValueResponse['id'];
        await supabase
            .from('part')
            .update({'current_value_id': partValueId}).eq('id', partId);
        ;
      }
    }
  }
  return true;
}

Future<bool> updateVehicleinDb({required Vehicle vehicle}) async {
  print('vehicle id:  ' + vehicle.id.toString());
  vehicle.printVehicle();
  await supabase.from('vehicle').update({
    'name': vehicle.name,
    'description': vehicle.description,
    'year': vehicle.year
  }).eq('id', vehicle.id);
  for (int i = 0; i < vehicle.systems.length; i++) {
    var system = vehicle.systems[i];
    var systemResponse = (system.id == null)
        ? await supabase
            .from('system')
            .insert({
              'name': system.name,
              'description': system.description,
              'vehicle_id': vehicle.id
            })
            .select('id')
            .order('created_at', ascending: false)
            .single()
        : await supabase
            .from('system')
            .update({
              'name': system.name,
              'description': system.description,
              'vehicle_id': vehicle.id
            })
            .eq('id', system.id)
            .select('id')
            .single();
    var systemId = systemResponse['id'];
    for (int j = 0; j < vehicle.systems[i].subsystems.length; j++) {
      var subsystem = vehicle.systems[i].subsystems[j];

      var subsystemResponse = (subsystem.id == null)
          ? await supabase
              .from('subsystem')
              .insert({
                'name': subsystem.name,
                'description': subsystem.description,
                'system_id': systemId
              })
              .select('id')
              .order('created_at', ascending: false)
              .single()
          : await supabase
              .from('subsystem')
              .update({
                'name': subsystem.name,
                'description': subsystem.description,
                'system_id': systemId
              })
              .eq('id', subsystem.id)
              .select('id')
              .single();
      var subsystemId = subsystemResponse['id'];
      for (int k = 0; k < vehicle.systems[i].subsystems[j].parts.length; k++) {
        var part = vehicle.systems[i].subsystems[j].parts[k];

        var partResponse = (part.id == null)
            ? await supabase
                .from('part')
                .insert({
                  'name': part.name,
                  'measurement_unit': part.measurementUnit,
                  'subsystem_id': subsystemId
                })
                .select('id')
                .order('created_at', ascending: false)
                .single()
            : await supabase
                .from('part')
                .update({
                  'name': part.name,
                  'measurement_unit': part.measurementUnit,
                  'subsystem_id': subsystemId
                })
                .eq('id', part.id)
                .select('id')
                .single();

        var partId = partResponse['id'];
        var partValueResponse = (part.id == null)
            ? await supabase
                .from('part_values')
                .insert({
                  'value': part.value,
                  'part_id': partId,
                })
                .select('id')
                .order('created_at', ascending: false)
                .single()
            : await supabase
                .from('part_values')
                .update({
                  'value': part.value,
                  'part_id': partId,
                })
                .eq('part_id', part.id)
                .select('id')
                .single();

        var partValueId = partValueResponse['id'];
        await supabase
            .from('part')
            .update({'current_value_id': partValueId}).eq('id', partId);
      }
    }
  }
  var newVehicle = await getVehicle(vehicle.id!);
  List<int> partIds = [];
  List<int> subsystemIds = [];
  List<int> systemIds = [];

  List<int> partIdsToDelete = [];
  List<int> subsystemIdsToDelete = [];
  List<int> systemIdsToDelete = [];

  for (int i = 0; i < vehicle.systems.length; i++) {
    systemIds.add(vehicle.systems[i].id!);
    for (int j = 0; j < vehicle.systems[i].subsystems.length; j++) {
      subsystemIds.add(vehicle.systems[i].subsystems[j].id!);
      for (int k = 0; k < vehicle.systems[i].subsystems[j].parts.length; k++) {
        partIds.add(vehicle.systems[i].subsystems[j].parts[k].id!);
      }
    }
  }

  for (int i = 0; i < newVehicle.systems.length; i++) {
    var systemFromNewVehicle = newVehicle.systems[i];
    if (!systemIds.contains(systemFromNewVehicle.id)) {
      systemIdsToDelete.add(systemFromNewVehicle.id!);
    }
    for (int j = 0; j < newVehicle.systems[i].subsystems.length; j++) {
      var subsystemFromNewVehicle = newVehicle.systems[i].subsystems[j];
      if (!subsystemIds.contains(subsystemFromNewVehicle.id)) {
        subsystemIdsToDelete.add(subsystemFromNewVehicle.id!);
      }
      for (int k = 0;
          k < newVehicle.systems[i].subsystems[j].parts.length;
          k++) {
        var partFromNewVehicle = newVehicle.systems[i].subsystems[j].parts[k];

        if (!partIds.contains(partFromNewVehicle.id)) {
          partIdsToDelete.add(partFromNewVehicle.id!);
        }
      }
    }
  }
  print(subsystemIds);
  print(subsystemIdsToDelete);
  await deletePartsFromList(partIdsToDelete);
  await deleteSubsystemsFromList(subsystemIdsToDelete);
  await deleteSystemsFromList(systemIdsToDelete);
  print(partIds);
  print(partIdsToDelete);
  print('success');
  return true;
}

Future deletePartsFromList(List<int> partIdsToDelete) async {
  await supabase.from('part_values').delete().in_('part_id', partIdsToDelete);
  await supabase.from('part').delete().in_('id', partIdsToDelete);
}

Future deleteSubsystemsFromList(List<int> subsystemIdsToDelete) async {
  await supabase.from('subsystem').delete().in_('id', subsystemIdsToDelete);
}

Future deleteSystemsFromList(List<int> systemIdsToDelete) async {
  await supabase.from('system').delete().in_('id', systemIdsToDelete);
}
