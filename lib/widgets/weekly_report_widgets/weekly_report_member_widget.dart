
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/providers/weekly_report_providers/weekly_report.dart';
import 'package:flutter_complete_guide/screens/google_drive/user_sheets_api.dart';
import 'package:flutter_complete_guide/widgets/calendar_widgets/edit_meeting_form_widget.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/checklist_model.dart';
import 'package:flutter_complete_guide/supabase/weekly_report_functions.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';


class WeeklyReportMemberWidget extends StatefulWidget {


  WeeklyReportMemberWidget({super.key});

  @override
  State<WeeklyReportMemberWidget> createState() => _WeeklyReportMemberWidgetState();
}

class _WeeklyReportMemberWidgetState extends State<WeeklyReportMemberWidget> {
  TextEditingController dialogText=TextEditingController(text: '');
  TextEditingController feedbackText=TextEditingController(text: '');

  bool isSaveable=false;
  bool isSubmitted=false;

  bool isAlreadyReported=false;
  RacingTeamRoles role=RacingTeamRoles.category;
  late DateTime _startDate;
  late DateTime _endDate;
  late DateTime _nowDate;

  List<String> checkList=[];
  List<String> futureCheckList=[];


  List<WeeklyReportItemList> weekList=[];





  @override
  void initState(){
    _startDate=DateTime.now().subtract(Duration(days: (DateTime.now().weekday - 1)));
    _endDate=_startDate.add(Duration(days: 6));
    _nowDate=checkDateTime();
    _initializeData();

    _initializeGSheets();



    setState(() {

    });
  }

  Future<void> _initializeGSheets() async {
    await UserSheetsApi.init(context);
    setState(() {
      // Update any state variables if necessary
    });
  }
  Future<void> _initializeWeeklist(List<WeeklyReportItemList> tempList) async {
    List<bool> checkBools=isInSpecificDay(tempList);

    print('niaouuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu     ${checkBools.toString()}');

    DateTime currentDate = DateTime.now();
    DateTime monday = currentDate.subtract(Duration(days: (currentDate.weekday - 1)));
    DateTime wednesday = currentDate.add(Duration(days: 3 - currentDate.weekday)); // Next Wednesday from the current week
    DateTime saturday = currentDate.add(Duration(days: 6 - currentDate.weekday)); // Next Saturday from the current week
    DateTime sunday = currentDate.add(Duration(days: 7 - currentDate.weekday)); // Next Sunday from the current week



    if(checkBools[0] == false){
      specificDates.add(monday);
    }
    if(checkBools[1] == false){
      specificDates.add(wednesday);
    }
    if(checkBools[2] == false){
      specificDates.add(saturday);
    }
    globalSelectedDate=specificDates.isNotEmpty ? specificDates.first : checkDateTime();

    setState(() {

    });
  }

  Future<void> _initializeData() async {
    WeeklyReportProvider weeklyReportProvider=provider.Provider.of<WeeklyReportProvider>(context,listen: false);
    AppSetup appSetup = provider.Provider.of<AppSetup>(context, listen: false);

    weeklyReportProvider.setIsLoading(true);
    final List<Map<String, dynamic>> tempFetch=await getNumWeeklyReportsFromUserAscendingByDate(appSetup.supabase_id, false,3);
    final List<WeeklyReportItemList> tempList=[] ;

    if(tempFetch.isNotEmpty){
      for(var temp in tempFetch){
        tempList.add(WeeklyReportItemList.fromMap(temp));
      }
    }
    weeklyReportProvider.setIsLoading(false);
    print("object agou");
    await _initializeWeeklist(tempList);
    isAlreadyReported = specificDates.isEmpty;

    // Check if a report exists for the current week
    // After initializing the data, call setState to rebuild the widget
    if (mounted) {
      setState(() {
        // Update the state variables based on the fetched data
        // (e.g., set isAlreadyReported, etc.)
      });
    }
  }

