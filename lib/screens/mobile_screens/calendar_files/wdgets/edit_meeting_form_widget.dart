
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/date_time_picker_widget.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/providers/meeting_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

enum RepeatOption {
  noRepeat,
  daily,
  weekly,
  monthly,
  yearly,
}

enum TeamRoles {
  all,
  rider,
  mechanic,
  chiefMechanic,
  suspensionSpecialist,
  engineSpecialist,
  electronicsSpecialist,
  logistics,
  management,
  sponsors,
  marketing,
  events,
}

enum TeamLocation {
  noLocation,
  workshop,
  garage,
  office,
  track,
  showroom,
  warehouse,
  headquarters,
  dealership,
  trainingFacility,
}

extension TeamRolesExtension on TeamRoles{
  String getString() {
    switch (this) {
      case TeamRoles.all:
        return 'All Team';
      case TeamRoles.rider:
        return 'Rider';
      case TeamRoles.mechanic:
        return 'Mechanic';
      case TeamRoles.chiefMechanic:
        return 'Chief Mechanic';
      case TeamRoles.suspensionSpecialist:
        return 'Suspension Specialist';
      case TeamRoles.engineSpecialist:
        return 'Engine Specialist';
      case TeamRoles.electronicsSpecialist:
        return 'Electronics Specialist';
      case TeamRoles.logistics:
        return 'Logistics';
      case TeamRoles.management:
        return 'Managment';
      case TeamRoles.sponsors:
        return 'Sponsors';
      case TeamRoles.marketing:
        return 'Marketing';
      case TeamRoles.events:
        return 'Events';


    }
  }
  Color getColor() {
    switch (this) {
      case TeamRoles.all:
        return Colors.blue;
      case TeamRoles.rider:
        return Colors.orange;
      case TeamRoles.mechanic:
        return Colors.brown;
      case TeamRoles.chiefMechanic:
        return Colors.grey;
      case TeamRoles.suspensionSpecialist:
        return Colors.green;
      case TeamRoles.engineSpecialist:
        return Colors.purple;
      case TeamRoles.electronicsSpecialist:
        return Colors.yellow;
      case TeamRoles.logistics:
        return Colors.lightBlueAccent;
      case TeamRoles.management:
        return Colors.pink;
      case TeamRoles.sponsors:
        return Colors.amber;
      case TeamRoles.marketing:
        return Colors.cyan;
      case TeamRoles.events:
        return Colors.teal;


    }
  }




}

extension TeamLocationExtension on TeamLocation {
  String getString() {
    switch (this) {
      case TeamLocation.noLocation:
        return 'No Location';
      case TeamLocation.workshop:
        return 'Workshop';
      case TeamLocation.garage:
        return 'Garage';
      case TeamLocation.office:
        return 'Office';
      case TeamLocation.track:
        return 'Track';
      case TeamLocation.showroom:
        return 'Showroom';
      case TeamLocation.warehouse:
        return 'Warehouse';
      case TeamLocation.headquarters:
        return 'Headquarters';
      case TeamLocation.dealership:
        return 'Dealership';
      case TeamLocation.trainingFacility:
        return 'Training Facility';
    }

  }




}

extension RepeatOptionsExtension on RepeatOption{
  String getString(){
    switch (this) {
      case RepeatOption.noRepeat:
        print('No Repeat');
        return 'No Repeat';
        break;
      case RepeatOption.daily:
        print('Repeat Daily');
        return 'Repeat Daily';
        break;
      case RepeatOption.weekly:
        print('Repeat Weekly');
        return 'Repeat Weekly';
        break;
      case RepeatOption.monthly:
        print('Repeat Monthly');
        return 'Repeat Monthly';
        break;
      case RepeatOption.yearly:
        print('Repeat Yearly');
        return 'Repeat Yearly';
        break;
    }
  }
}



class EditMeetingForm extends StatefulWidget {
  Appointment appointment;

  EditMeetingForm({super.key, required this.appointment});


