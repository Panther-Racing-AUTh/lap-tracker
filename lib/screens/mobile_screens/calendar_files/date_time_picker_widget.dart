import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool isAllDay;
  final bool isStartTime;
  final TextStyle textStyle;


  DateTimePicker({
    this.margin=EdgeInsets.zero,
    this.padding=EdgeInsets.zero,
    TextStyle? textStyle,
    required this.isStartTime,
    required this.labelText,
    required this.selectedDate,
    required this.selectDate,
    required this.isAllDay
  }) : textStyle = textStyle ?? TextStyle();
  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {



  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.selectedDate),
      );
      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(picked.year, picked.month, picked.day, pickedTime.hour, pickedTime.minute);
        widget.selectDate(combinedDateTime);
      }
    }
  }

  Future<void> _selectDate(BuildContext context,TimeOfDay time) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
        DateTime combinedDateTime = DateTime(picked.year, picked.month, picked.day,time.hour,time.minute,0,0,0);
        print(combinedDateTime);
        widget.selectDate(combinedDateTime);
    }
  }


  Future<void> _selectTime(BuildContext context,DateTime date) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.selectedDate),
    );
    if (pickedTime != null) {
      DateTime combinedDateTime = DateTime(date.year,date.month,date.day,pickedTime.hour,pickedTime.minute,0,0,0);
      widget.selectDate(combinedDateTime);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.calendar_month),
            Row(
              children: [
                GestureDetector(
                    onTap: () => _selectDate(context,TimeOfDay.fromDateTime(widget.selectedDate)),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text(DateFormat.yMMMd().format(widget.selectedDate),
                          style: widget.textStyle,
                        )
                    )
                ),
                widget.isAllDay ? Container()
                    : GestureDetector(
                    onTap: () => _selectTime(context,widget.selectedDate),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text(DateFormat.jms().format(widget.selectedDate),
                        style: widget.textStyle,
                        )
                    )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  /*
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(DateFormat.yMMMd().add_jm().format(widget.selectedDate)),
            Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }
   */
}



