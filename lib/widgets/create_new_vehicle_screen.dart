import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/vehicle.dart';

class NewVehicleScreen extends StatefulWidget {
  NewVehicleScreen({required Function this.backArrowPressed});
  Function backArrowPressed;
  @override
  State<NewVehicleScreen> createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends State<NewVehicleScreen> {
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

  //part controllers
  List<List<TextEditingController>> partNameControllerList = [
    [TextEditingController(), TextEditingController(), TextEditingController()],
  ];
  List<List<TextEditingController>> partValueControllerList = [
    [TextEditingController(), TextEditingController(), TextEditingController()],
  ];
  List<List<TextEditingController>> partMeasureControllerList = [
    [TextEditingController(), TextEditingController(), TextEditingController()],
  ];

  late List<List<Widget>> partBoxList = [
    [
      PartBox(
        id: 0,
        partNameControllerList: partNameControllerList[0],
        partMeasureControllerList: partMeasureControllerList[0],
        partValueControllerList: partValueControllerList[0],
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        context: context,
      ),
      PartBox(
        id: 1,
        partNameControllerList: partNameControllerList[0],
        partMeasureControllerList: partMeasureControllerList[0],
        partValueControllerList: partValueControllerList[0],
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        context: context,
      ),
      PartBox(
        id: 2,
        partNameControllerList: partNameControllerList[0],
        partMeasureControllerList: partMeasureControllerList[0],
        partValueControllerList: partValueControllerList[0],
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        context: context,
      ),
    ],
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
        children: partBoxList[0],
        addPartFunction: addPart,
      ),
    ),
  ];
  void addPart({required int partNumber, required int systemNumber}) {
    setState(() {
      partNameControllerList[systemNumber].add(TextEditingController());
      partValueControllerList[systemNumber].add(TextEditingController());
      partMeasureControllerList[systemNumber].add(TextEditingController());
      partBoxList[systemNumber].add(
        PartBox(
          id: partNumber,
          partNameControllerList: partNameControllerList[systemNumber],
          partMeasureControllerList: partMeasureControllerList[systemNumber],
          partValueControllerList: partValueControllerList[systemNumber],
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          context: context,
        ),
      );
    });
  }

  void addSystem({required int systemNumber}) {
    setState(() {
      partNameControllerList.add([]);
      partValueControllerList.add([]);
      partMeasureControllerList.add([]);
      systemNameControllerList.add(TextEditingController());
      systemDescriptionControllerList.add(TextEditingController());
      partBoxList.add([]);
      addPart(partNumber: 0, systemNumber: systemNumber);
      addPart(partNumber: 1, systemNumber: systemNumber);
      addPart(partNumber: 2, systemNumber: systemNumber);
      systemBoxList.add(
        Container(
          padding: EdgeInsets.only(top: 5),
          child: SystemBox(
            id: systemNumber,
            systemNameControllerList: systemNameControllerList,
            systemDescriptionControllerList: systemDescriptionControllerList,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            children: partBoxList[systemNumber],
            addPartFunction: addPart,
          ),
        ),
      );
    });
  }

  void saveVehicle() {
    late Vehicle vehicle;
    List<List<Part>> parts = [];
    List<System> systems = [];
    for (int i = 0; i < partBoxList.length; i++) {
      parts.add([]);
      for (int j = 0; j < partBoxList[i].length; j++) {
        parts[i].add(
          Part(
            name: partNameControllerList[i][j].text,
            measurementUnit: partMeasureControllerList[i][j].text,
            value: int.parse(partValueControllerList[i][j].text),
          ),
        );
      }
    }
    for (int i = 0; i < systemBoxList.length; i++) {
      systems.add(
        System(
          name: systemNameControllerList[i].text,
          description: systemDescriptionControllerList[i].text,
          parts: parts[i],
        ),
      );
    }
    vehicle = Vehicle(
      name: vehicleName.text,
      year: vehicleYear.text,
      description: vehicleDescription.text,
      systems: systems,
    );
    vehicle.insertVehicle(vehicle: vehicle);
    vehicle.printVehicle();
    widget.backArrowPressed();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              onPressed: () => setState(() {
                widget.backArrowPressed();
              }),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: screenHeight,
            width: screenWidth,
            child: SingleChildScrollView(
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
                      ),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                addSystem(systemNumber: systemBoxList.length);
                              });
                            },
                            child: Text(
                              'Add System',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          TextButton(
                            onPressed: () => saveVehicle(),
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
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
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
    required Function({required int partNumber, required int systemNumber})
        this.addPartFunction,
  });
  int id;
  List<TextEditingController> systemNameControllerList;
  List<TextEditingController> systemDescriptionControllerList;
  double screenWidth;
  double screenHeight;
  List<Widget> children;
  Function({required int partNumber, required int systemNumber})
      addPartFunction;
  @override
  State<SystemBox> createState() => _SystemBoxState();
}

class _SystemBoxState extends State<SystemBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        width: calculateColumns(widget.children.length) *
            widget.screenWidth *
            0.26,
        height: (widget.screenHeight * 0.15) +
            (widget.screenHeight * 0.23) *
                calculateRows(widget.children.length),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'System Details',
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: widget.screenHeight * 0.01),
                          Container(
                            width: widget.screenWidth * 0.2,
                            child: myTextField(
                              controller:
                                  widget.systemNameControllerList[widget.id],
                              label: 'Name',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: widget.screenHeight * 0.01),
                      Container(
                        width: widget.screenWidth * 0.2,
                        child: myTextField(
                          controller:
                              widget.systemDescriptionControllerList[widget.id],
                          label: 'Description',
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    child: Text(
                      'Add Part',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => setState(() {
                      widget.addPartFunction(
                        partNumber: widget.children.length,
                        systemNumber: widget.id,
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: widget.screenHeight * 0.01),
              SizedBox(
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.children,
                ),
              ),
            ],
          ),
        ),
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
    Card(
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        padding: EdgeInsets.all(10),
        height: screenHeight * 0.2,
        width: screenWidth * 0.205,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Part Details',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: screenWidth * 0.19,
              child: myTextField(
                controller: partNameControllerList[id],
                label: 'Name',
              ),
            ),
            Row(
              children: [
                Container(
                  width: screenWidth * 0.1,
                  child: myTextField(
                    controller: partMeasureControllerList[id],
                    label: 'Measurement Unit',
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Container(
                  width: screenWidth * 0.09 - 1,
                  child: myTextField(
                    controller: partValueControllerList[id],
                    label: 'Initial Value',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

Widget VehicleBox({
  required TextEditingController vehicleNameController,
  required TextEditingController vehicleYearController,
  required TextEditingController vehicleDescriptionController,
  required double screenWidth,
  required double screenHeight,
  required BuildContext context,
}) =>
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.59,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Vehicle Details',
                style: TextStyle(fontSize: 24),
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

int calculateRows(int numberOfElements) {
  late int n;
  if (numberOfElements == 0) return 1;
  n = (numberOfElements / 4).toInt();
  if (numberOfElements % 4 != 0) {
    n++;
  }
  return n;
}

int calculateColumns(int numberOfElements) {
  late int n;
  if (numberOfElements == 0) return 2;
  n = (numberOfElements / calculateRows(numberOfElements)).toInt();
  if (numberOfElements % calculateRows(numberOfElements) != 0) {
    n++;
  }
  return n;
}

TextField myTextField(
        {required TextEditingController controller, required String label}) =>
    TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
      ),
    );
