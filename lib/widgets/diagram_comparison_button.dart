import 'package:flutter/material.dart';

String lap1 = laps[0];
String lap2 = laps[1];
String ECUMode = ECUModes[0];
String suspensionMode = suspensionModes[0];
String brakeMode = brakeModes[0];
bool lap = true;

IconButton DiagramComparison(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.compare_arrows),
    onPressed: () {
      showDialog(
        context: context,
        builder: ((ctx) => StatefulBuilder(
              builder: (context, setState) {
                //
                DropdownButton<String> myDropdownButton(
                    {required String value, required List<String> list}) {
                  return DropdownButton<String>(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    value: value,
                    onChanged: (newValue) {
                      setState(() {
                        if (value == lap1) lap1 = newValue!;
                        if (value == lap1 && value == lap2) {
                          showDialog(
                              context: context,
                              builder: ((context) => AlertDialog(
                                    title: Text('Cannot compare same lap!'),
                                  )));
                        } else if (value == lap2) lap2 = newValue!;
                        if (value == ECUMode) ECUMode = newValue!;
                        if (value == suspensionMode) suspensionMode = newValue!;
                        if (value == brakeMode) brakeMode = newValue!;
                      });
                    },
                    items: list.map((String list) {
                      return DropdownMenuItem<String>(
                        value: list,
                        child: Text(list),
                      );
                    }).toList(),
                  );
                }

                //
                return AlertDialog(
                  title: TextButton(
                    child: Text(
                      lap ? 'Compare Laps' : 'Compare Setups',
                      style: TextStyle(fontSize: 22),
                    ),
                    onPressed: () => setState(() {
                      lap = !lap;
                    }),
                  ),
                  content: Container(
                    height: lap ? 100 : 400,
                    width: lap ? 400 : 600,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: lap
                              ? [
                                  myDropdownButton(value: lap1, list: laps),
                                  Text(
                                    '  to  ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  myDropdownButton(value: lap2, list: laps),
                                ]
                              : [
                                  myDropdownButton(value: lap1, list: laps),
                                  Text(
                                    '  with parameters:',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                        ),
                        SizedBox(height: 15),
                        if (!lap)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              block(
                                'Suspension Mode',
                                myDropdownButton(
                                  value: suspensionMode,
                                  list: suspensionModes,
                                ),
                              ),
                              block(
                                'ECU Mode',
                                myDropdownButton(
                                  value: ECUMode,
                                  list: ECUModes,
                                ),
                              ),
                              block(
                                'Brake Mode',
                                myDropdownButton(
                                  value: brakeMode,
                                  list: brakeModes,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                        onPressed: (() => setState(
                              () {
                                Navigator.of(context).pop();
                              },
                            )),
                        child: Text(
                          'OK',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                );
              },
            )),
      );
    },
  );
}

Row block(String text, DropdownButton dropdownButton) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '$text:  ',
        style: TextStyle(fontSize: 18),
      ),
      dropdownButton,
    ],
  );
}

List<String> laps = [
  'Last Lap',
  'Lap 1',
  'Lap 2',
  'Lap 3',
];

List<String> suspensionModes = [
  'Suspension Mode 1',
  'Suspension Mode 2',
  'Suspension Mode 3',
];

List<String> ECUModes = [
  'ECU Mode 1',
  'ECU Mode 2',
  'ECU Mode 3',
];

List<String> brakeModes = [
  'Brake Mode 1',
  'Brake Mode 2',
  'Brake Mode 3',
];
