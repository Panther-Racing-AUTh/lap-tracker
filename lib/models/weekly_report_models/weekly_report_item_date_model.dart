
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/checklist_model.dart';
import 'package:flutter_complete_guide/supabase/weekly_report_functions.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; // Import jsonEncode for JSON encoding

import 'package:flutter/material.dart';


class WeeklyReportItemList extends StatelessWidget {
  final DateTime start_date;
  final DateTime end_date;
  final String message;
  final int userId;
  final List<String> check_list;

  const WeeklyReportItemList({
    required this.start_date,
    required this.end_date,
    required this.message,
    required this.userId,
    required this.check_list
  });

  Map<String, dynamic> toMap() {
    return {
      'start_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(start_date), // Format date/time as string
      'end_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(end_date),     // Format date/time as string
      'message': message,
      'user' : userId,
      'check_list' : jsonEncode(check_list),
    };
  }
  factory WeeklyReportItemList.fromMap(Map<String, dynamic> map) {
    return WeeklyReportItemList(
      start_date: DateTime.parse(map['start_date'] as String),
      end_date: DateTime.parse(map['end_date'] as String),
      message: map['message'] as String,
      userId: map['user'],
      check_list: parseStringList(map['check_list']),
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showMessageDetailsDialog(context,this);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Start Time: ${formatDate(start_date)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'End Time: ${formatDate(end_date)}',
              style: TextStyle(fontSize: 18),
            ),

          ],
        ),
      ),
    );
  }
  String formatDateTime(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day-$month-$year $hour:$minute';
  }
  String formatDate(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();

    return '$day-$month-$year';
  }

  void _showMessageDetailsDialog(BuildContext context,WeeklyReportItemList itemDate) {
    // Simulated message details


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Start Time: ${itemDate.start_date}"),
              SizedBox(height: 10,),
              Text("End Time: ${itemDate.end_date}"),
              SizedBox(height: 10,),
              Text("Message: ${itemDate.message == "" ? "No Message" : itemDate.message}"),
              Text('Check List: ${itemDate.check_list}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


}




List<WeeklyReportItemList> WeeklyReportListItemDateListfromMap(List<Map<String, dynamic>> listMap) {
  List<WeeklyReportItemList> temp=[];
  for(int i=0;i<listMap.length;i++){
    temp.add(WeeklyReportItemList(userId: listMap[i]['user'] ,start_date: DateTime.parse(listMap[i]['start_date'] as String), end_date: DateTime.parse(listMap[i]['end_date'] as String), message: listMap[i]['message'] as String,check_list: parseStringList(listMap[i]['check_list']) ,));
  }
  return temp;
}

