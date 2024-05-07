
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
  final List<String> todo_list;
  final List<String> future_todo_list;

  const WeeklyReportItemList({
    required this.start_date,
    required this.end_date,
    required this.message,
    required this.userId,
    required this.todo_list,
    required this.future_todo_list
  });

  Map<String, dynamic> toMap() {
    return {
      'start_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(start_date), // Format date/time as string
      'end_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(end_date),     // Format date/time as string
      'message': message,
      'user' : userId,
      'todo_list' : jsonEncode(todo_list),
      'future_todo_list' : jsonEncode(future_todo_list)
    };
  }
  factory WeeklyReportItemList.fromMap(Map<String, dynamic> map) {
    return WeeklyReportItemList(
      start_date: DateTime.parse(map['start_date'] as String),
      end_date: DateTime.parse(map['end_date'] as String),
      message: map['message'] as String,
      userId: map['user'],
      todo_list: parseStringList(map['todo_list']),
      future_todo_list: parseStringList(map['future_todo_list']),
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

  void _showMessageDetailsDialog(BuildContext context, WeeklyReportItemList itemDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Message Details',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
               Container(
                 height: MediaQuery.of(context).size.height * .6,
                 child: ListView(
                   children: [
                     _buildDetailRow('Start Time', DateFormat('dd-MM-yyyy').format(itemDate.start_date)),
                     SizedBox(height: 10,),
                     Container(height: 1.2,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                     SizedBox(height: 20.0),
                     _buildDetailRow('End Time', DateFormat('dd-MM-yyyy').format(itemDate.end_date)),
                     SizedBox(height: 10,),
                     Container(height: 1.2,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                     SizedBox(height: 20.0),
                     _buildDetailRow(
                       'Message',
                       itemDate.message.isEmpty ? 'No Message' : itemDate.message,
                     ),
                     SizedBox(height: 10,),
                     Container(height: 1.2,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                     SizedBox(height: 20.0),

                     _buildDetailRowForCheckList('Current To-Do List', itemDate.todo_list),
                     SizedBox(height: 10,),
                     Container(height: 1.2,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                     SizedBox(height: 20.0),

                     _buildDetailRowForCheckList('Future To-Do List', itemDate.future_todo_list),
                     SizedBox(height: 10,),
                     Container(height: 1.2,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                     SizedBox(height: 20.0),

                   ],
                 ),
               ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
     return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      );

  }

  Widget _buildDetailRowForCheckList(String title,List value){

      // Parse the check list string into a list of items
      List<dynamic> checkList = [];
      checkList.addAll(value);

      // Calculate the count of items in the check list
      int itemCount = checkList.length;

      // Format the check list items with count

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 8),

          for(int i=0;i<itemCount;i++)
            Text(
              '${i+1 }) ${checkList[i]}\n',
              style: TextStyle(fontSize: 16),
            ),

        ],
      );
    }


}




List<WeeklyReportItemList> WeeklyReportListItemDateListfromMap(List<Map<String, dynamic>> listMap) {
  List<WeeklyReportItemList> temp=[];
  for(int i=0;i<listMap.length;i++){
    temp.add(WeeklyReportItemList(userId: listMap[i]['user'] ,start_date: DateTime.parse(listMap[i]['start_date'] as String), end_date: DateTime.parse(listMap[i]['end_date'] as String), message: listMap[i]['message'] as String,todo_list: parseStringList(listMap[i]['todo_list']),future_todo_list: parseStringList(listMap[i]['future_todo_list'])));
  }
  return temp;
}

