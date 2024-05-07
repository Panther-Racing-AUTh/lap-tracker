import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/feeback_model.dart';

class FeedbackProvider1 extends ChangeNotifier {
  List<FeedbackItem> _feedbackList = [];


  List<FeedbackItem> get feedbackList => _feedbackList; // Getter for the meetings list

  void addMeeting(FeedbackItem feedbackItem) {
    feedbackList.add(feedbackItem);
    notifyListeners();
  }



  void removeMeeting(FeedbackItem feedbackItem) {
    feedbackList.remove(feedbackItem);
    notifyListeners();
  }

}
