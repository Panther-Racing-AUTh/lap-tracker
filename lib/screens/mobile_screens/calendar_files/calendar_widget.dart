import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class ShowMeeting extends StatelessWidget {
  final Appointment meeting;

  const ShowMeeting({
    Key? key,
    required this.meeting
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListTile(
          title: Text(meeting.subject),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location: ${meeting.location}'),
              Text('Start Time: ${_formatDateTime(meeting.startTime)}'),
              Text('End Time: ${_formatDateTime(meeting.endTime)}'),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
