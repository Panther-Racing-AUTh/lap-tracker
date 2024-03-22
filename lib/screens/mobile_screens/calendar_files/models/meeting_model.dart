import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/wdgets/edit_meeting_form_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Meeting {
  final Object? id;
  final String subject;
  final String notes;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final TeamLocation teamLocation;
  final TeamRoles teamRoles;

  Meeting({
    this.id,
    required this.subject,
    required this.notes,
    required this.teamRoles,
    required this.isAllDay,
    required this.startTime,
    required this.endTime,
    required this.teamLocation,
  });

  factory Meeting.training() {
    return Meeting(
      subject: 'Training',
      startTime: DateTime.now().add(Duration(days: 2)),
      endTime: DateTime.now().add(Duration(days: 2, hours: 1)),
      teamLocation: TeamLocation.noLocation,
      teamRoles: TeamRoles.all,
      notes: '',
      isAllDay: false
    );
  }

  factory Meeting.conference() {
    return Meeting(
      subject: 'Conference',
      startTime: DateTime.now().add(Duration(days: 1)),
      endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
      teamLocation: TeamLocation.noLocation,
      teamRoles: TeamRoles.all,
      notes: '',
      isAllDay: false
    );
  }

  factory Meeting.meeting() {
    return Meeting(
      subject: 'Meeting',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 1)),
      teamLocation: TeamLocation.noLocation,
      teamRoles: TeamRoles.all,
      notes: '',
      isAllDay: false
    );
  }
}
