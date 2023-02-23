import 'package:flutter/material.dart';

class CheckedBoxWidget extends StatefulWidget {
  final setFinalList;

  CheckedBoxWidget({Key? key, required this.setFinalList}) : super(key: key);

  var finalSelectedList = [];

  @override
  State<CheckedBoxWidget> createState() => _CheckedBoxWidgetState();
}

class _CheckedBoxWidgetState extends State<CheckedBoxWidget> {
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
        title: 'Throttle position', supabaseTitle: 'throttle_position'),
    CheckBoxClass(title: 'Fuel Temperature', supabaseTitle: 'fuel_temperature'),
  ];

  onAllClicked(CheckBoxClass ckbItem) {
    final newValue = !ckbItem.value;
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
        widget.setFinalList(widget.finalSelectedList);
      },
    );
  }

  onItemClicked(CheckBoxClass ckbItem) {
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
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () => onAllClicked(allChecked),
          leading: Checkbox(
            value: allChecked.value,
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
                  value: item.value,
                  onChanged: (value) => onItemClicked(item),
                ),
                title: Text(item.title),
              ),
            )
            .toList()
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
