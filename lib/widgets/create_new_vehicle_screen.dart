import 'package:flutter/material.dart';

class NewVehicleScreen extends StatefulWidget {
  const NewVehicleScreen({super.key});

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
      ),
      PartBox(
        id: 1,
        partNameControllerList: partNameControllerList[0],
        partMeasureControllerList: partMeasureControllerList[0],
        partValueControllerList: partValueControllerList[0],
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      ),
      PartBox(
        id: 2,
        partNameControllerList: partNameControllerList[0],
        partMeasureControllerList: partMeasureControllerList[0],
        partValueControllerList: partValueControllerList[0],
        screenWidth: screenWidth,
        screenHeight: screenHeight,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.9,
      width: screenWidth * 0.9,
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
                ),
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
                )
              ],
            ),
            SizedBox(height: 5),
            ...systemBoxList,
            SizedBox(height: 5),
          ],
        ),
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
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 2)),
      padding: EdgeInsets.all(10),
      width: widget.screenWidth * 0.9,
      height: (calculateRows(widget.children.length) == 1)
          ? (widget.screenHeight * 0.265)
          : (widget.screenHeight * 0.22) *
              calculateRows(widget.children.length),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Details',
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                  width: widget.screenWidth * 0.2,
                  child: TextField(
                    controller: widget.systemNameControllerList[widget.id],
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: widget.screenHeight * 0.01),
                Container(
                  width: widget.screenWidth * 0.2,
                  child: TextField(
                    controller:
                        widget.systemDescriptionControllerList[widget.id],
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                    ),
                  ),
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
                )
              ],
            ),
            SizedBox(width: 1),
            VerticalDivider(
              thickness: 2,
              color: Colors.black,
            ),
            SizedBox(
              width: widget.screenWidth * 0.67,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 5,
                runSpacing: 5,
                children: widget.children,
              ),
            ),
          ],
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
}) =>
    Container(
      decoration: BoxDecoration(border: Border.all(width: 2)),
      padding: EdgeInsets.all(5),
      height: screenHeight * 0.2,
      width: screenWidth * 0.22,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Part Details',
            style: TextStyle(fontSize: 20),
          ),
          Container(
            width: screenWidth * 0.2,
            child: TextField(
              controller: partNameControllerList[id],
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.black),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: screenWidth * 0.1,
                child: TextField(
                  controller: partMeasureControllerList[id],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Container(
                width: screenWidth * 0.1,
                child: TextField(
                  controller: partValueControllerList[id],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );

Widget VehicleBox({
  required TextEditingController vehicleNameController,
  required TextEditingController vehicleYearController,
  required TextEditingController vehicleDescriptionController,
  required double screenWidth,
}) =>
    Container(
      decoration: BoxDecoration(border: Border.all(width: 2)),
      padding: EdgeInsets.all(10),
      width: screenWidth * 0.3 + 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Details',
            style: TextStyle(fontSize: 24),
          ),
          Row(
            children: [
              Container(
                width: screenWidth * 0.2,
                child: TextField(
                  controller: vehicleNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Container(
                width: screenWidth * 0.08,
                child: TextField(
                  controller: vehicleYearController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
            width: screenWidth * 0.29,
            child: TextField(
              controller: vehicleDescriptionController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );

int calculateRows(int numberOfElements) {
  late int n;
  if (numberOfElements == 0) return 1;
  n = (numberOfElements / 3).toInt();
  if (numberOfElements % 3 != 0) {
    n++;
  }
  return n;
}
