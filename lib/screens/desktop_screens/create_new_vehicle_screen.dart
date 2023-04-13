import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/vehicle.dart';
import 'package:http/http.dart';
import 'package:quiver/collection.dart';

import '../../../supabase/motorcycle_setup_functions.dart';

class NewVehicleScreen extends StatefulWidget {
  NewVehicleScreen({required this.backArrowPressed, required this.v});
  Function({required bool edit, required Vehicle vehicle}) backArrowPressed;
  Vehicle v;
  @override
  State<NewVehicleScreen> createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends State<NewVehicleScreen> {
  late Vehicle v;
  @override
  void initState() {
    v = widget.v;
    if (v == Vehicle.empty()) systemNameControllerList = [];
    super.initState();
  }

  double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  double screenHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  late int key = 1;

  //vehicle controllers
  TextEditingController vehicleName = new TextEditingController();
  TextEditingController vehicleYear = new TextEditingController();
  TextEditingController vehicleDescription = new TextEditingController();

  //system controllers
  List<TextEditingController> systemNameControllerList = [
    TextEditingController(),
  ];
  List<TextEditingController> systemDescriptionControllerList = [
    TextEditingController(),
  ];

  //subsystem controllers. First index is for part, second is for subsystem
  List<List<TextEditingController>> subsystemNameControllerList = [
    [
      TextEditingController(),
    ]
  ];
  List<List<TextEditingController>> subsystemDescriptionControllerList = [
    [
      TextEditingController(),
    ]
  ];

  //part controllers. First index is for part, second is for subsystem, third is for part
  List<List<List<TextEditingController>>> partNameControllerList = [
    [
      [
        TextEditingController(),
        TextEditingController(),
        TextEditingController()
      ],
    ],
  ];
  List<List<List<TextEditingController>>> partValueControllerList = [
    [
      [
        TextEditingController(text: '0'),
        TextEditingController(text: '0'),
        TextEditingController(text: '0')
      ],
    ]
  ];
  List<List<List<TextEditingController>>> partMeasureControllerList = [
    [
      [
        TextEditingController(),
        TextEditingController(),
        TextEditingController()
      ],
    ]
  ];
  //all the parts are contained in this nested list. First index is system, second is subsystem and third is part number
  late List<List<List<Widget>>> partBoxList = [
    [
      [
        PartBox(
            id: 0,
            subsystemId: 0,
            systemId: 0,
            partNameControllerList: partNameControllerList[0][0],
            partMeasureControllerList: partMeasureControllerList[0][0],
            partValueControllerList: partValueControllerList[0][0],
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            context: context,
            deletePartFunction: deletePart),
        PartBox(
          id: 1,
          subsystemId: 0,
          systemId: 0,
          partNameControllerList: partNameControllerList[0][0],
          partMeasureControllerList: partMeasureControllerList[0][0],
          partValueControllerList: partValueControllerList[0][0],
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          context: context,
          deletePartFunction: deletePart,
        ),
        PartBox(
          id: 2,
          subsystemId: 0,
          systemId: 0,
          partNameControllerList: partNameControllerList[0][0],
          partMeasureControllerList: partMeasureControllerList[0][0],
          partValueControllerList: partValueControllerList[0][0],
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          context: context,
          deletePartFunction: deletePart,
        ),
      ]
    ],
  ];
//all the subsystems are contained in this nested list. First index is system, second is subsystem
  late List<List<Widget>> subsystemBoxList = [
    [
      SubsystemBox(
        id: 0,
        systemNumber: 0,
        subsystemNameControllerList: subsystemNameControllerList[0],
        subsystemDescriptionControllerList:
            subsystemDescriptionControllerList[0],
        children: partBoxList[0][0],
        addPartFunction: addPart,
        deleteSubsystemFunction: deleteSubsystem,
      ),
    ]
  ];
//all the systems are contained in this list
  late List<Widget> systemBoxList = [
    Container(
      padding: EdgeInsets.only(top: 5),
      child: SystemBox(
        id: 0,
        systemNameControllerList: systemNameControllerList,
        systemDescriptionControllerList: systemDescriptionControllerList,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        children: subsystemBoxList[0],
        addSubsystemFunction: addSubsystem,
        deleteSystemFunction: deleteSystem,
      ),
    ),
  ];
  //called when a part is added
  void addPart({
    required int partNumber,
    required int subsystemNumber,
    required int systemNumber,
  }) {
    setState(() {
      //add controllers to all controller lists(name, value, measurement unit)
      partNameControllerList[systemNumber][subsystemNumber]
          .add(TextEditingController());
      partValueControllerList[systemNumber][subsystemNumber]
          .add(TextEditingController(text: '0'));
      partMeasureControllerList[systemNumber][subsystemNumber]
          .add(TextEditingController());
      //add item to parts list
      partBoxList[systemNumber][subsystemNumber].add(
        PartBox(
          id: partNumber,
          subsystemId: subsystemNumber,
          systemId: systemNumber,
          partNameControllerList: partNameControllerList[systemNumber]
              [subsystemNumber],
          partMeasureControllerList: partMeasureControllerList[systemNumber]
              [subsystemNumber],
          partValueControllerList: partValueControllerList[systemNumber]
              [subsystemNumber],
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          context: context,
          deletePartFunction: deletePart,
        ),
      );
      key++;
    });
  }

  //called when a part is deleted
  void deletePart(
      {required int subsystemNumber,
      required int systemNumber,
      required int partNumber}) {
    print('part with id ' +
        partNumber.toString() +
        ' from subsystem ' +
        subsystemNumber.toString() +
        ' from system ' +
        systemNumber.toString() +
        ' deleted');

    setState(() {
      // partBoxList[systemNumber][subsystemNumber].removeAt(partNumber);

      partBoxList[systemNumber][subsystemNumber]
          .replaceRange(partNumber, partNumber + 1, [Container()]);

      partNameControllerList[systemNumber][subsystemNumber][partNumber].text =
          'deleted';
      key++;
    });
  }

  //called when subsystem is added
  void addSubsystem({required int subsystemNumber, required int systemNumber}) {
    setState(() {
      //add list of controllers for new subsystem
      partNameControllerList[systemNumber].add([]);
      partMeasureControllerList[systemNumber].add([]);
      partValueControllerList[systemNumber].add([]);
      //add controllers to all controller lists(name, description)
      subsystemNameControllerList[systemNumber].add(TextEditingController());
      subsystemDescriptionControllerList[systemNumber]
          .add(TextEditingController());

      partBoxList[systemNumber].add([]);
      //add empty parts to the new subsystem
      addPart(
        partNumber: 0,
        subsystemNumber: subsystemNumber,
        systemNumber: systemNumber,
      );
      addPart(
        partNumber: 1,
        subsystemNumber: subsystemNumber,
        systemNumber: systemNumber,
      );
      //add item to subsystem list
      subsystemBoxList[systemNumber].add(
        SubsystemBox(
          id: subsystemNumber,
          systemNumber: systemNumber,
          subsystemNameControllerList:
              subsystemNameControllerList[systemNumber],
          subsystemDescriptionControllerList:
              subsystemDescriptionControllerList[systemNumber],
          children: partBoxList[systemNumber][subsystemNumber],
          addPartFunction: addPart,
          deleteSubsystemFunction: deleteSubsystem,
        ),
      );
      key++;
    });
  }

  //called when subsystem is deleted
  void deleteSubsystem(
      {required int subsystemNumber, required int systemNumber}) {
    print('subsystem with id ' +
        subsystemNumber.toString() +
        ' from system ' +
        systemNumber.toString() +
        ' deleted');
    setState(() {
      // partBoxList[systemNumber].removeAt(subsystemNumber);
      // subsystemBoxList[systemNumber].removeAt(subsystemNumber);

      partBoxList[systemNumber]
          .replaceRange(subsystemNumber, subsystemNumber + 1, [
        [Container()]
      ]);
      subsystemBoxList[systemNumber]
          .replaceRange(subsystemNumber, subsystemNumber + 1, [Container()]);
      subsystemNameControllerList[systemNumber][subsystemNumber].text =
          'deleted';
      key++;
    });
  }

  //called when system is added
  void addSystem() {
    int systemNumber = systemBoxList.length;
    setState(() {
      //add list of controllers for new part
      partNameControllerList.add([]);
      partValueControllerList.add([]);
      partMeasureControllerList.add([]);
      //add controllers for new system
      systemNameControllerList.add(TextEditingController());
      systemDescriptionControllerList.add(TextEditingController());
      //add list of controllers for new subsystem
      subsystemBoxList.add([]);
      subsystemNameControllerList.add([]);
      subsystemDescriptionControllerList.add([]);
      //add list of parts for new subsystem
      partBoxList.add([]);
      //add subsystem
      addSubsystem(subsystemNumber: 0, systemNumber: systemNumber);
      //add item to system list
      systemBoxList.add(
        Container(
          padding: EdgeInsets.only(top: 5),
          child: SystemBox(
            id: systemNumber,
            systemNameControllerList: systemNameControllerList,
            systemDescriptionControllerList: systemDescriptionControllerList,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            children: subsystemBoxList[systemNumber],
            addSubsystemFunction: addSubsystem,
            deleteSystemFunction: deleteSystem,
          ),
        ),
      );
      key++;
    });
  }

  //called when system is deleted
  void deleteSystem({required int systemNumber}) {
    print('system with id ' + systemNumber.toString() + ' deleted');

    setState(() {
      // subsystemBoxList.removeAt(systemNumber);
      // systemBoxList.removeAt(systemNumber);
      // partBoxList.removeAt(systemNumber);

      subsystemBoxList.replaceRange(systemNumber, systemNumber + 1, [
        [Container()]
      ]);
      systemBoxList.replaceRange(systemNumber, systemNumber + 1, [Container()]);
      partBoxList.replaceRange(systemNumber, systemNumber + 1, [
        [
          [Container()]
        ]
      ]);
      systemNameControllerList[systemNumber].text = 'deleted';
      key++;
    });
  }

  //called to save vehicle
  Vehicle saveVehicle() {
    late Vehicle vehicle;
    List<List<List<Part>>> parts = [];
    List<List<Subsystem>> subsystems = [];
    List<System> systems = [];
    //copy values of lists to new lists with designated classes

    //create lists with parts
    for (int i = 0; i < partBoxList.length; i++) {
      parts.add([]);
      for (int j = 0; j < partBoxList[i].length; j++) {
        parts[i].add([]);
        for (int k = 0; k < partBoxList[i][j].length; k++) {
          if (partNameControllerList[i][j][k].text != 'deleted') {
            parts[i][j].add(
              Part(
                id: (v.systems.length - 1 < i)
                    ? null
                    : (v.systems[i].subsystems.length - 1 < j)
                        ? null
                        : (v.systems[i].subsystems[j].parts.length - 1 < k)
                            ? null
                            : v.systems[i].subsystems[j].parts[k].id,
                name: partNameControllerList[i][j][k].text,
                measurementUnit: partMeasureControllerList[i][j][k].text,
                value: int.parse(partValueControllerList[i][j][k].text),
              ),
            );
          }
        }
      }
    }

    print(parts);
    //create lists with subsystems
    for (int i = 0; i < subsystemBoxList.length; i++) {
      print('object' + i.toString());
      subsystems.add([]);
      for (int j = 0; j < subsystemBoxList[i].length; j++) {
        print('object' + j.toString());
        if (subsystemNameControllerList[i][j].text != 'deleted') {
          subsystems[i].add(
            Subsystem(
              id: (v.systems.length - 1 < i)
                  ? null
                  : (v.systems[i].subsystems.length - 1 < j)
                      ? null
                      : v.systems[i].subsystems[j].id,
              name: subsystemNameControllerList[i][j].text,
              description: subsystemDescriptionControllerList[i][j].text,
              parts: parts[i][j],
            ),
          );
        }
      }
    }

    //create list with systems
    for (int i = 0; i < systemBoxList.length; i++) {
      if (systemNameControllerList[i].text != 'deleted') {
        systems.add(
          System(
            id: (v.systems.length - 1 < i) ? null : v.systems[i].id,
            name: systemNameControllerList[i].text,
            description: systemDescriptionControllerList[i].text,
            subsystems: subsystems[i],
          ),
        );
      }
    }
    //create the new vehicle
    vehicle = Vehicle(
      id: setListsDone ? v.id : null,
      name: vehicleName.text,
      year: vehicleYear.text,
      description: vehicleDescription.text,
      systems: systems,
    );
    vehicle.printVehicle();
    return vehicle;

    //vehicle.printVehicle();
  }

  //variable that controls whether the setLists function has been executed or not
  bool setListsDone = false;
  //called if the user edits the vehicle and does not create a new one
  void setLists(Vehicle v) {
    //create and assign the textfields with the values for the user to modify
    vehicleName = TextEditingController(text: v.name);
    vehicleYear = TextEditingController(text: v.year);
    vehicleDescription = TextEditingController(text: v.description);
    systemNameControllerList = [];
    systemDescriptionControllerList = [];
    subsystemNameControllerList = [];
    subsystemDescriptionControllerList = [];
    partNameControllerList = [];
    partValueControllerList = [];
    partMeasureControllerList = [];
    partBoxList = [];
    subsystemBoxList = [];
    systemBoxList = [];
    for (int i = 0; i < v.systems.length; i++) {
      systemNameControllerList
          .add(TextEditingController(text: v.systems[i].name));
      systemDescriptionControllerList
          .add(TextEditingController(text: v.systems[i].description));
      subsystemNameControllerList.add([]);
      subsystemDescriptionControllerList.add([]);
      partNameControllerList.add([]);
      partValueControllerList.add([]);
      partMeasureControllerList.add([]);
      ////
      partBoxList.add([]);
      subsystemBoxList.add([]);
      systemBoxList.add(
        SystemBox(
          id: i,
          systemNameControllerList: systemNameControllerList,
          systemDescriptionControllerList: systemDescriptionControllerList,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          children: subsystemBoxList[i],
          addSubsystemFunction: addSubsystem,
          deleteSystemFunction: deleteSystem,
        ),
      );

      ///
      for (int j = 0; j < v.systems[i].subsystems.length; j++) {
        partNameControllerList[i].add([]);
        partValueControllerList[i].add([]);
        partMeasureControllerList[i].add([]);
        subsystemNameControllerList[i]
            .add(TextEditingController(text: v.systems[i].subsystems[j].name));
        subsystemDescriptionControllerList[i].add(TextEditingController(
            text: v.systems[i].subsystems[j].description));
        ////
        partBoxList[i].add([]);
        subsystemBoxList[i].add(
          SubsystemBox(
            id: j,
            systemNumber: i,
            subsystemNameControllerList: subsystemNameControllerList[i],
            subsystemDescriptionControllerList:
                subsystemDescriptionControllerList[i],
            children: partBoxList[i][j],
            addPartFunction: addPart,
            deleteSubsystemFunction: deleteSubsystem,
          ),
        );

        ///
        for (int k = 0; k < v.systems[i].subsystems[j].parts.length; k++) {
          partNameControllerList[i][j].add(TextEditingController(
              text: v.systems[i].subsystems[j].parts[k].name));
          partValueControllerList[i][j].add(TextEditingController(
              text: (v.systems[i].subsystems[j].parts[k].value).toString()));
          partMeasureControllerList[i][j].add(TextEditingController(
              text: v.systems[i].subsystems[j].parts[k].measurementUnit));
          //
          partBoxList[i][j].add(
            PartBox(
                id: k,
                subsystemId: j,
                systemId: i,
                partNameControllerList: partNameControllerList[i][j],
                partValueControllerList: partValueControllerList[i][j],
                partMeasureControllerList: partMeasureControllerList[i][j],
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                context: context,
                deletePartFunction: deletePart),
          );
        }
      }
    }
    print('secret message');
    setListsDone = true;
  }

  //called when a part is removed to update the key
  void calculateKey() {
    print('called calculateKey');
    int sum = 0;
    for (int i = 0; i < partBoxList.length; i++) {
      sum += partBoxList[i].length;
      for (int k = 0; k < partBoxList[i].length; k++) {
        sum += partBoxList[i][k].length;
      }
    }
    //key = sum.toString();
    print('exited calculateKey');
  }

  @override
  Widget build(BuildContext context) {
    //calculateKey();
    print('key: ' + key.toString());
    print('-----');
    print('systems');
    print(systemBoxList);
    print('------------------------------');
    print('subsystems');
    print(subsystemBoxList);
    print('------------------------------');
    print('parts');
    print(partBoxList);
    print(
        '-------------------------------------------------------------------------------------');
    //if the user edits a pre existing vehicle the appropriate function is executed
    if (!setListsDone && (v.id != null)) {
      setLists(v);
    }

    return Column(
      key: Key(key.toString()),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          //back button
          child: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () => setState(() {
              widget.backArrowPressed(
                edit: false,
                vehicle: Vehicle(
                  name: 'name',
                  year: 'year',
                  description: 'description',
                  systems: [],
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //display the information of the vehicle
                      VehicleBox(
                        vehicleNameController: vehicleName,
                        vehicleDescriptionController: vehicleDescription,
                        vehicleYearController: vehicleYear,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        context: context,
                        addSystem: addSystem,
                      ),
                      Column(
                        children: [
                          TextButton(
                              onPressed: () {
                                saveVehicle();
                              },
                              child: Text('TASK')),
                          //button to save vehicle
                          TextButton(
                            //show dialog to alert user for saved changes
                            onPressed: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Save Vehicle?'),
                                  content: Text('Your setup will be saved.'),
                                  actions: [
                                    //button to cancel vehicle saving
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('No')),
                                    //button to proceed with vehicle saving
                                    TextButton(
                                      onPressed: () async {
                                        var vehicleLoadedOnDatabase;
                                        await Future.delayed(
                                          Duration(milliseconds: 500),
                                        );
                                        Navigator.of(context).pop();
                                        //new dialog pops up with loading indicator
                                        showDialog(
                                          context: context,
                                          builder: (dialogcontext) {
                                            Future.wait([
                                              //vehicle is being inserted or updated
                                              (setListsDone)
                                                  ? vehicleLoadedOnDatabase =
                                                      updateVehicleinDb(
                                                          vehicle:
                                                              saveVehicle())
                                                  : vehicleLoadedOnDatabase =
                                                      uploadVehicle(
                                                          vehicle:
                                                              saveVehicle()),
                                            ]).then((value) {
                                              //then user is redirected to the previous page
                                              Navigator.of(dialogcontext).pop();
                                              widget.backArrowPressed(
                                                  edit: false,
                                                  vehicle: Vehicle.empty());
                                            });

                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                        );
                                        //
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  // display list with systems
                  ...systemBoxList,
                  SizedBox(height: screenHeight * 0.1)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//the ui of the card that holds a system, its subsystem and the parts of each subsystem
class SystemBox extends StatefulWidget {
  SystemBox({
    required int this.id,
    required List<TextEditingController> this.systemNameControllerList,
    required List<TextEditingController> this.systemDescriptionControllerList,
    required double this.screenWidth,
    required double this.screenHeight,
    required List<Widget> this.children,
    required Function({required int subsystemNumber, required int systemNumber})
        this.addSubsystemFunction,
    required Function({required int systemNumber}) this.deleteSystemFunction,
  });
  int id;
  List<TextEditingController> systemNameControllerList;
  List<TextEditingController> systemDescriptionControllerList;
  double screenWidth;
  double screenHeight;
  List<Widget> children;
  Function({required int subsystemNumber, required int systemNumber})
      addSubsystemFunction;
  Function({required int systemNumber}) deleteSystemFunction;
  @override
  State<SystemBox> createState() => _SystemBoxState();
}

class _SystemBoxState extends State<SystemBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: widget.screenWidth * 0.8,
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'System Details',
                        style: TextStyle(fontSize: 24),
                      ),
                      Row(
                        children: [
                          //delete system button
                          TextButton(
                            child: Text(
                              'Delete System',
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            ),
                            onPressed: () => setState(() {
                              widget.deleteSystemFunction(
                                systemNumber: widget.id,
                              );
                            }),
                          ),
                          //add subsystem button
                          TextButton(
                            child: Text(
                              'Add Subsystem',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () => setState(() {
                              widget.addSubsystemFunction(
                                subsystemNumber: widget.children.length,
                                systemNumber: widget.id,
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.screenHeight * 0.01),
          //display textfields
          Row(
            children: [
              Container(
                width: widget.screenWidth * 0.2,
                child: myTextField(
                  controller: widget.systemNameControllerList[widget.id],
                  label: 'Name',
                ),
              ),
              SizedBox(width: widget.screenWidth * 0.01),
              Container(
                width: widget.screenWidth * 0.2,
                child: myTextField(
                  controller: widget.systemDescriptionControllerList[widget.id],
                  label: 'Description',
                ),
              ),
            ],
          ),
          SizedBox(height: widget.screenHeight * 0.02),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 27,
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
                Column(
                  children: [
                    //display parts of the subsystem
                    ...widget.children,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//the ui of the card that holds a subsystem and the parts of it
class SubsystemBox extends StatefulWidget {
  SubsystemBox({
    required int this.id,
    required int this.systemNumber,
    required List<TextEditingController> this.subsystemNameControllerList,
    required List<TextEditingController>
        this.subsystemDescriptionControllerList,
    required List<Widget> this.children,
    required Function(
            {required int partNumber,
            required int subsystemNumber,
            required int systemNumber})
        this.addPartFunction,
    required Function({required int subsystemNumber, required int systemNumber})
        this.deleteSubsystemFunction,
  });
  int id;
  int systemNumber;
  List<TextEditingController> subsystemNameControllerList;
  List<TextEditingController> subsystemDescriptionControllerList;
  List<Widget> children;
  Function(
      {required int partNumber,
      required int subsystemNumber,
      required int systemNumber}) addPartFunction;
  Function({required int subsystemNumber, required int systemNumber})
      deleteSubsystemFunction;
  @override
  State<SubsystemBox> createState() => _SubsystemBoxState();
}

class _SubsystemBoxState extends State<SubsystemBox> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: screenWidth * 0.8 - 37,
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SubSystem Details',
                        style: TextStyle(fontSize: 24),
                      ),
                      Row(
                        children: [
                          TextButton(
                              //delete subsystem button
                              child: Text(
                                'Delete Subsystem',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                              onPressed: () => widget.deleteSubsystemFunction(
                                    subsystemNumber: widget.id,
                                    systemNumber: widget.systemNumber,
                                  )),
                          TextButton(
                            //add part button
                            child: Text(
                              'Add Part',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () => setState(() {
                              widget.addPartFunction(
                                partNumber: widget.children.length,
                                subsystemNumber: widget.id,
                                systemNumber: widget.systemNumber,
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              //textfields for the subsystem
              Container(
                width: screenWidth * 0.2,
                child: myTextField(
                  controller: widget.subsystemNameControllerList[widget.id],
                  label: 'Name',
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Container(
                width: screenWidth * 0.2,
                child: myTextField(
                  controller:
                      widget.subsystemDescriptionControllerList[widget.id],
                  label: 'Description',
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Card(
            child: Column(
              children: [
                Container(
                  color: Colors.grey.withOpacity(0.1),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Part Details', style: TextStyle(fontSize: 20)),
                      //display parts of the subsystem
                      ...widget.children
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//ui of the subsystem part
Widget PartBox({
  required int id,
  required int subsystemId,
  required int systemId,
  required List<TextEditingController> partNameControllerList,
  required List<TextEditingController> partValueControllerList,
  required List<TextEditingController> partMeasureControllerList,
  required double screenWidth,
  required double screenHeight,
  required BuildContext context,
  required Function(
          {required int subsystemNumber,
          required int systemNumber,
          required int partNumber})
      deletePartFunction,
}) =>
    Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //textfields for the part
          Container(
            width: screenWidth * 0.19,
            child: myTextField(
              controller: partNameControllerList[id],
              label: 'Name',
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: screenWidth * 0.1,
            child: myTextField(
              controller: partMeasureControllerList[id],
              label: 'Measurement Unit',
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: screenWidth * 0.09 - 1,
            child: myTextField(
              controller: partValueControllerList[id],
              label: 'Initial Value',
            ),
          ),
          SizedBox(width: screenWidth * 0.01),
          IconButton(
              onPressed: () => deletePartFunction(
                    partNumber: id,
                    subsystemNumber: subsystemId,
                    systemNumber: systemId,
                  ),
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
    );

//ui for vehicle information
Widget VehicleBox({
  required TextEditingController vehicleNameController,
  required TextEditingController vehicleYearController,
  required TextEditingController vehicleDescriptionController,
  required double screenWidth,
  required double screenHeight,
  required BuildContext context,
  required Function addSystem,
}) =>
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.8,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vehicle Details',
                    style: TextStyle(fontSize: 24),
                  ),
                  TextButton(
                    onPressed: () => addSystem(),
                    child: Text(
                      'Add System',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              //display textfields for vehicle
              Container(
                width: screenWidth * 0.2,
                child: myTextField(
                  controller: vehicleNameController,
                  label: 'Name',
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Container(
                width: screenWidth * 0.08,
                child: myTextField(
                  controller: vehicleYearController,
                  label: 'Year',
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Container(
                width: screenWidth * 0.29,
                child: myTextField(
                  controller: vehicleDescriptionController,
                  label: 'Description',
                ),
              ),
            ],
          ),
        ],
      ),
    );

//custom textfield
TextField myTextField({
  required TextEditingController controller,
  required String label,
}) =>
    TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
      ),
    );
