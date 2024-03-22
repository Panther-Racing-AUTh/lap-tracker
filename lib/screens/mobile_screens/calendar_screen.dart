
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/drawer_model.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/models/meeting_data_source_model.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/providers/meeting_provider.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/wdgets/add_meeting_form_widget.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/wdgets/show_meeting_form_widget.dart';
import 'package:intl/intl.dart';
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



class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late int viewIndex;
  late CalendarController _calendarController;
  List<CalendarResource> resourceColl = <CalendarResource>[];
  late TeamRoles selectedTeamRole;
  TeamRoles myTeamRole=TeamRoles.mechanic;



  //viewIndex=0 -> day
  //viewIndex=1 -> month
  //viewIndex=2 -> year

  @override
  void initState() {
    selectedTeamRole=TeamRoles.all;
    resourceColl.add(CalendarResource(
      displayName: 'John',
      id: '0001',
      color: Colors.red,
    ));
    final meetingProvider = Provider.of<MeetingProvider>(context, listen: false);
    print(meetingProvider.meetings.length);
    if(meetingProvider.meetings.length==0){
      _getCalendarDataSource(meetingProvider.meetings);
    }
    viewIndex = 2;
    _calendarController = CalendarController();
    super.initState();
  }


  void openCard(BuildContext context,CalendarTapDetails calendarTapDetails,List<Appointment> meetings) {
    showModalBottomSheet(

      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          shouldCloseOnMinExtent: true,

          minChildSize: 0.1,
          maxChildSize: 0.95,

          initialChildSize: 0.2,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -15,

                      child: Container(
                        height: 7,
                        width :65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListView(
                      controller: scrollController,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 0,bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: SizedBox(
                                      height: 40,
                                      width: 50,
                                      child: Icon(Icons.close, size: 26)
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.deepPurple.withOpacity(0.6)
                                  ),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    onPressed: (){

                                      setState(() {

                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Save"),
                                  )
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                label: Center(
                                  child: Text(
                                    "Add Title",
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                  ),
                                )
                              // Optionally, you can set other decoration properties here
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Text("Starts in: ${calendarTapDetails.date?.year.toString()}-${calendarTapDetails.date?.month.toString()}-${calendarTapDetails.date?.day.toString()}  ,"
                                    "${calendarTapDetails.date?.hour.toString()}:${calendarTapDetails.date?.minute.toString()}"),
                              ),

                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Text("Ends in: ${calendarTapDetails.date?.year.toString()}-${calendarTapDetails.date?.month.toString()}-${calendarTapDetails.date?.day.toString()}  ,"
                                    "${calendarTapDetails.date?.add(Duration(hours: 1)).hour.toString()}:${calendarTapDetails.date?.minute.toString()}" ),
                              ),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            );
          },
        );
      },
    );
  }
  void _showPopupMenu(BuildContext context) {
    final meetingProvider = Provider.of<MeetingProvider>(context, listen: false);

    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final double buttonWidth = button.size.width;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double dy = 150;

    showMenu<String>(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      position: RelativeRect.fromLTRB(0, dy, 0, dy),
      items: [
        PopupMenuItem<String>(
          value: 'Option 1',
          child: Container(

            height: 200, // Adjust the height as needed
            width: MediaQuery.of(context).size.width * .35, // Match the width of the button
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  TeamRoles.values.length,
                      (index) {
                    return ListTile(
                      leading: Icon(selectedTeamRole.name==TeamRoles.values[index].name ? Icons.circle : Icons.circle_outlined,color: TeamRoles.values[index].getColor(),),
                      title: Text(TeamRoles.values[index].getString()),
                      onTap: () {
                        selectedTeamRole=TeamRoles.values[index];
                        // Handle tap event if needed
                        setState(() {

                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          // Update the state if needed
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final meetingProvider = Provider.of<MeetingProvider>(context, listen: false);
    return Consumer<MeetingProvider>(
      builder: (context, value, child) {
        return  Scaffold(
          appBar: AppBar(
            title: Text('Calendar'),
          ),
          drawer: DrawerModel(context),

          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Row(

                    children: [
                      SizedBox(width: 8,),
                      MaterialButton(
                        minWidth: 30,
                        onPressed: () {
                          setState(() {
                            _showPopupMenu(context);
                          });
                        },
                        child: Icon(Icons.filter_alt,color: Colors.grey,),
                      ),
                      Spacer(),
                      MaterialButton(
                        minWidth: 30,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.purple)),
                        onPressed: () {
                          setState(() {
                            viewIndex = 0;
                            _calendarController.view = getView(viewIndex);
                          });
                        },
                        child: Text("day"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        minWidth: 30,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.purple)),
                        onPressed: () {
                          setState(() {
                            viewIndex = 1;
                            _calendarController.view = getView(viewIndex);
                          });
                        },
                        child: Text("Week"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        minWidth: 30,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.purple)),
                        onPressed: () {
                          setState(() {
                            viewIndex = 2;
                            _calendarController.view = getView(viewIndex);
                          });
                        },
                        child: Text("Month"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                      children: [
                        SfCalendar(
                          controller: _calendarController,
                          view: CalendarView.month,
                          dataSource: AppointmentDataSource(getList()),
                          allowViewNavigation: true,
                          allowDragAndDrop: true,
                          appointmentBuilder: (BuildContext context, CalendarAppointmentDetails appointmentDetails) {
                            final Appointment appointment = appointmentDetails.appointments.first;
                            if (viewIndex != 2 && viewIndex!=1 && appointment.isAllDay==false && appointment.startTime.day == appointment.endTime.day) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),

                                  color: appointment.color,
                                ),
                                child: Wrap(
                                  clipBehavior: Clip.hardEdge,
                                  children: [
                                    Center(
                                      child: Text(
                                        appointment.subject,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Spacer(),
                                    Center(
                                      child: Text(
                                          'Start Time: ${DateFormat('hh:mm a').format(appointment.startTime)}',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                          'End Time: ${DateFormat('hh:mm a').format(appointment.endTime)}',
                                          style: TextStyle(color: Colors.white)
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }else{
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: appointment.color,
                                ),
                                child: Center(
                                  child: Text(
                                    appointment.subject,
                                    style: TextStyle(color: Colors.white,fontSize: 10),
                                  ),
                                ),
                              );
                            }
                          },
                          timeSlotViewSettings: TimeSlotViewSettings(
                            timeIntervalHeight: 80, // Adjust the height of each time slot
                          ),
                          dragAndDropSettings: DragAndDropSettings(allowNavigation: true,allowScroll: true,showTimeIndicator: true,autoNavigateDelay: Duration(seconds: 3)),

                          monthViewSettings: MonthViewSettings(appointmentDisplayMode:MonthAppointmentDisplayMode.appointment),
                          allowAppointmentResize: true, // Enable resizing of appointments
                          onDragEnd: dragEnd,
                          onTap: (calendarTapDetails)  async{
                            if (viewIndex == 2) {
                              setState(() {
                                viewIndex = 0;
                                _calendarController.view = getView(viewIndex);
                              });
                            } else if (viewIndex == 0) {
                              try{
                                if (calendarTapDetails.appointments!.isNotEmpty) {
                                  final Appointment meeting = calendarTapDetails.appointments!.first;
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMeetingForm(appointment: meeting),));
                                  setState(() {

                                  });
                                }
                              }catch(e){
                                CalendarTapDetails tempCal=calendarTapDetails;
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>AddMeetingForm(calendarTapDetails: tempCal,),));
                              }
                            }
                          },
                        ),

                        myTeamRole.name==TeamRoles.mechanic.name
                            ? Positioned(
                          bottom: 16, // Adjust bottom padding as needed
                          right: 16, // Adjust right padding as needed
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddMeetingForm(calendarTapDetails: CalendarTapDetails(
                                  [], DateTime.now(), CalendarElement.appointment, CalendarResource(id: 0))),));
                            },
                            child: Icon(Icons.add),
                          ),
                        ) : Container(),
                      ]
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    dynamic appointment = appointmentDragEndDetails.appointment;
    DateTime? draggingTime = appointmentDragEndDetails.droppingTime;
    CalendarResource? sourceResource = appointmentDragEndDetails.sourceResource;
    CalendarResource? targetResource = appointmentDragEndDetails.targetResource;

    if (draggingTime != null) {
      // Calculate the nearest hour
      int nearestHour = draggingTime.hour;
      int nearestMinute =draggingTime.minute;
      if (draggingTime.minute >= 52) {
        nearestHour++;
        nearestMinute=0;
      }else if ((draggingTime.minute >= 30 && draggingTime.minute < 45) || (draggingTime.minute <= 30 && draggingTime.minute > 15)) {
        nearestMinute=30;
      }else if(draggingTime.minute <=7){
        nearestMinute=0;
      }else if((draggingTime.minute >= 45 && draggingTime.minute < 52) || (draggingTime.minute <= 45 && draggingTime.minute > 37)){
        nearestMinute=45;
      }else if((draggingTime.minute >= 15 && draggingTime.minute < 22) || (draggingTime.minute < 15 && draggingTime.minute > 7)){
        nearestMinute=15;
      }

      // Update appointment start and end times to nearest hour
      DateTime newStartTime = DateTime(
          draggingTime.year,
          draggingTime.month,
          draggingTime.day,
          nearestHour,
          nearestMinute
      );
      DateTime newEndTime = newStartTime.add(appointment.endTime.difference(appointment.startTime));

      // Ensure appointment does not cross days
      if (newEndTime.day == appointment.startTime.day) {
        setState(() {
          appointment.startTime = newStartTime;
          appointment.endTime = newEndTime;
        });
      }
    }
  }


  List<Appointment> getList(){
    final meetingProvider = Provider.of<MeetingProvider>(context, listen: false);

    if(selectedTeamRole.name==TeamRoles.all.name){
      meetingProvider.roleMeetings.clear();
      return meetingProvider.meetings;
    }else{
      meetingProvider.roleMeetings.clear();

      return meetingProvider.buildRoleMeetingList(selectedTeamRole.getColor());
    }


  }

  void _showEventDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Meeting Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(appointment.subject ?? ''),
                subtitle: Text(
                  'Start: ${appointment.startTime}\nEnd: ${appointment.endTime}',
                ),
              ),
            ],
          ),
          actions: <Widget>[
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


  CalendarView getView(int index) {
    print(index);
    if (index == 0) {
      return CalendarView.day;
    } else if (index == 1) {
      return CalendarView.week;
    } else if (index == 2) {
      return CalendarView.month;
    } else {
      return CalendarView.month;
    }
  }
  void _showAppointmentDetailsDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Appointment Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(appointment.subject ?? ''),
                subtitle: Text(
                  'Start: ${appointment.startTime}\nEnd: ${appointment.endTime}',
                ),
              ),
            ],
          ),
          actions: <Widget>[
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






void _getCalendarDataSource(List<Appointment> appoitments) {
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(today.year, today.month, today.day, 12, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  appoitments.add(
      Appointment(
        startTime: DateTime.now().add(Duration(days: 2)),
        endTime: DateTime.now().add(Duration(days: 2, hours: 1)),
        subject: 'Training',
        color: Colors.orange,

      )
  );

  appoitments.add(
      Appointment(

        startTime: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
        subject: 'Conference',
        color: Colors.green,
      )
  );
  appoitments.add(
      Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        subject: 'Meeting',
        color: Colors.blue,
      )
  );
  List<CalendarResource> resourceColl = <CalendarResource>[];
  resourceColl.add(CalendarResource(
    displayName: 'John',
    id: '0001',
    color: Colors.red,
  ));

}
