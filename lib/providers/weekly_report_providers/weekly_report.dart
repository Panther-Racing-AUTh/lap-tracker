import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_model.dart';
import 'package:flutter_complete_guide/names.dart';

class WeeklyReportProvider extends ChangeNotifier {
  List<WeeklyReportItem> _reports = [];

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
