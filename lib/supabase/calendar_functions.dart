import 'dart:ui';

import 'package:flutter_complete_guide/widgets/calendar_widgets/edit_meeting_form_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

final supabase = Supabase.instance.client;
Map<String, dynamic> AppointmenttoMap(Appointment appointment) {
  return {
    'appointment_id': appointment.id ,
    'start_time': DateFormat('yyyy-MM-dd HH:mm:ss').format(appointment.startTime), // Format date/time as string
    'end_time': DateFormat('yyyy-MM-dd HH:mm:ss').format(appointment.endTime),     // Format date/time as string
    'subject': appointment.subject,
    'notes' : appointment.notes==null ? 'No Notes' : appointment.notes,
    'color' : appointment.color.value.toString(),
    'is_all_day': appointment.isAllDay,
    'location' : appointment.location
  };
}
Appointment AppointmentFromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as int,
      startTime: DateTime.parse(map['start_time'] as String),
      endTime: DateTime.parse(map['end_time'] as String),
      subject: map['message'] as String,
      color: Color(int.parse(map['color'])),
      isAllDay: map['is_all_day'],
      location: map['location'],
      notes:  map['notes'],
    );
}

List<Appointment> AllAppointmentsFromMap(List<Map<String, dynamic>> mapList) {
  List<Appointment> temp=[];
  print('Niaouuuuuuuuuuuuuuuu: ${mapList.length}');
  for(int i=0;i<mapList.length;i++){
    temp.add(Appointment(
      id: mapList[i]['id'],
      startTime: DateTime.parse(mapList[i]['start_time']),
      endTime: DateTime.parse(mapList[i]['end_time']),
      subject: mapList[i]['subject'] ,
      color:  Color(int.parse(mapList[i]['color'])),
      isAllDay: mapList[i]['is_all_day'],
      location: mapList[i]['location'] ?? TeamLocation.noLocation.getString(),
      notes:  mapList[i]['notes']!=null ? mapList[i]['notes'] : "No Notes",
    )
    );
  }
  print('agouuuuuuuuuuuuuu: ${temp.length}');

  return temp;

}
Future<List<Map<String, dynamic>>> getNewAppointments(int lastId) async {
  try {
    final response = await supabase
        .from('appointment')
        .select()
        .gt('id', lastId) // Fetch items where id > lastId
        .order('id', ascending: true) // Order by id ascending
        .execute();


    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error loading new items: $error');
    return []; // Return empty list if an error occurs
  }
}

Future<List<Map<String, dynamic>>> getAppointmentsBySubject(String subject) async {
  try {
    final response = await Supabase.instance.client
        .from('appointment')
        .select()
        .eq('subject', subject)
        .execute();



    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching appointments: $error');
    return []; // Return empty list if an error occurs
  }
}

Future<List<Map<String, dynamic>>> getAppointmentsBySubjectAndStartDate(String subject, DateTime startDate) async {
  try {
    // Format the startDate
    String formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);

    final response = await Supabase.instance.client
        .from('appointment')
        .select()
        .eq('subject', subject)
        .eq('start_time', startDate)  // Assuming the start_date column is stored as a string in this format
        .execute();



    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching appointments: $error');
    return []; // Return empty list if an error occurs
  }
}

Future<List<Map<String, dynamic>>> getAppointments() async {
  try {
    final response = await supabase.from('appointment').select().execute();



    // Extract the data from the response
    final List<Map<String, dynamic>> data = (response.data as List).cast<Map<String, dynamic>>();

    return data;
  } catch (error) {
    print('Error fetching weekly report data: $error');
    return []; // Return empty list if an error occurs
  }
}
Future<void> saveAppointment(Appointment appointment) async {
  try {
    final response = await supabase.from('appointment').insert(AppointmenttoMap(appointment)).execute();


    print('Weekly report saved successfully!');
  } catch (error) {
    print('Error saving appointment: $error');
  }
}

Future<void> saveAllAppointments(List<Appointment> appointmentList) async {
  for(int i=0;i<appointmentList.length;i++){
    try {
      await supabase.from('appointment').insert(AppointmenttoMap(appointmentList[i])).execute();


      print('Weekly report saved successfully!');
    } catch (error) {
      print('Error saving appointment No.${appointmentList[i]} : $error');
    }
  }
}

Future<bool> checkId(int id) async {
  final response = await supabase
      .from('appointment')
      .select()
      .eq('id', id)
      .execute();



  return response.data != null && response.data!.length > 0;
}

Future<void> updateAppointment(Appointment appointment) async {
  try{
    final response = await supabase
        .from('appointment')
        .update(AppointmenttoMap(appointment))
        .eq('id', appointment.id)
        .execute();


    print('Appointment removed successfully: ${appointment.id}');
  } catch (error) {
    print('Error processing appointment: $error');
  }
}
Future<void> updateAppointmentBySubject(Appointment appointment) async {
  try{
    final response = await supabase
        .from('appointment')
        .update(AppointmenttoMap(appointment))
        .eq('subject', appointment.subject)
        .execute();


    print('Appointment removed successfully: ${appointment.id}');
  } catch (error) {
    print('Error processing appointment: $error');
  }
}



Future<bool> checkAppointmentExists(int appointmentId) async {
  final response = await supabase
      .from('appointment')
      .select()
      .eq('id', appointmentId)
      .execute();


  return response.data != null && response.data!.length > 0;
}

Future<void> insertAppointment(Appointment appointment) async {
  final response = await supabase
      .from('appointment')
      .insert(AppointmenttoMap(appointment))
      .execute();



  print('Appointment inserted successfully: ${appointment.subject}');
}

void insertAppointmentInBackground(Appointment appointment) {
  supabase
      .from('appointment')
      .insert(AppointmenttoMap(appointment))
      .execute()
      .then((response) {
    print('Appointment inserted successfully in the background: ${appointment.subject}');
    // Handle response if needed (this block executes asynchronously)
  }).catchError((error) {
    print('Error inserting appointment in the background: $error');
    // Handle error if needed (this block executes asynchronously)
  });
}

Future<void> checkAndInsertAppointment(Appointment appointment) async {
  try {
    final appointmentExists = await checkAppointmentExists(appointment.id as int);
  } catch (error) {
    print('Error processing appointment: $error');
  }
}
Future<void> removeAppointment(Appointment appointment) async {
   try{
    final response = await supabase
        .from('appointment')
        .delete()
        .eq('id', appointment.id)
        .eq('subject', appointment.subject)
        .execute();


    print('Appointment removed successfully: ${appointment.id}');
  } catch (error) {
  print('Error processing appointment: $error');
  }
}


Future<void>  checkAndInsertAllAppointments(List<Appointment> appointmentList) async {
  for(int i=0;i<appointmentList.length;i++){
    try {
      final appointmentExists = await checkAppointmentExists(appointmentList[i].id as int);

      if (!appointmentExists) {
        await insertAppointment(appointmentList[i]);
      } else {
        print('Appointment with ID ${appointmentList[i].id} already exists');
      }
    } catch (error) {
      print('Error processing appointment: $error');
    }
  }
}
void checkAndInsertAllAppointmentsInBackground(List<Appointment> appointmentList) {
  appointmentList.forEach((appointment) {
    checkAppointmentExists(appointment.id as int).then((appointmentExists) {
      if (!appointmentExists) {
        // Insert appointment in the background without awaiting its completion
        insertAppointmentInBackground(appointment);
      } else {
        print('Appointment with ID ${appointment.id} already exists');
      }
    }).catchError((error) {
      print('Error processing appointment: $error');
    });
  });
}
