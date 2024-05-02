
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/providers/weekly_report_providers/weekly_report.dart';
import 'package:flutter_complete_guide/widgets/calendar_widgets/edit_meeting_form_widget.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/checklist_model.dart';
import 'package:flutter_complete_guide/supabase/weekly_report_functions.dart';
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

  List<String> checkList=[];


  @override
  void initState(){
    _startDate=DateTime.now().subtract(Duration(days: (DateTime.now().weekday - 1)));
    _endDate=_startDate.add(Duration(days: 6));
    _initializeData();
  }

  Future<void> _initializeData() async {
    WeeklyReportProvider weeklyReportProvider=provider.Provider.of<WeeklyReportProvider>(context,listen: false);
    AppSetup appSetup = provider.Provider.of<AppSetup>(context, listen: false);

    weeklyReportProvider.setIsLoading(true);
    final Map<String, dynamic> tempFetch=await getFirstWeeklyReportFromUserAscendingByDate(appSetup.supabase_id, false);
    if(tempFetch.isNotEmpty){
      final List<WeeklyReportItemList> tempList=[] ;
      tempList.add(WeeklyReportItemList.fromMap(tempFetch));
      isAlreadyReported = isInSpecificWeek(tempList, _startDate, _endDate);
    }
    weeklyReportProvider.setIsLoading(false);

    // Check if a report exists for the current week
    // After initializing the data, call setState to rebuild the widget
    if (mounted) {
      setState(() {
        // Update the state variables based on the fetched data
        // (e.g., set isAlreadyReported, etc.)
      });
    }
  }

  void _showDialog(){
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
  void _showItemDialog(String checklistItem,int index){
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
                            'Weekly Report',
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
                            child: buildWeekDateContainer(_startDate),
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
                                      _showDialog();
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
                                    onTap: () => _showItemDialog(checkList[index],index),
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

                            WeeklyReportItemList tempItem=WeeklyReportItemList(userId: appSetup.supabase_id,start_date: _startDate,end_date: _endDate,message: feedbackText.text ==''? 'No Message' : feedbackText.text,check_list: checkList,);

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




