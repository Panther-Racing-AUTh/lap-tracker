import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/create_new_vehicle_screen.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/vehicle_setup_screen.dart';

import '../../models/vehicle.dart';
import '../../supabase/motorcycle_setup_functions.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

//controls which page is shown
//0: select vehicle screen
//1: create new vehicle screen
//2: view vehicle screen
int _index = 0;
int vehicleId = -1;
Vehicle v = Vehicle.empty();

class _VehicleScreenState extends State<VehicleScreen>
    with AutomaticKeepAliveClientMixin<VehicleScreen> {
  @override
  bool get wantKeepAlive => true;
//called to get back to this page
  void backFunction({required bool edit, required Vehicle vehicle}) {
    setState(() {
      _index = 0;
      vehicleId = -1;
      v = Vehicle.empty();
      if (edit) {
        _index = 1;
        v = vehicle;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (_index == 0)
        ? StreamBuilder<List<Vehicle>>(
            //use a stream to get all stored vehicles for user to choose
            stream: getAllVehicles(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.length == 0) {
                return Stack(children: [
                  Center(
                    child: Text('No vehicles found. Try creating one.'),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      _index = 1;
                    }),
                    icon: Icon(Icons.add),
                  ),
                ]);
              }
              List<Vehicle> vehicles = snapshot.data!;
              return ListView.builder(
                itemCount: vehicles.length + 1,
                itemBuilder: ((context, index) {
                  //display the vehicles' details with list tiles and add button to add new vehicle
                  if (index == vehicles.length)
                    return TextButton(
                      onPressed: () => setState(() {
                        _index = 1;
                      }),
                      child: Text('Add More'),
                    );
                  return Card(
                    child: ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(vehicles[index].name),
                      subtitle: Text(vehicles[index].description),
                      onTap: () {
                        setState(() {
                          _index = 2;
                          vehicleId = vehicles[index].id!;
                        });
                        print(vehicles[index].id);
                      },
                    ),
                  );
                }),
              );
            },
          )
        : (_index == 1)
            ? NewVehicleScreen(
                backArrowPressed: backFunction,
                v: v,
              )
            : EditVehicleSetup(backFunction, vehicleId);
  }
}
