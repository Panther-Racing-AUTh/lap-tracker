import 'package:flutter/material.dart';

class NewVehicleScreen extends StatefulWidget {
  const NewVehicleScreen({super.key});

  @override
  State<NewVehicleScreen> createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends State<NewVehicleScreen> {
  @override
  void initState() {
    late TextEditingController textEditingController;
    super.initState();
  }

  TextEditingController textEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      actions: [
        Container(
          height: screenHeight * 0.9,
          width: screenWidth * 0.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VehicleBox(
                  textEditingController: textEditingController,
                  screenWidth: screenWidth,
                ),
                SizedBox(height: 5),
                SystemBox(
                  textEditingController: textEditingController,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  children: [],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/*
Container(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.1,
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: [
                          Container(
                            color: Colors.yellow,
                          ),
                          Container(
                            color: Colors.pink,
                          ),
                          Container(
                            color: Colors.green,
                          )
                        ],
                        shrinkWrap: true,
                      ),
                    )
*/
Widget SystemBox({
  required TextEditingController textEditingController,
  required double screenWidth,
  required double screenHeight,
  required List<Widget> children,
}) =>
    Container(
      decoration: BoxDecoration(border: Border.all(width: 2)),
      padding: EdgeInsets.all(10),
      width: screenWidth * 0.9,
      height: (calculateRows(children.length) == 1)
          ? (screenHeight * 0.25)
          : (screenHeight * 0.22) * calculateRows(children.length),
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
                  width: screenWidth * 0.2,
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  width: screenWidth * 0.2,
                  child: TextField(
                    controller: textEditingController,
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
                  onPressed: () {},
                )
              ],
            ),
            SizedBox(width: 1),
            VerticalDivider(
              thickness: 2,
              color: Colors.black,
            ),
            SizedBox(
              width: screenWidth * 0.67,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 5,
                runSpacing: 5,
                children: children,
              ),
            )
          ],
        ),
      ),
    );

Widget PartBox({
  required TextEditingController textEditingController,
  required double screenWidth,
  required double screenHeight,
}) =>
    Container(
      decoration: BoxDecoration(border: Border.all(width: 2)),
      padding: EdgeInsets.all(5),
      height: screenHeight * 0.19,
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
              controller: textEditingController,
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
                  controller: textEditingController,
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
                  controller: textEditingController,
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
  required TextEditingController textEditingController,
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
                  controller: textEditingController,
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
                  controller: textEditingController,
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
              controller: textEditingController,
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
