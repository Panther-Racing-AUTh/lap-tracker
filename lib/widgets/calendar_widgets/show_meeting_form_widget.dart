import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/calendar_providers/appointment.dart';
import 'package:flutter_complete_guide/widgets/calendar_widgets/edit_meeting_form_widget.dart';
import 'package:flutter_complete_guide/supabase/calendar_functions.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShowMeetingForm extends StatefulWidget {
  final Appointment appointment;

  const ShowMeetingForm({required this.appointment, Key? key}) : super(key: key);

  @override
  State<ShowMeetingForm> createState() => _ShowMeetingFormState();
}

class _ShowMeetingFormState extends State<ShowMeetingForm> {
  String? selectedOption;

  void _showPopupMenu(BuildContext context, Appointment selectedAppointment) {
    final meetingProvider = Provider.of<MeetingProvider>(context, listen: false);

    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final double buttonWidth = button.size.width;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double dx = screenWidth;
    final double dy = 100;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      items: [
        PopupMenuItem<String>(
          value: 'Option 1',
          onTap: () {
            meetingProvider.meetings.remove(selectedAppointment);
            removeAppointment(selectedAppointment);
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedOption = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EditMeetingForm(appointment: widget.appointment)),
              ).then((value) => setState(() {}));
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showPopupMenu(context, widget.appointment);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.appointment.subject,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Start Time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '${widget.appointment.startTime}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'End Time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '${widget.appointment.endTime}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Notes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.appointment.notes!,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
