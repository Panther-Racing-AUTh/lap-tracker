import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/telemetry.dart';
import '../providers/app_setup.dart';

class CheckedBoxWidget extends StatelessWidget {
  final setFinalList;

  CheckedBoxWidget({Key? key, required this.setFinalList}) : super(key: key);

  var finalSelectedList = [];

  //
  //
  var dropdownvalue = checkboxList[0];
  @override
  Widget build(BuildContext context) {
    AppSetup a = Provider.of<AppSetup>(context, listen: false);

    finalSelectedList = a.chartList;

    onAllClicked(CheckBoxClass ckbItem) {
      if (a.listContainsAllItems()) {
        a.setList([]);
      } else {
        a.setList(m.keys.toList());
        print(a.chartList);
      }
    }

///////////////////////////////////

    /*
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
      print(a.chartList);
      setFinalList(finalSelectedList);
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

    return ListView(
      //physics: NeverScrollableScrollPhysics(),
      children: [
        Consumer<AppSetup>(
          builder: (context, value, child) {
            return ListTile(
              onTap: () => onAllClicked(allChecked),
              leading: Checkbox(
                value: value.listContainsAllItems(),
                onChanged: (value) => onAllClicked(allChecked),
              ),
              title: Text(allChecked.title),
            );
          },
        ),
        Divider(),
        ...checkboxList
            .skip(1)
            .map(
              (item) => Consumer<AppSetup>(
                builder: (context, value, child) => ListTile(
                  onTap: () => onItemClicked(item),
                  leading: Checkbox(
                    value: value.listContainsItem(m.keys
                        .firstWhere((element) => m[element] == item.title)),
                    onChanged: (value) => onItemClicked(item),
                  ),
                  title: Text(item.title),
                ),
              ),
            )
            .toList(),
        Container(
          child: Text('Control X Axis variable'),
          padding: EdgeInsets.all(10),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: DropdownButton(
            alignment: Alignment.centerLeft,
            value: dropdownvalue,
            items: checkboxList
                .map((item) => DropdownMenuItem(
                      child: Text(item.title),
                      value: item,
                    ))
                .toList(),
            onChanged: (CheckBoxClass? v) {
              dropdownvalue = v!;
              if (dropdownvalue == checkboxList[0]) {
                a.setXAxis('');
              } else
                a.setXAxis(
                    m.keys.firstWhere((element) => m[element] == v.title));
            },
          ),
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

MyWidget(dynamic i, int index) => Container(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.5),
        child: Text(
          i.toString().padLeft(index, '0'),
          style: TextStyle(fontSize: 20),
        ),
      ),
    );

final allChecked =
    CheckBoxClass(title: 'Select All', supabaseTitle: 'select_all');

final checkboxList = [
  CheckBoxClass(title: 'Time', supabaseTitle: ''),
  CheckBoxClass(title: 'SUSP_FL', supabaseTitle: 'rpm'),
  CheckBoxClass(title: 'SUSP_FR', supabaseTitle: 'oil_pressure'),
  CheckBoxClass(title: 'Strai_Gauge_FR', supabaseTitle: 'air_intake_pressure'),
  CheckBoxClass(
      title: 'Strain_Gauge_FLn', supabaseTitle: 'air_intake_temperature'),
  CheckBoxClass(title: 'Vdc', supabaseTitle: 'throttle_position'),
  CheckBoxClass(title: 'APPS1_Raw', supabaseTitle: 'fuel_temperature'),
];
