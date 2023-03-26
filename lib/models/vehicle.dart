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

}
