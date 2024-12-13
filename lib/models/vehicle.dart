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

  Part.fromJson(Map json)
      : id = json['id'] ?? 0,
        name = json['name'],
        measurementUnit = json['measurement_unit'],
        value = json['part_values'][0]['value'];
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

  System.fromJson(Map json, List<Subsystem> subsystemss)
      : id = json['id'] ?? 0,
        name = json['name'],
        description = json['description'],
        subsystems = subsystemss;
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

  Subsystem.fromJson(Map json, List<Part> partss)
      : id = json['id'] ?? 0,
        name = json['name'],
        description = json['description'],
        parts = partss;
}

class Vehicle {
  int? id;
  String name = 'name';
  String year = 'year';
  String description = 'description';
  List<System> systems = [];

  Vehicle({
    this.id,
    required this.name,
    required this.year,
    required this.description,
    required this.systems,
  });

  Vehicle.fromJsonHasura(Map json) {
    name = json['name'] ?? 'adsfasdf';
    id = json['id'] ?? 0;
    year = json['year'] ?? 'name';
    description = json['description'] ?? 'name';
    print('\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\');
    print(json['name']);
    print(json['id']);
    print(json['year']);
    print(json['description']);

    List<System> s = [];

    print(json);

    for (int i = 0; i < json['systems'].length; i++) {
      s.add(
        System(
          subsystems: [],
          name: json['systems'][i]['name'],
          description: json['systems'][i]['description'],
          id: json['systems'][i]['id'] ?? 0,
        ),
      );

      for (int j = 0; j < json['systems'][i]['subsystems'].length; j++) {
        s[i].subsystems.add(
              Subsystem(
                name: json['systems'][i]['subsystems'][j]['name'],
                description: json['systems'][i]['subsystems'][j]['description'],
                parts: [],
              ),
            );

        for (int k = 0;
            k < json['systems'][i]['subsystems'][j]['parts'].length;
            k++) {
          s[i].subsystems[j].parts.add(
                Part(
                  id: json['systems'][i]['subsystems'][j]['parts'][k]['id'],
                  name: json['systems'][i]['subsystems'][j]['parts'][k]['name'],
                  measurementUnit: json['systems'][i]['subsystems'][j]['parts']
                      [k]['measurement_unit'],
                  value: 0,
                ),
              );

          for (int l = 0;
              l <
                  json['systems'][i]['subsystems'][j]['parts'][k]['part_values']
                      .length;
              l++) {
            s[i].subsystems[j].parts[k].value = json['systems'][i]['subsystems']
                [j]['parts'][k]['part_values'][l]['value'];
          }
          ;
        }
        ;
      }
      ;
    }
    systems = s;
  }

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
              'System ${i + 1} Subsystem ${j + 1} Part ${k + 1} id:  ${systems[i].subsystems[j].parts[k].id}');
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
