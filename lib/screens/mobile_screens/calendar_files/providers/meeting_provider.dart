import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingProvider extends ChangeNotifier {
  List<Appointment> _meetings = [];

  List<Appointment> _roleMeetings= [];


  List<Appointment> get meetings => _meetings; // Getter for the meetings list
  List<Appointment> get roleMeetings => _roleMeetings;

  void addMeeting(Appointment meeting) {
    meetings.add(meeting);
    notifyListeners();
  }


  void updateMeeting(Appointment meeting) {
    int index = meetings.indexWhere((existingMeeting) => existingMeeting.id == meeting.id);
    if (index != -1) {
      meetings[index] = meeting;
      notifyListeners();
    }
  }

  void removeMeeting(Appointment meeting) {
    meetings.remove(meeting);
    notifyListeners();
  }

  List<Appointment> buildRoleMeetingList(Color color){
    for(Appointment meeting in meetings){
      if(meeting.color==color){
        roleMeetings.add(meeting);
      }
    }
    return roleMeetings;
    notifyListeners();
  }

}
