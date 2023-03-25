import 'package:flutter_complete_guide/supabase/motorcycle_setup_functions.dart';

class Part {
  int? id;
  String name;
  String measurementUnit;
  int value;

  Part({
    this.id,
    required this.name,
    required this.measurementUnit,
    required this.value,
  });
}

class System {
  int? id;
  String name;
  String description;
  List<Subsystem> subsystems;

  System({
    this.id,
    required this.name,
    required this.description,
    required this.subsystems,
  });
}

class Subsystem {
  int? id;
  String name;
  String description;
  List<Part> parts;

  Subsystem({
    this.id,
    required this.name,
    required this.description,
    required this.parts,
  });
}

class Vehicle {
  int? id;
  String name;
  String year;
  String description;
  List<System> systems;

  Vehicle({
    this.id,
    required this.name,
    required this.year,
    required this.description,
    required this.systems,
  });
  Vehicle.empty()
      : name = 'name',
        description = 'description',
        year = 'year',
        systems = [];
  void printVehicle() {
    print('Vehicle name:  $name');
    print('Vehicle year:  $year');
    print('Vehicle description:  $description');
    print('Systems:');
    for (int i = 0; i < systems.length; i++) {
      print('System ${i + 1} name:  ${systems[i].name}');
      print('System ${i + 1} description:  ${systems[i].description}');
      print('\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////');
      for (int j = 0; j < systems[i].subsystems.length; j++) {
        print(
            'System ${i + 1} Subsystem ${j + 1} name:  ${systems[i].subsystems[j].name}');
        print(
            'System ${i + 1} Subsystem ${j + 1} description:  ${systems[i].subsystems[j].description}');
        print('----------------------------------------------------');
        for (int k = 0; k < systems[i].subsystems[j].parts.length; k++) {
          print(
              'System ${i + 1} Subsystem ${j + 1} Part ${k + 1} name:  ${systems[i].subsystems[j].parts[k].name}');
          print(
              'System ${i + 1} Subsystem ${j + 1} Part ${k + 1} measurement unit:  ${systems[i].subsystems[j].parts[k].measurementUnit}');
          print(
              'System ${i + 1} Subsystem ${j + 1} Part ${k + 1} value:  ${systems[i].subsystems[j].parts[k].value}');
          print(
              '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
        }
      }
    }
  }

  Vehicle.fromJson(Map json)
      : id = json['id'],
        description = json['description'],
        name = json['name'],
        year = json['year'],
        systems = [];

  //Map<Vehicle, Map<System, List<Part>>> getVehicle({required int id}){
  //return supabase.from('vehicle').select(''' ''');
  //}

  //Map<Vehicle, Map<System, List<Part>>> updateVehicle(
  //    {required Map<Vehicle, Map<System, List<Part>>> vehicle}) {
  //  return;
  //}

  Future<void> uploadVehicle({required Vehicle vehicle}) async {
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
        for (int j = 0;
            j < vehicle.systems[i].subsystems[k].parts.length;
            j++) {
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
  }
}
