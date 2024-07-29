import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:flutter_complete_guide/providers/calendar_providers/appointment.dart';
import 'package:flutter_complete_guide/widgets/calendar_widgets/edit_meeting_form_widget.dart';
import 'package:flutter_complete_guide/supabase/calendar_functions.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:intl/intl.dart';
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
            icon:Icon(Icons.edit),
            onPressed: () {
              setState(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EditMeetingForm(appointment: widget.appointment)),
                ).then((value) => setState(() {}));
              });
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

class ShowMeetingFormToolkit extends StatefulWidget {
  final Appointment appointment;

  const ShowMeetingFormToolkit({required this.appointment, Key? key}) : super(key: key);

  @override
  State<ShowMeetingFormToolkit> createState() => _ShowMeetingFormToolkitState();
}

class _ShowMeetingFormToolkitState extends State<ShowMeetingFormToolkit> {
  String? selectedOption;
  late ChecklistWidget _checklistWidget;

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
  void initState() {
    super.initState();
    try {
      var checklist = jsonDecode(widget.appointment.notes!);
      _checklistWidget = ChecklistWidget(checklist: checklist);
    } catch (e) {
      _checklistWidget = ChecklistWidget(checklist: []);
    }
  }

  void _updateAppointment() {
    var updatedChecklist = _checklistWidget.checklist;
    var tempNotes = jsonEncode(updatedChecklist);
    Appointment editMeeting = Appointment(
      id: widget.appointment.id,
      startTime: widget.appointment.startTime,
      endTime: widget.appointment.endTime,
      subject: "Toolkit",
      color: widget.appointment.color,
      isAllDay: true,
      notes: tempNotes,
      location: widget.appointment.location,
    );
    updateAppointment(editMeeting);
    // Implement update logic
  }

  String formatDate(DateTime dateTime) {
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toolkit Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _updateAppointment();
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showPopupMenu(context, widget.appointment);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              icon: Icons.subject,
              title: 'Subject',
              content: widget.appointment.subject,
            ),
            Divider(height: 32, color: Colors.grey[300]),
            _buildInfoRow(
              icon: Icons.access_time,
              title: 'Start Time',
              content: formatDate(widget.appointment.startTime),
            ),
            SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.access_time_filled,
              title: 'End Time',
              content: formatDate(widget.appointment.endTime),
            ),
            SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.notes,
              title: 'Notes',
              contentWidget: _checklistWidget,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    String? content,
    Widget? contentWidget,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.purple, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                content != null
                    ? Text(
                  content,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                )
                    : contentWidget!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChecklistWidget extends StatefulWidget {
  final List<dynamic> checklist;

  const ChecklistWidget({required this.checklist, Key? key}) : super(key: key);

  @override
  _ChecklistWidgetState createState() => _ChecklistWidgetState();
}

class _ChecklistWidgetState extends State<ChecklistWidget> {
  @override
  void initState() {
    super.initState();
  }

  void _toggleCheckbox(int index) {
    setState(() {
      widget.checklist[index]['completed'] = !widget.checklist[index]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.checklist.length,
      itemBuilder: (context, index) {
        var item = widget.checklist[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              item['task'],
              style: TextStyle(
                decoration: item['completed'] ? TextDecoration.lineThrough : TextDecoration.none,
                color: item['completed'] ? Colors.grey : Colors.black,
              ),
            ),
            trailing: Checkbox(
              activeColor: Colors.purple,
              checkColor: Colors.white,
              value: item['completed'],
              onChanged: (bool? value) {
                _toggleCheckbox(index);
              },
            ),
          ),
        );
      },
    );
  }
}
