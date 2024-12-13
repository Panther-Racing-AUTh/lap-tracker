import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:provider/provider.dart';

import '../models/vehicle.dart';

class VehicleSelector extends StatefulWidget {
  const VehicleSelector({Key? key}) : super(key: key);

  @override
  State<VehicleSelector> createState() => _VehicleSelectorState();
}

class _VehicleSelectorState extends State<VehicleSelector> {
  int index = 0;

  @override
  void initState() {
    AppSetup setup = Provider.of<AppSetup>(context, listen: false);
    index = setup.raceSelectorIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    AppSetup setup = Provider.of<AppSetup>(context);
    List<Vehicle> vehicles = setup.vehicles;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PopupMenuButton<Vehicle>(
          child: Row(
            children: [
              Text(vehicles[setup.vehicleSelectorIndex].name),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          itemBuilder: (ctx) {
            return vehicles.map((Vehicle r) {
              return PopupMenuItem(
                value: r,
                child: Text(r.name),
              );
            }).toList();
          },
          onSelected: (Vehicle? value) {
            setState(
              () {
                index = vehicles
                    .indexWhere((element) => element.name == value!.name);
                setup.vehicleSelectorIndex = index;
                setup.proposalVehicle = setup.vehicles[index];
              },
            );
            print('current index is ' + index.toString());
          },
        ),
      ],
    );
  }
}