  @override
  _EditMeetingFormState createState() => _EditMeetingFormState();
}

class _EditMeetingFormState extends State<EditMeetingForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController=TextEditingController(text: widget.appointment.subject=='No Title' ? '':widget.appointment.subject);
  late TextEditingController notesController=TextEditingController(text: widget.appointment.notes);

  late DateTime _startTime;
  late DateTime _endTime;
  late RepeatOption selectedRepeatOption;
  late TeamLocation selectedTeamLocation;
  late TeamRoles selectedRole;
  late bool isAllDay;

  @override
  void initState() {
    super.initState();
    isAllDay=widget.appointment.isAllDay;
    selectedRole=getTeamRolesFromString(widget.appointment.color!);
    selectedTeamLocation =getTeamLocationFromString(widget.appointment.location!);
    selectedRepeatOption=RepeatOption.noRepeat;
    // Initialize start time and end time with current date and time
    _startTime = widget.appointment.startTime;
    _endTime = widget.appointment.endTime;
  }



  TeamLocation getTeamLocationFromString(String locationString) {
    return TeamLocation.values.firstWhere(
          (element) => element.getString() == locationString,
      orElse: () => TeamLocation.noLocation, // Provide a default value or handle the case where no match is found
    );
  }
  TeamRoles getTeamRolesFromString(Color roleString) {
    return TeamRoles.values.firstWhere(
          (element) => element.getColor() == roleString,
      orElse: () => TeamRoles.all, // Provide a default value or handle the case where no match is found
    );
  }

  RepeatOption getRepeatOptionFromString(String repeatString) {
    return RepeatOption.values.firstWhere(
          (element) => element.getString() == repeatString,
      orElse: () => RepeatOption.noRepeat, // Provide a default value or handle the case where no match is found
    );
  }

  void _showRepeatOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Repeat Option'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: RepeatOption.values.length,
              itemBuilder: (BuildContext context, int index) {
                RepeatOption option = RepeatOption.values[index];
                return ListTile(
                  leading: index== selectedRepeatOption.index ? Icon(Icons.circle,color: Colors.purple.shade600,size: 24,) : Icon(Icons.circle_outlined,color: Colors.purple.shade800,size: 20) ,
                  title: Text(option.getString()),
                  onTap: () {
                    setState(() {
                      selectedRepeatOption=option;
                      print(selectedRepeatOption);
                    });
                    Navigator.pop(context);

                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showRolesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Location'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: TeamRoles.values.length,
              itemBuilder: (BuildContext context, int index) {
                TeamRoles option = TeamRoles.values[index];
                return ListTile(
                  leading: index== selectedRole.index ? Icon(Icons.circle,color: option.getColor(),size: 24,) : Icon(Icons.circle_outlined,color: option.getColor(),size: 20) ,
                  title: Text(option.getString()),
                  onTap: () {
                    setState(() {
                      selectedRole=option;
                      print(selectedRepeatOption);
                    });
                    Navigator.pop(context);

                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showTeamLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Location'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: TeamLocation.values.length,
              itemBuilder: (BuildContext context, int index) {
                TeamLocation option = TeamLocation.values[index];
                return ListTile(
                  leading: index== selectedTeamLocation.index ? Icon(Icons.circle,color: Colors.purple.shade600,size: 24,) : Icon(Icons.circle_outlined,color: Colors.purple.shade800,size: 20) ,
                  title: Text(option.getString()),
                  onTap: () {
                    setState(() {
                      selectedTeamLocation=option;
                      print(selectedRepeatOption);
                    });
                    Navigator.pop(context);

                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          MaterialButton(
            minWidth: 140,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            color: Colors.purple.shade700,
            onPressed: (){
              final meetingProvider = Provider.of<MeetingProvider>(context, listen: false);

              if (_formKey.currentState!.validate()) {
                // Save the meeting and close the form
                Appointment editMeeting = Appointment(
                    startTime: _startTime,
                    endTime: _endTime,
                    subject: titleController.text=='' ? "No Title" : titleController.text,
                    color: selectedRole.getColor(),
                    isAllDay: isAllDay,
                    notes: notesController.text,
                    location: selectedTeamLocation.getString(),
                    resourceIds: <Object>['0001']

                  // Add other properties as needed
                );

                meetingProvider.meetings[meetingProvider.meetings.indexOf(widget.appointment)]=editMeeting;
                // You can handle saving the meeting to a list or database here
                setState(() {

                });
                Navigator.pop(context);
              }
            },
            child: Text(
              "Save",
              style: TextStyle(
                  color: Colors.white
              ),

            ),
          ),
          SizedBox(width: 10,)
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
      body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLines: null,
                      controller: titleController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Center(
                            child: Text(
                              "Add A Subject",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          )
                        // Optionally, you can set other decoration properties here
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      color: Colors.grey.withOpacity(0.4),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),



                    DateTimePicker(
                      isStartTime: true,
                      isAllDay: isAllDay,
                      labelText: 'Start Time',
                      textStyle: TextStyle(fontSize: 17),
                      selectedDate: _startTime,
                      selectDate: (DateTime date) {
                        setState(() {
                          _startTime = date;
                        });
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    DateTimePicker(
                      isStartTime: false,
                      isAllDay: isAllDay,
                      labelText: 'End Time',
                      textStyle: TextStyle(fontSize: 17),
                      selectedDate: _endTime,
                      selectDate: (DateTime date) {
                        setState(() {
                          if(_startTime.isBefore(date)){
                            _endTime = date;
                          }else{
                            _endTime=_startTime.add(Duration(hours: 1));

                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .1,
                            child:  const Icon(
                              Icons.access_time,
                              size: 28,

                            ),

                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width * .62,
                            child: const Text(
                              "All Day",
                              style: TextStyle(
                                  fontSize: 17
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * .2,
                            child: Switch(
                              value: isAllDay,
                              onChanged: (value) {
                                setState(() {
                                  isAllDay=value;
                                });
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .1,
                            child:  const Icon(
                              Icons.rotate_right,
                              size: 28,
                            ),

                          ),
                          Container(
                              padding: const EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width * .82,
                              child: GestureDetector(
                                onTap: () {
                                  _showRepeatOptionDialog(context);
                                },
                                child: Text(
                                  selectedRepeatOption.getString(),
                                  style: const TextStyle(
                                      fontSize: 17
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      color: Colors.grey.withOpacity(0.4),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .1,
                            child:  Icon(
                              selectedTeamLocation.index==0 ? Icons.location_off_sharp: Icons.location_on_sharp,
                              size: 28,
                            ),

                          ),
                          Container(
                              padding: const EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width * .82,
                              child: GestureDetector(
                                onTap: () {
                                  _showTeamLocationDialog(context);
                                },
                                child: Text(
                                  "${selectedTeamLocation.getString()}",
                                  style: TextStyle(
                                      fontSize: 17
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      color: Colors.grey.withOpacity(0.4),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .1,
                            child:  Icon(
                              Icons.circle,
                              color: selectedRole.getColor(),
                              size: 28,
                            ),

                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width * .82,
                              child: GestureDetector(
                                onTap: () {
                                  _showRolesDialog(context);
                                },
                                child: Text(
                                  "${selectedRole.getString()}",
                                  style: TextStyle(
                                      fontSize: 17
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),


                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      color: Colors.grey.withOpacity(0.4),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .1,
                            child:  Icon(
                              Icons.notes,
                              size: 28,
                            ),

                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .82,

                            child: Container(
                              child: TextFormField(

                                maxLines: null,
                                controller: notesController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Center(
                                      child: Text(
                                        "Add Notes",
                                        style: TextStyle(
                                            fontSize: 15
                                        ),
                                      ),
                                    )
                                  // Optionally, you can set other decoration properties here
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}


