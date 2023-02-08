import 'package:flutter/material.dart';

class DiagramComparison extends StatefulWidget {
  @override
  State<DiagramComparison> createState() => _DiagramComparisonState();
}

String dropdownvalue = l[0];

class _DiagramComparisonState extends State<DiagramComparison> {
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.compare_arrows),
      onPressed: () {
        showDialog(
          context: context,
          builder: ((ctx) => StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  title: Text('Compare Laps'),
                  actions: [
                    Container(
                      height: 200,
                      width: 1000,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              myDropdownButton(initialValue: l[0]),
                              Text(
                                '  to  ',
                                style: TextStyle(fontSize: 18),
                              ),
                              myDropdownButton(initialValue: l[1]),
                              Text(
                                '  with parameters:',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              block(
                                'Suspension',
                                myDropdownButton(initialValue: l[2]),
                              ),
                              block(
                                'ECU Mode',
                                myDropdownButton(initialValue: l[2]),
                              ),
                              block(
                                'Brake Sensitivity',
                                myDropdownButton(initialValue: l[2]),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  DropdownButton myDropdownButton({required String initialValue}) {
    return DropdownButton(
      icon: const Icon(Icons.keyboard_arrow_down),
      items: l.map((String l) {
        return DropdownMenuItem(
          value: l,
          child: Text(l),
        );
      }).toList(),
      value: initialValue,
      onChanged: (newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
    );
  }
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
      SizedBox(width: 20),
    ],
  );
}

List<String> l = [
  'Latest Lap',
  'Lap 1',
  'Lap 2',
  'Lap 3',
];
