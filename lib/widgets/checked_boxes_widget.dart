import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/setupChange.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../models/telemetry.dart';
import '../providers/app_setup.dart';
import 'package:intl/intl.dart';

class CheckedBoxWidget extends StatefulWidget {
  final setFinalList;

  CheckedBoxWidget({Key? key, required this.setFinalList}) : super(key: key);

  var finalSelectedList = [];

  @override
  State<CheckedBoxWidget> createState() => _CheckedBoxWidgetState();
}

List<FixedExtentScrollController> hour = [];
List<FixedExtentScrollController> min = [];
List<FixedExtentScrollController> sec = [];
List<FixedExtentScrollController> mil = [];

@override
class _CheckedBoxWidgetState extends State<CheckedBoxWidget> {
  //
  //

  void initState() {
    super.initState();
    print('hello world');

    final a = Provider.of<AppSetup>(context, listen: false);

    for (int i = 0; i < 2; i++) {
      hour.add(FixedExtentScrollController(
          initialItem: int.parse(a.chartList[i].toString().substring(0, 2))));

      min.add(FixedExtentScrollController(
          initialItem: int.parse(a.chartList[i].toString().substring(3, 5))));
      sec.add(FixedExtentScrollController(
          initialItem: int.parse(a.chartList[i].toString().substring(6, 8))));
      mil.add(FixedExtentScrollController(
          initialItem:
              int.parse(a.chartList[i].toString().substring(9, null))));
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    AppSetup a = Provider.of<AppSetup>(context);
    widget.finalSelectedList = a.chartList;

    final allChecked =
        CheckBoxClass(title: 'Select All', supabaseTitle: 'select_all');

    final checkboxList = [
      CheckBoxClass(title: 'RPM', supabaseTitle: 'rpm'),
      CheckBoxClass(title: 'Oil Pressure', supabaseTitle: 'oil_pressure'),
      CheckBoxClass(
          title: 'Air Intake Pressure', supabaseTitle: 'air_intake_pressure'),
      CheckBoxClass(
          title: 'Air Intake Temperature',
          supabaseTitle: 'air_intake_temperature'),
      CheckBoxClass(
          title: 'Throttle Position', supabaseTitle: 'throttle_position'),
      CheckBoxClass(
          title: 'Fuel Temperature', supabaseTitle: 'fuel_temperature'),
    ];

    onAllClicked(CheckBoxClass ckbItem) {
      if (a.listContainsAllItems()) {
        a.setList([]);
      } else {
        a.setList(m.keys.toList());
      }
    }

///////////////////////////////////

    /*final newValue = !ckbItem.value;
      setState(
        () {
          ckbItem.value = newValue;
          checkboxList.forEach(
            (element) {
              element.value = newValue;
              if (newValue) {
                widget.finalSelectedList = [
                  'rpm',
                  'oil_pressure',
                  'air_intake_pressure',
                  'air_intake_temperature',
                  'throttle_position',
                  'fuel_temperature'
                ];
              } else {
                widget.finalSelectedList = [];
              }
            },
          );
          if (!widget.noChartAttached)
            widget.setFinalList(widget.finalSelectedList);
        },
      );
    }
      */
    onItemClicked(CheckBoxClass ckbItem) {
      String item = m.keys.firstWhere((element) => m[element] == ckbItem.title);
      if (a.listContainsItem(item)) {
        a.removeItemFromlist(item);
      } else
        a.addItemTolist(item);
      widget.setFinalList(widget.finalSelectedList);
    }

    /*
    final newValue = !ckbItem.value;
    if (!newValue) {
      widget.finalSelectedList.removeWhere((item) => item == ckbItem.title);
    }
    setState(() {
      ckbItem.value = newValue;
      var selectedList = [];

      if (!newValue) {
        allChecked.value = false;
      } else {
        final allListChecked = checkboxList.every((element) => element.value);

        allChecked.value = allListChecked;
      }
      checkboxList.forEach((item) {
        if (item.value) {
          selectedList.add(item.supabaseTitle);
          widget.finalSelectedList = selectedList;
        }
      });
      widget.setFinalList(widget.finalSelectedList);
    });
    */

    sliderChange(SfRangeValues newRange) {
      a.setTimeConstraints(newRange.start, newRange.end);
      widget.setFinalList(widget.finalSelectedList);
    }

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListTile(
          onTap: () => onAllClicked(allChecked),
          leading: Checkbox(
            value: a.listContainsAllItems(),
            onChanged: (value) => onAllClicked(allChecked),
          ),
          title: Text(allChecked.title),
        ),
        Divider(),
        ...checkboxList
            .map(
              (item) => ListTile(
                onTap: () => onItemClicked(item),
                leading: Checkbox(
                  value: a.chartList.contains(
                      m.keys.firstWhere((element) => m[element] == item.title)),
                  onChanged: (value) => onItemClicked(item),
                ),
                title: Text(item.title),
              ),
            )
            .toList(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTimeSelector(a, 0),
            SizedBox(height: 30),
            Text(
              'to',
              style: TextStyle(fontSize: 20),
            ),
            CustomTimeSelector(a, 1)
          ],
        )
      ],
    );
  }
}

