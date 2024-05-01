import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/feedback_models/feedback_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class FeedbackProvider1 extends ChangeNotifier {
  List<FeedbackModel> _feedbacks = [];
  double star_rating=0.0;



  List<FeedbackModel> get feedbacks => _feedbacks; // Getter for the meetings list


  void updateRatingValue(double value){
    star_rating=value;
    notifyListeners();
  }

  void addFeedback(FeedbackModel feedback) {
    _feedbacks.add(feedback);
    notifyListeners();
  }




}
