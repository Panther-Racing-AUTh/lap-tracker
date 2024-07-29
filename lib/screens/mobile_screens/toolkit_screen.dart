import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/calendar_models/meeting_model.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_screen.dart';
import 'package:flutter_complete_guide/supabase/calendar_functions.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TrackDayScreen extends StatefulWidget {
  @override
  _TrackDayScreenState createState() => _TrackDayScreenState();
}

class _TrackDayScreenState extends State<TrackDayScreen> {
  String? selectedTool;
  DateTime? selectedDate;
  List<ChecklistItem> selectedTools = [];

  final Map<String, List<String>> categorizedTools = {
    'General Hand Tools': [
      'Socket Set (Metric and SAE)',
      'Combination Wrench Set',
      'Allen Wrench Set (Metric and SAE)',
      'Screwdriver Set (Flathead and Phillips)',
      'Pliers Set (Long Nose, Diagonal Cutters, Slip Joint)',
      'Adjustable Wrenches',
      'Torque Wrenches (Various sizes)',
      'Hammers (Rubber, Ball-peen, Dead Blow)',
      'Pry Bars',
      'Utility Knife',
      'Tape Measure',
      'Level',
      'Files and Rasps',
      'Punch and Chisel Set',
      'Magnet Pickup Tool',
      'Inspection Mirror',
      'Digital Calipers',
      'Vernier Calipers',
      'Micrometer Set',
    ],
    'Specialty Motorcycle Tools': [
      'Chain Tool',
      'Spoke Wrench',
      'Valve Tool',
      'Clutch Holding Tool',
      'Throttle Cable Tool',
      'Front Fork Tool',
      'Axle Wrench',
      'Tire Changing Tools (Bead Breaker, Tire Irons)',
      'Tire Pressure Gauge',
      'Brake Bleeding Kit',
      'Chain Alignment Tool',
      'Spark Plug Socket',
      'Flywheel Puller',
      'Piston Ring Compressor',
      'Torque Angle Gauge',
      'Vacuum Gauge',
      'Compression Tester',
      'Leak Down Tester',
    ],
    'Electrical Tools': [
      'Multimeter',
      'Test Light',
      'Battery Tester',
      'Wire Strippers',
      'Crimping Tools',
      'Soldering Iron and Solder',
      'Heat Shrink Tubing',
      'Electrical Tape',
      'Fuses and Relays',
      'Connectors and Terminals',
      'Circuit Tester',
      'Diagnostic Scanner',
    ],
    'Power Tools': [
      'Cordless Drill and Bits',
      'Angle Grinder',
      'Dremel Tool',
      'Impact Wrench',
      'Heat Gun',
      'Bench Grinder',
      'Bench Vise',
      'Air Compressor',
      'Air Ratchet',
      'Air Chisel',
      'Air Drill',
      'Die Grinder',
      'Electric Impact Gun',
      'Electric Ratchet',
      'Pneumatic Rivet Gun',
      'Cordless Screwdriver',
    ],
    'Workshop Equipment': [
      'Motorcycle Lift',
      'Jack Stands',
      'Pit Stands',
      'Workbench',
      'Tool Chest',
      'Rolling Tool Cart',
      'Parts Washer',
      'Engine Stand',
      'Oil Drain Pan',
      'Funnel Set',
      'Measuring Cups and Pitchers',
      'Oil Filter Wrenches',
      'Fluid Transfer Pump',
      'Brake Bleeder Kit',
      'Safety Wire and Pliers',
      'Chain Cleaner and Lubricant',
      'Grease Gun',
      'Bearing Puller Set',
      'Hydraulic Press',
      'Tire Balancer',
      'Wheel Weights',
    ],
    'Safety Equipment': [
      'Fire Extinguisher',
      'First Aid Kit',
      'Safety Glasses',
      'Ear Protection',
      'Gloves',
      'Respirator Masks',
      'Safety Shoes',
      'Fireproof Mat',
      'Spill Containment Kit',
      'Knee Pads',
      'Protective Clothing (Mechanic Overalls)',
    ],
    'Consumables and Supplies': [
      'Engine Oil',
      'Transmission Fluid',
      'Coolant',
      'Brake Fluid',
      'Chain Lube',
      'Degreaser',
      'Cleaners and Polishes',
      'Shop Towels',
      'Disposable Gloves',
      'Cable Ties',
      'Hose Clamps',
      'Various Fasteners (Nuts, Bolts, Screws)',
      'Gaskets and O-Rings',
      'Sealing Compounds',
      'Thread Locking Compound',
      'Anti-Seize Lubricant',
    ],
    'Miscellaneous Tools': [
      'Flashlights',
      'Headlamp',
      'Magnifying Glass',
      'Label Maker',
      'Notepad and Pen',
      'Storage Bins and Containers',
      'Portable Work Light',
      'Extension Cords',
      'Battery Charger',
      'Fuel Canisters',
      'Oil Absorbent Pads',
    ],
    'Track-Specific Equipment': [
      'Lap Timer',
      'Data Logging Equipment',
      'GPS Tracker',
      'Tire Warmers',
      'Generator',
      'Pop-Up Tent',
      'Folding Chairs',
      'Cooler for Drinks and Snacks',
      'Pit Boards',
      'Fuel Jugs',
      'Track Map',
      'Radio Communication Set',
    ],
    'Transport and Logistics': [
      'Tie-Down Straps',
      'Wheel Chocks',
      'Loading Ramps',
      'Toolboxes for Transport',
      'Cargo Nets',
      'Spare Parts Crates',
      'Trailer or Transport Van',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerModel(context, DrawerIndexValue.toolkit.getInt()),
      appBar: AppBar(
        title: Text('Track Day Tools'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildDatePicker(),
              SizedBox(height: 20),
              _buildCategorizedDropdownButton(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedTool != null) {
                    if (!_isToolAlreadySelected(selectedTool!)) {
                      setState(() {
                        selectedTools.add(ChecklistItem(task: selectedTool!, completed: false));
                        selectedTool = null; // Reset selection
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added tool: $selectedTool'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tool $selectedTool is already selected.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select a tool.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text('Add Tool'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: _buildSelectedToolsList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitToolList();
                },
                child: Text('Submit Tool List'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      children: <Widget>[
        Text(
          'Select a date:',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null && pickedDate != selectedDate) {
              setState(() {
                selectedDate = pickedDate;
              });
            }
          },
          child: Text(selectedDate == null ? 'Select Date' : 'Date Selected: ${DateFormat('dd/MM/yyyy').format(selectedDate!.toLocal())}', style: TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  Widget _buildCategorizedDropdownButton() {
    return Column(
      children: <Widget>[
        Text(
          'Select a tool:',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text('Select a tool'),
            value: selectedTool,
            onChanged: (String? value) {
              setState(() {
                selectedTool = value!;
              });
            },
            items: _buildDropdownItems(),
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    List<DropdownMenuItem<String>> items = [];
    categorizedTools.forEach((category, tools) {
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          child: Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              category,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
      tools.forEach((tool) {
        items.add(
          DropdownMenuItem<String>(
            value: tool,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(tool),
            ),
          ),
        );
      });
    });
    return items;
  }

  Widget _buildSelectedToolsList() {
    return Container(
      decoration: BoxDecoration(
        color: selectedTools.isEmpty ? Colors.transparent : Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        child: ListView.builder(
          itemCount: selectedTools.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('${index + 1}) ${selectedTools[index].task}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      selectedTools.removeAt(index);
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isToolAlreadySelected(String tool) {
    return selectedTools.any((element) => element.task == tool);
  }

  void _submitToolList() async{
    if (selectedTools.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No tools to submit.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Tool List'),
          content: Text('Are you sure you want to submit the following tools?\n\n${selectedTools.map((item) => item.task).join('\n')}'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () async {
                Navigator.of(context).pop();
                // Handle the submission logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tool list submitted successfully.'),
                    duration: Duration(seconds: 2),
                  ),
                );

                Appointment tempAppointment = Appointment(
                  subject: "Toolkit",
                  notes: jsonEncode(selectedTools.map((item) => item.toJson()).toList()),
                  color: Color(TeamRoles.sponsors.getColor()),
                  isAllDay: true,
                  startTime: selectedDate!,
                  endTime: selectedDate!,
                  location: TeamLocation.noLocation.getString(),
                );
                var tempMap= AllAppointmentsFromMap(await getAppointmentsBySubjectAndStartDate("Toolkit",selectedDate!));
                for(var item in tempMap){
                  print(item.subject);
                }
                if (tempMap.isEmpty){
                  saveAppointment(tempAppointment);
                }else{
                  updateAppointmentBySubject(tempAppointment);
                }



                setState(() {
                  selectedTools.clear(); // Optionally clear the list after submission
                });
              },
            ),
          ],
        );
      },
    );
  }
}
class ChecklistItem {
  String task;
  bool completed;

  ChecklistItem({required this.task, required this.completed});

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      task: json['task'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'completed': completed,
    };
  }
}