class CheckBoxClass {
  String title;
  String supabaseTitle;
  bool value;

  CheckBoxClass(
      {required this.title, required this.supabaseTitle, this.value = false});
}

MyWidget(dynamic i, int index) => Container(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.5),
        child: Text(
          i.toString().padLeft(index, '0'),
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
CustomTimeSelector(AppSetup a, int index) => Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 25,
          width: 200,
          color: Colors.grey.withOpacity(0.4),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 40,
              child: ListWheelScrollView(
                controller: hour[index],
                physics: FixedExtentScrollPhysics(),
                useMagnifier: true,
                magnification: 1.2,
                children: [
                  for (int i = 0; i < 2; i++) MyWidget(i, 1),
                ],
                itemExtent: 30,
                onSelectedItemChanged: (value) {
                  a.setTimeConstraintsAuto(
                      a.chartList[index].replaceRange(1, 2, value.toString()),
                      index);
                },
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 90,
              width: 40,
              child: ListWheelScrollView(
                controller: min[index],
                useMagnifier: true,
                magnification: 1.2,
                children: [
                  for (int i = 0; i < 60; i++) MyWidget(i, 2),
                ],
                itemExtent: 30,
                physics: FixedExtentScrollPhysics(),
                onSelectedItemChanged: (value) {
                  a.setTimeConstraintsAuto(
                      a.chartList[index].replaceRange(
                        3,
                        5,
                        value.toString().padLeft(2, '0'),
                      ),
                      index);
                },
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 90,
              width: 40,
              child: ListWheelScrollView(
                controller: sec[index],
                physics: FixedExtentScrollPhysics(),
                useMagnifier: true,
                magnification: 1.2,
                children: [
                  for (int i = 0; i < 60; i++) MyWidget(i, 2),
                ],
                itemExtent: 30,
                onSelectedItemChanged: (value) {
                  a.setTimeConstraintsAuto(
                      a.chartList[index].replaceRange(
                        6,
                        8,
                        value.toString().padLeft(2, '0'),
                      ),
                      index);
                },
              ),
            ),
            SizedBox(width: 5),
            Container(
              height: 90,
              width: 40,
              child: ListWheelScrollView(
                controller: mil[index],
                physics: FixedExtentScrollPhysics(),
                useMagnifier: true,
                magnification: 1.2,
                children: [
                  for (int i = 0; i < 1000; i++) MyWidget(i, 3),
                ],
                itemExtent: 30,
                onSelectedItemChanged: (value) {
                  a.setTimeConstraintsAuto(
                      a.chartList[index].replaceRange(
                        9,
                        null,
                        value.toString().padLeft(3, '0'),
                      ),
                      index);
                },
              ),
            ),
          ],
        ),
      ],
    );
