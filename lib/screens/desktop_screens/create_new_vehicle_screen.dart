import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/vehicle.dart';

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

  //subsystem controllers
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

  //part controllers
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

  late List<List<List<Widget>>> partBoxList = [
    [
      [
        PartBox(
          id: 0,
          partNameControllerList: partNameControllerList[0][0],
          partMeasureControllerList: partMeasureControllerList[0][0],
          partValueControllerList: partValueControllerList[0][0],
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          context: context,
        ),
        PartBox(
          id: 1,
          partNameControllerList: partNameControllerList[0][0],
          partMeasureControllerList: partMeasureControllerList[0][0],
          partValueControllerList: partValueControllerList[0][0],
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          context: context,
        ),
        PartBox(
          id: 2,
          partNameControllerList: partNameControllerList[0][0],
          partMeasureControllerList: partMeasureControllerList[0][0],
          partValueControllerList: partValueControllerList[0][0],
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          context: context,
        ),
      ]
    ],
  ];

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
      ),
    ]
  ];

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
      ),
    ),
  ];
  void addPart({
    required int partNumber,
    required int subsystemNumber,
    required int systemNumber,
  }) {
    setState(() {
      partNameControllerList[systemNumber][subsystemNumber]
          .add(TextEditingController());
      partValueControllerList[systemNumber][subsystemNumber]
          .add(TextEditingController(text: '0'));
      partMeasureControllerList[systemNumber][subsystemNumber]
          .add(TextEditingController());
      partBoxList[systemNumber][subsystemNumber].add(
        PartBox(
          id: partNumber,
          partNameControllerList: partNameControllerList[systemNumber]
              [subsystemNumber],
          partMeasureControllerList: partMeasureControllerList[systemNumber]
              [subsystemNumber],
          partValueControllerList: partValueControllerList[systemNumber]
              [subsystemNumber],
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          context: context,
        ),
      );
    });
  }

  void addSubsystem({required int subsystemNumber, required int systemNumber}) {
    setState(() {
      partNameControllerList[systemNumber].add([]);
      partMeasureControllerList[systemNumber].add([]);
      partValueControllerList[systemNumber].add([]);
      subsystemNameControllerList[systemNumber].add(TextEditingController());
      subsystemDescriptionControllerList[systemNumber]
          .add(TextEditingController());
      subsystemBoxList.add([]);
      partBoxList[systemNumber].add([]);

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
        ),
      );
    });
  }

  void addSystem() {
    int systemNumber = systemBoxList.length;
    setState(() {
      partNameControllerList.add([]);
      partValueControllerList.add([]);
      partMeasureControllerList.add([]);
      systemNameControllerList.add(TextEditingController());
      systemDescriptionControllerList.add(TextEditingController());
      subsystemBoxList.add([]);
      subsystemNameControllerList.add([]);
      subsystemDescriptionControllerList.add([]);
      partBoxList.add([]);
      addSubsystem(subsystemNumber: 0, systemNumber: systemNumber);

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
          ),
        ),
      );
    });
  }

  Vehicle saveVehicle() {
    late Vehicle vehicle;
    List<List<List<Part>>> parts = [];
    List<List<Subsystem>> subsystems = [];
    List<System> systems = [];

    for (int i = 0; i < partBoxList.length; i++) {
      parts.add([]);
      for (int j = 0; j < partBoxList[i].length; j++) {
        parts[i].add([]);
        for (int k = 0; k < partBoxList[i][j].length; k++) {
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
    print(parts);
    for (int i = 0; i < subsystemBoxList.length; i++) {
      print('object' + i.toString());
      subsystems.add([]);
      for (int j = 0; j < subsystemBoxList[i].length; j++) {
        print('object' + j.toString());
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

    for (int i = 0; i < systemBoxList.length; i++) {
      systems.add(
        System(
          id: (v.systems.length - 1 < i) ? null : v.systems[i].id,
          name: systemNameControllerList[i].text,
          description: systemDescriptionControllerList[i].text,
          subsystems: subsystems[i],
        ),
      );
    }
    vehicle = Vehicle(
      id: done ? v.id : null,
      name: vehicleName.text,
      year: vehicleYear.text,
      description: vehicleDescription.text,
      systems: systems,
    );
    vehicle.printVehicle();
    return vehicle;

    //vehicle.printVehicle();
  }

  bool done = false;
  void setLists(Vehicle v) {
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
              partNameControllerList: partNameControllerList[i][j],
              partValueControllerList: partValueControllerList[i][j],
              partMeasureControllerList: partMeasureControllerList[i][j],
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              context: context,
            ),
          );
        }
      }
    }
    print('secret message');
    done = true;
  }

  @override
  Widget build(BuildContext context) {
    widget.v.printVehicle();
    if (!done && (v.id != null)) {
      setLists(v);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
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
                            onPressed: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Save Vehicle?'),
                                  content: Text('Your setup will be saved.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          (done)
                                              ? updateVehicleinDb(
                                                  vehicle: saveVehicle())
                                              : uploadVehicle(
                                                  vehicle: saveVehicle());
                                          Navigator.of(context).pop();
                                          widget.backArrowPressed(
                                              edit: false,
                                              vehicle: Vehicle.empty());
                                        },
                                        child: Text('OK')),
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
  });
  int id;
  List<TextEditingController> systemNameControllerList;
  List<TextEditingController> systemDescriptionControllerList;
  double screenWidth;
  double screenHeight;
  List<Widget> children;
  Function({required int subsystemNumber, required int systemNumber})
      addSubsystemFunction;
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
                ),
              ),
            ],
          ),
          SizedBox(height: widget.screenHeight * 0.01),
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
                      TextButton(
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
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
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

Widget PartBox({
  required int id,
  required List<TextEditingController> partNameControllerList,
  required List<TextEditingController> partValueControllerList,
  required List<TextEditingController> partMeasureControllerList,
  required double screenWidth,
  required double screenHeight,
  required BuildContext context,
}) =>
    Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
        ],
      ),
    );

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
              )
            ],
          ),
        ],
      ),
    );

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
