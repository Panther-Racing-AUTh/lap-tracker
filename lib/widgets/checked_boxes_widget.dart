import 'package:flutter/material.dart';

class CheckedBoxWidget extends StatefulWidget {
  final setFinalList;

  CheckedBoxWidget({Key? key, required this.setFinalList}) : super(key: key);

  var finalSelectedList = [];

  @override
  State<CheckedBoxWidget> createState() => _CheckedBoxWidgetState();
}

class _CheckedBoxWidgetState extends State<CheckedBoxWidget> {
  final allChecked = CheckBoxClass(title: 'Select All');

  final checkboxList = [
    CheckBoxClass(title: 'RPM'),
    CheckBoxClass(title: 'Oil Pressure'),
    CheckBoxClass(title: 'Air Intake Pressure'),
    CheckBoxClass(title: 'Air Intake Temperature'),
    CheckBoxClass(title: 'Throttle Position'),
    CheckBoxClass(title: 'Fuel Temperature'),
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
                'RPM',
                'Oil Pressure',
                'Air Intake Pressure',
                'Air Intake Temperature',
                'Throttle Position',
                'Fuel Temperature'
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
          selectedList.add(item.title);
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
  bool value;

  CheckBoxClass({required this.title, this.value = false});
}
