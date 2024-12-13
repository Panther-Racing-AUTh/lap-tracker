
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/checklist_model.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/member_model.dart';

class FeedbackItem{
  final int id;
  final Member member;
  final String message;
  final List<ChecklistItem> checklist;


  FeedbackItem({
    required this.id,
    required this.member,
    required this.checklist,
    required this.message,
  });
}
