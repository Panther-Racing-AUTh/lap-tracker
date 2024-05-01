import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_model.dart';
import 'package:flutter_complete_guide/names.dart';

class WeeklyReportProvider extends ChangeNotifier {
  List<WeeklyReportItem> _reports = [
    // WeeklyReportItem(name: 'jojos', role: "engineer", weeklyReportSubmitted: true, reportList: List.generate(0, (index) => WeeklyReportListItemDate(userId: 1, start_date: DateTime.now(), end_date: DateTime.now(), message: 'message',check_list: [],))),
    // WeeklyReportItem(name: 'bob', role: "engineer", weeklyReportSubmitted: false, reportList: List.generate(0, (index) => WeeklyReportListItemDate(userId: 1,start_date: DateTime.now(), end_date: DateTime.now(), message: 'message',check_list: []))),
    // WeeklyReportItem(name: 'karlie', role: "engineer", weeklyReportSubmitted: false, reportList: List.generate(0, (index) => WeeklyReportListItemDate(userId: 1,start_date: DateTime.now(), end_date: DateTime.now(), message: 'message',check_list: []))),
    // WeeklyReportItem(name: 'Keving', role: "engineer", weeklyReportSubmitted: false, reportList: List.generate(0, (index) => WeeklyReportListItemDate(userId: 1,start_date: DateTime.now(), end_date: DateTime.now(), message: 'message',check_list: []))),
    // WeeklyReportItem(name: 'Nora', role: "engineer", weeklyReportSubmitted: false, reportList: List.generate(0, (index) => WeeklyReportListItemDate(userId: 1,start_date: DateTime.now(), end_date: DateTime.now(), message: 'message',check_list: []))),
    // WeeklyReportItem(name: 'Katherine', role: "engineer", weeklyReportSubmitted: false, reportList: List.generate(0, (index) => WeeklyReportListItemDate(userId: 1,start_date: DateTime.now(), end_date: DateTime.now(), message: 'message',check_list: []))),
    // WeeklyReportItem(name: 'Penny', role: "engineer", weeklyReportSubmitted: false, reportList: List.generate(0, (index) => WeeklyReportListItemDate(userId: 1,start_date: DateTime.now(), end_date: DateTime.now(), message: 'message',check_list: []))),

  ];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); // Notify listeners to update the UI
  }


  int _globalId=1;



  List<WeeklyReportItem> get reports => _reports; // Getter for the meetings list
  int get globalId => _globalId;


  void addMeeting(WeeklyReportItem report) {
    reports.add(report);
    notifyListeners();
  }



  void removeMeeting(WeeklyReportItem report) {
    reports.remove(report);
    notifyListeners();
  }

  set globalId(int value) {
    _globalId = value;
    notifyListeners();
  }




}