  void _showDialog(List<String> checkList){
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text('Enter Report No. ${checkList.length + 1}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black54),)),
        content: Container(

          height: 210,
          child: TextFormField(
            maxLines: 5,
            controller: dialogText,
            decoration: InputDecoration(
              hintText: 'Enter here...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){
                dialogText.text='';
                Navigator.pop(context);
              },
              child: Text('Close')
          ),
          TextButton(
              onPressed: (){
                if(dialogText.text!=''){
                  setState(() {
                    checkList.add( dialogText.text);
                    dialogText.text='';
                  });
                  Navigator.pop(context);
                }
              } ,
              child: Text('Save')
          )
        ],
      );
    },
    );
  }



  ////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////
  DateTime now = DateTime.now();
  DateTime? globalSelectedDate;
  List<DateTime> specificDates = [];



  Future<void> _showDateSelectionDialog() async {
    DateTime? newSelectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: specificDates.map((DateTime date) {
              return ListTile(
                title: Text(DateFormat('EEEE').format(date)),
                onTap: () {
                  Navigator.of(context).pop(date);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (newSelectedDate != null) {
      setState(() {
        globalSelectedDate = newSelectedDate;
      });
    }
  }

  DateTime checkDateTime() {
    DateTime now = DateTime.now();

    if (now.weekday == DateTime.monday ||
        now.weekday == DateTime.wednesday ||
        now.weekday == DateTime.saturday) {
      return now;
    } else if (now.weekday == DateTime.friday) {
      return now.subtract(Duration(days: 2));
    } else {
      return now.subtract(Duration(days: 1));
    }
  }

  Widget buildSpecificWeekDateContainer() {
    return GestureDetector(
      onTap: () async {
        await _showDateSelectionDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                '${DateFormat('EEEE').format(globalSelectedDate!)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              width: 130,
              child: Center(
                child: Text(
                  DateFormat('d MMM yyyy').format(globalSelectedDate!),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  ////////////////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////////////////
  //                              GSHEET
  ////////////////////////////////////////////////////////////////////////////////////////////


  void _addUser(Worksheet? userSheet) {
    final user = {
      UserFields.submit_date: DateFormat('EEEE dd/mm/yyyy').format(DateTime.now()),
      UserFields.recap_list: jsonEncode(checkList),
      UserFields.future_list: jsonEncode(futureCheckList),
      UserFields.message: feedbackText.text,
    };



    UserSheetsApi.insertUser(userSheet,user,'[${DateFormat('EEEE').format(globalSelectedDate!)}, ${DateFormat('dd/MM/yyyy').format(globalSelectedDate!)}]');
    setState(() {

    });
  }


  ////////////////////////////////////////////////////////////////////////////////////////////







  void _showItemDialog(List<String> checkList,String checklistItem,int index){
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Text('Report No. ${index+1}')
            ),
            GestureDetector(
                onTap: () {
                  checkList.remove(checklistItem);
                  setState(() {

                  });
                  Navigator.pop(context);
                },
                child: Icon(Icons.delete)
            )
          ],
        ),
        content: Container(
          height: 160,
          child: Text(checklistItem),
        ),

      );
    },
    );
  }
  int _makeId(int existingId,int newId) {
    while (existingId==newId) {
      newId++; // Increment the ID until a unique ID is found
    }

    return newId;
  }
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(

      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now().add(Duration(days: 365)),

    );

    if (picked != null) {
      setState(() {
        _startDate = picked.weekday!=1 ? picked.subtract(Duration(days: picked.weekday-1)) : picked;
        _endDate =_startDate.add(Duration(days: 6));

      });
    }
  }
  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'No date selected';
    }
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  Widget buildWeekDateContainer(DateTime selectedDate) {
    DateTime monday = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    DateTime sunday = monday.add(Duration(days: 6));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                child: Text('Start Date',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.grey.shade400),),
              ),
              SizedBox(height: 4,),
              Container(

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                width: 130,
                child: Center(
                  child: Text(
                    DateFormat('d MMM yyyy').format(monday),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

            ],
          ),
          Spacer(),
          Column(
            children: [
              Center(
                child: Text('End Date',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.grey.shade400),),
              ),
              SizedBox(height: 4,),
              Container(

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                width: 130,
                child: Center(
                  child: Text(
                    DateFormat('d MMM yyyy').format(sunday),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

            ],
          ),


        ],
      ),
    );
  }

  List<bool> isInSpecificDay(List<WeeklyReportItemList> reportList) {
    List<bool> boolVals=[false,false,false];

    if(checkDateTime().weekday == DateTime.monday){
      boolVals[1]=true;
      boolVals[2]=true;
    }else if(checkDateTime().weekday == DateTime.wednesday){
      boolVals[2]=true;
    }

    DateTime selectedDate = DateTime.now();
    DateTime before_monday = selectedDate.subtract(Duration(days: (selectedDate.weekday )));

    DateTime monday = selectedDate.subtract(Duration(days: (selectedDate.weekday - 1)));
    DateTime wednesday = selectedDate.add(Duration(days: 3 - selectedDate.weekday)); // Next Wednesday from the current week
    DateTime saturday = selectedDate.add(Duration(days: 6 - selectedDate.weekday)); // Next Saturday from the current week
    DateTime sunday = selectedDate.add(Duration(days: 7 - selectedDate.weekday)); // Next Sunday from the current week

    print(reportList);
    if (reportList.isEmpty) {
      return boolVals;
    } else if(reportList.length>=3){

      for(int i=0;i<3;i++) {
        WeeklyReportItemList tempReport = reportList[i];
        if (tempReport.start_date.isAfter(monday) &&
            tempReport.start_date.isBefore(sunday)) {
          if (tempReport.start_date.weekday == DateTime.monday) {
            boolVals[0] = true;
          } else if (tempReport.start_date.weekday == DateTime.wednesday) {
            boolVals[1] = true;
          } else if (tempReport.start_date.weekday == DateTime.saturday) {
            boolVals[2] = true;
          } else {
            boolVals[i] == false;
          }
        }
      }

    }else{
      for(int i=0;i<reportList.length;i++){
        WeeklyReportItemList tempReport = reportList[i];
        print("${reportList.length} ${DateFormat('EEEE dd/MM/yyyy').format(tempReport.start_date)}");
        print("${reportList.length} ${DateFormat('EEEE dd/MM/yyyy').format(monday)}");

        if(tempReport.start_date.isAfter(before_monday) && tempReport.start_date.isBefore(sunday)){
          print("object $i");
          if(tempReport.start_date.weekday == DateTime.monday){
            boolVals[0]=true;
          }else if(tempReport.start_date.weekday == DateTime.wednesday){
            boolVals[1]=true;
          }else if(tempReport.start_date.weekday == DateTime.saturday){
            boolVals[2]=true;
          }
        }
      }
    }
    return boolVals;
  }


  bool isInSpecificWeek(List<WeeklyReportItemList> reportList, DateTime startOfWeek, DateTime endOfWeek) {
    print(reportList);
    if(reportList.isEmpty){
      return false;
    }else{
      WeeklyReportItemList tempReport=reportList.first;
      print(tempReport.start_date.year);
      print(startOfWeek.year);

      if(tempReport.start_date.year == startOfWeek.year &&
          tempReport.start_date.month == startOfWeek.month &&
          tempReport.start_date.day == startOfWeek.day && tempReport.end_date.year == endOfWeek.year &&
          tempReport.end_date.month == endOfWeek.month &&
          tempReport.end_date.day == endOfWeek.day){
        return true;
      }else{
        return false;
      }
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    final weeklyReportProvider=provider.Provider.of<WeeklyReportProvider>(context,listen: false);
    final appSetup=provider.Provider.of<AppSetup>(context,listen: false);

    return provider.Consumer<WeeklyReportProvider>(
        builder: (context, value, child) {
          return Scaffold(
              backgroundColor: Colors.white,

              appBar: AppBar(
                forceMaterialTransparency: true,
                leading: GestureDetector(
                  child: Icon(
                      Icons.close
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                title: Text('Feedback'),
              ),
              body: weeklyReportProvider.isLoading ? Container(
                child: Center(child: CircularProgressIndicator()),
              ) :
              isAlreadyReported ?               ListView(
                  children:[
                    Image.asset('assets/feedback.png'),
                    Container(

                      margin: EdgeInsets.only(top:1,left: 15,right: 15),
                      padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0,0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'You already reported for this week!',
                            style: TextStyle(fontSize: 22.0),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 6.0),
                          Text(
                            'See you next week',
                            style: TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.0),
                          MaterialButton(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Go Back',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ),

                        ],
                      ),
                    ),

                  ]
              )

                  : isSubmitted ?
              ListView(
                  children:[
                    Image.asset('assets/feedback.png'),
                    Container(

                      margin: EdgeInsets.only(top:1,left: 15,right: 15),
                      padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0,0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Thanks for your Report!',
                            style: TextStyle(fontSize: 22.0),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 6.0),
                          Text(
                            'See you next week!',
                            style: TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.0),
                          MaterialButton(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Go Back',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ),

                        ],
                      ),
                    ),

                  ]
              )
                  : ListView(
                  children:[
                    Image.asset('assets/feedback.png'),

                    Container(

                      margin: EdgeInsets.only(top:1,left: 15,right: 15),
                      padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0,0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome ${appSetup.username}',
                            style: TextStyle(fontSize: 22.0),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Recap Report',
                            style: TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 26.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 58.0),
                            child: Container(
                            ),
                          ),

                          SizedBox(height: 26.0),
                          Container(height: 1,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                          SizedBox(height: 12.0),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: buildSpecificWeekDateContainer(),
                          ),
                          SizedBox(height: 26.0),
                          Container(height: 1,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                          SizedBox(height: 12.0),
                          Container(
                              margin:EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Weekly To-Do List',style: TextStyle(fontSize: 20),),
                                  GestureDetector(
                                    onTap: () {
                                      _showDialog(checkList);
                                    },
                                    child: Icon(Icons.add),
                                  )
                                ],
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 260,
                                padding: EdgeInsets.symmetric(vertical: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: List.generate(checkList.length, (index) => GestureDetector(
                                    onTap: () => _showItemDialog(checkList,checkList[index],index),
                                    child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Container(
                                          width: 200,
                                          child: Row(

                                            mainAxisAlignment: MainAxisAlignment.start,

                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '${index+1})',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20,),

                                              Flexible(
                                                child: Text(
                                                  '${checkList[index]}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  softWrap: true,
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  )),
                                )
                            ),
                          ),
                          SizedBox(height: 26.0),
                          Container(height: 1,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                          SizedBox(height: 12.0),
                          Container(
                              margin:EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Future To-Do List',style: TextStyle(fontSize: 20),),
                                  GestureDetector(
                                    onTap: () {
                                      _showDialog(futureCheckList);
                                    },
                                    child: Icon(Icons.add),
                                  )
                                ],
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 260,
                                padding: EdgeInsets.symmetric(vertical: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: List.generate(futureCheckList.length, (index) => GestureDetector(
                                    onTap: () => _showItemDialog(futureCheckList,checkList[index],index),
                                    child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Container(
                                          width: 200,
                                          child: Row(

                                            mainAxisAlignment: MainAxisAlignment.start,

                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '${index+1})',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20,),

                                              Flexible(
                                                child: Text(
                                                  '${futureCheckList[index]}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  softWrap: true,
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  )),
                                )
                            ),
                          ),
                          SizedBox(height: 26.0),
                          Container(height: 1,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                          SizedBox(height: 12.0),
                          Container(
                              margin:EdgeInsets.only(left: 16,bottom: 10,top: 10),
                              child: Text('Message',style: TextStyle(fontSize: 20),)
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              minLines: 10,
                              maxLines: 20,
                              controller: feedbackText,
                              decoration: InputDecoration(
                                hintText: 'Enter your feedback here...',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 18),
                      child: MaterialButton(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () {
                          // Add your feedback submission logic here
                          if(feedbackText.text=='' && checkList.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('No Feedback'),
                                duration: Duration(seconds: 2), // Optional: Set duration for SnackBar
                              ),
                            );
                            isSubmitted=false;
                          }else{
                            isSubmitted=true;
                            _addUser(UserSheetsApi.userSheet);
                            WeeklyReportItemList tempItem=WeeklyReportItemList(userId: appSetup.supabase_id,start_date: globalSelectedDate!,end_date: globalSelectedDate!,message: feedbackText.text ==''? 'No Message' : feedbackText.text,todo_list: checkList,future_todo_list: futureCheckList,);

                            saveWeeklyReport(tempItem);
                          }
                          setState(() {

                          });

                        },
                        child: Text('Submit Feedback',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ]
              )
          );

        },
    );
  }
}




