import 'package:flutter/material.dart';
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

class _CheckedBoxWidgetState extends State<CheckedBoxWidget> {
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

    var seconds = false;
    return ListView(
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
        SfRangeSlider(
          min: DateTime(2023, 1, 1, 0, 0, 0, 0),
          max: DateTime(2023, 1, 1, 1, 0, 0, 0),
          enableTooltip: true,
          dateFormat: DateFormat.Hms(),
          dateIntervalType: DateIntervalType.seconds,
          values: SfRangeValues(a.chartList[0], a.chartList[1]),
          onChanged: (SfRangeValues newRange) => sliderChange(newRange),
        ),
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
