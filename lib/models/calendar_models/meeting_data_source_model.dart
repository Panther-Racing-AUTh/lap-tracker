import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments![index] as Appointment).startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments![index] as Appointment).endTime;
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as Appointment).subject;
  }

  @override
  Color getColor(int index) {
    return (appointments![index] as Appointment).color!;
  }
}
