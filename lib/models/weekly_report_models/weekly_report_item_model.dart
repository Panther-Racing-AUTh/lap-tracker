import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';

class WeeklyReportItem extends StatelessWidget {
  final int userId;
  final String name;
  final String role;
  final bool weeklyReportSubmitted;
  final List<WeeklyReportListItemDate> reportList;

  const WeeklyReportItem({
    required this.userId,
    required this.name,
    required this.role,
    required this.weeklyReportSubmitted,
    required this.reportList
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'report_list': reportList,
    };
  }
  factory WeeklyReportItem.fromMap(Map<String, dynamic> map) {
    // Extract data from the map and initialize WeeklyReportListItemDate list
    List<WeeklyReportListItemDate> reportList = [];
    if (map.containsKey('reportList') && map['reportList'] is List) {
      reportList = (map['reportList'] as List)
          .map((item) => WeeklyReportListItemDate.fromMap(item))
          .toList();
    }

    return WeeklyReportItem(
      userId: map['id'],
      name: map['full_name'] ?? '',
      role: map['role'] ?? '',
      weeklyReportSubmitted: map['weeklyReportSubmitted'] ?? false,
      reportList: reportList ?? [],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: $name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Role: $role',
                style: TextStyle(fontSize: 16),
              ),

            ],
          ),
          Spacer(),
          weeklyReportSubmitted ? Icon(Icons.circle,color: Colors.green.shade400,) : Icon(Icons.circle_outlined,color: Colors.grey),

        ],
      ),
    );
  }
}
