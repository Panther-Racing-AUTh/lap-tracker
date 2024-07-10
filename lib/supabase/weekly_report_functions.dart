import 'dart:convert';

import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

final supabase = Supabase.instance.client;

Future<List> getWeeklyReport() async {
  final List data = await supabase
      .from('appointment')
      .select('id, appointment_id, subject,start_time,end_time,notes,color,location,is_all_day');
  return data;
}

Future<List<Map<String, dynamic>>> getWeeklyReports() async {
  try {
    final response = await supabase.from('weekly_report').select().execute();



    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching weekly report data: $error');
    return []; // Return empty list if an error occurs
  }
}
Future<List<Map<String, dynamic>>> getWeeklyReportsFromUser(int user) async {
  try {
    final response = await supabase
        .from('weekly_report')
        .select()
        .eq('user', user) // Filter by user_id to fetch reports for a specific user
        .execute();

    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching weekly report data: $error');
    return []; // Return empty list if an error occurs
  }
}
Future<Map<String, dynamic>> getFirstWeeklyReportFromUserAscendingByDate(int user, bool pickStartDate) async {
  try {
    final response = await supabase
        .from('weekly_report')
        .select()
        .eq('user', user)
        .order(pickStartDate ? 'start_date' : 'end_date', ascending: false)
        .limit(1) // Limit the result to only one record
        .execute();

    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    if (data.isNotEmpty) {
      return data.first;
    } else {
      return Map(); // Return null if no data is found
    }
  } catch (error) {
    print('Error fetching first weekly report data: $error');
    return Map(); // Return null if an error occurs
  }
}


Future<List<Map<String, dynamic>>> getNumWeeklyReportsFromUserAscendingByDate(int user,bool pickStartDate,int num) async {
  try {
    final response = await supabase
        .from('weekly_report')
        .select()
        .eq('user', user).order(pickStartDate ? 'start_date' : 'end_date',ascending: false) // Filter by user_id to fetch reports for a specific user
        .limit(num)
        .execute();

    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching weekly report data: $error');
    return []; // Return empty list if an error occurs
  }
}

Future<List<Map<String, dynamic>>> getWeeklyReportsFromUserAscendingByDate(int user,bool pickStartDate) async {
  try {
    final response = await supabase
        .from('weekly_report')
        .select()
        .eq('user', user).order(pickStartDate ? 'start_date' : 'end_date',ascending: false) // Filter by user_id to fetch reports for a specific user
        .execute();

    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching weekly report data: $error');
    return []; // Return empty list if an error occurs
  }
}
Future<List<Map<String, dynamic>>> getWeeklyReportsAscendingById() async {
  try {
    final response = await supabase.from('weekly_report').select().order('id',ascending: true).execute();



    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching weekly report data: $error');
    return []; // Return empty list if an error occurs
  }
}

Future<void> saveWeeklyReport(WeeklyReportItemList weeklyReport) async {
  try {
    final response = await supabase.from('weekly_report').insert(weeklyReport.toMap()).execute();


    print('Weekly report saved successfully!');
  } catch (error) {
    print('Error saving weekly report: $error');
  }
}

List<String> parseStringList(String jsonString) {
  try {
    // Parse the JSON string into a dynamic object
    dynamic decodedJson = jsonDecode(jsonString);

    // Check if the decoded object is a List<dynamic>
    if (decodedJson is List<dynamic>) {
      // Convert each element of the list to a String
      List<String> stringList = decodedJson.map((element) => element.toString()).toList();
      return stringList;
    } else {
      // Handle case where JSON does not represent a list
      throw FormatException('Invalid JSON format: Expected a list of strings.');
    }
  } catch (e) {
    // Handle any exceptions that may occur during JSON decoding
    print('Error parsing JSON: $e');
    return []; // Return an empty list as fallback
  }
}
