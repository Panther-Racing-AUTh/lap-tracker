
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/providers/meeting_provider.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/wdgets/edit_meeting_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShowMeetingForm extends StatefulWidget {
  final Appointment appointment;

  const ShowMeetingForm({required this.appointment,super.key});

  @override
  State<ShowMeetingForm> createState() => _ShowMeetingFormState();
}

class _ShowMeetingFormState extends State<ShowMeetingForm> {
  String? selectedOption;




  void _showPopupMenu(BuildContext context,Appointment selectedAppointment) {
    final meetingProvider = Provider.of<MeetingProvider>(context, listen: false);

    late bool getBool;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final double buttonWidth = button.size.width;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double dx = screenWidth ;
    final double dy = 100;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      items: [
        PopupMenuItem<String>(

          value: 'Option 1',
          onTap: () {
              meetingProvider.meetings.remove(selectedAppointment);
              setState(() {

              });
              Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(Icons.delete,color: Colors.red,),
              Text('Delete')
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
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditMeetingForm(appointment: widget.appointment),)).then((value) => setState(() {

                }));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                child: Icon(Icons.edit)
            ),
          ),
          GestureDetector(
            onTap: () {
              _showPopupMenu(context,widget.appointment);
              setState(() {

              });
            },
            child: Container(
              padding: EdgeInsets.all(20),
                child: Icon(Icons.more_vert)
            ),
          ),
        ],
        leading: GestureDetector(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.close)
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject: ${widget.appointment.subject}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Start Time: ${widget.appointment.startTime}'),
            SizedBox(height: 10),
            Text('End Time: ${widget.appointment.endTime}'),
            SizedBox(height: 10),
            Text('Notes: ${widget.appointment.notes}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}

