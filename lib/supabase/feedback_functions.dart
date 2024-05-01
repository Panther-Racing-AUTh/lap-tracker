import 'dart:convert';

import 'package:flutter_complete_guide/models/feedback_models/feedback_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_model.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

final supabase = Supabase.instance.client;

Future<List> getFeedback() async {
  final List data = await supabase
      .from('feedback')
      .select('id, user, star_rate,message');
  return data;
}

Future<List<Map<String, dynamic>>> getFeedbacks() async {
  try {
    final response = await supabase.from('feedback').select().execute();



    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching weekly report data: $error');
    return []; // Return empty list if an error occurs
  }
}

Future<List<Map<String, dynamic>>> getFeedbacksAscendingById() async {
  try {
    final response = await supabase.from('feedback').select().order('id',ascending: true).execute();



    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching weekly report data: $error');
    return []; // Return empty list if an error occurs
  }
}

Future<void> saveFeedback(FeedbackModel feedbackModel) async {
  try {
    final response = await supabase.from('feedback').insert(feedbackModel.toMap()).execute();


    print('Weekly report saved successfully!');
  } catch (error) {
    print('Error saving weekly report: $error');
  }
}
