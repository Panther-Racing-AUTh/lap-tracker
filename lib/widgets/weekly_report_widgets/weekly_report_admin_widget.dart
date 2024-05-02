
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_model.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/providers/weekly_report_providers/weekly_report.dart';
import 'package:flutter_complete_guide/supabase/chat_service.dart';
import 'package:flutter_complete_guide/widgets/calendar_widgets/edit_meeting_form_widget.dart';
import 'package:flutter_complete_guide/supabase/weekly_report_functions.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';


class WeeklyReportAdminWidget extends StatefulWidget {
  const WeeklyReportAdminWidget({super.key});

  @override
  State<WeeklyReportAdminWidget> createState() => _WeeklyReportAdminWidgetState();
}

class _WeeklyReportAdminWidgetState extends State<WeeklyReportAdminWidget> {
  TextEditingController dialogText=TextEditingController(text: '');
  TextEditingController feedbackText=TextEditingController(text: '');

  RacingTeamRoles role=RacingTeamRoles.category;

  List<dynamic> userList=[];

  List<WeeklyReportItem> checkList=[];



  @override
  void initState() {
    super.initState();
    // Call getUserList asynchronously and wait for its completion
    _loadUserList();
  }

  Future<void> _loadUserList() async {
    try {
      // Get the WeeklyReportProvider instance using Provider.of
      WeeklyReportProvider weeklyReportProvider =
      Provider.of<WeeklyReportProvider>(context, listen: false);
      weeklyReportProvider.setIsLoading(true);

      // Fetch user list asynchronously
       userList = await getUserList();


      weeklyReportProvider.reports.clear();
      for(int i=0;i<userList.length;i++){
        weeklyReportProvider.addMeeting(WeeklyReportItem.fromMap(userList[i]));
        var report_data=await getFirstWeeklyReportFromUserAscendingByDate(weeklyReportProvider.reports[i].userId,false);
        print(report_data.toString());
        weeklyReportProvider.reports[i].reportList.clear();
        if(report_data.isNotEmpty){

          weeklyReportProvider.reports[i].reportList.add(WeeklyReportItemList.fromMap(report_data));
        }
        print("Check ReportList:${weeklyReportProvider.reports[i].reportList.toString()}");
      }
      weeklyReportProvider.setIsLoading(false);


      // Once the user list is loaded, you can perform other tasks or update the UI
      // For example, setState() to trigger a rebuild if necessary

    } catch (e) {
      // Handle any errors that occur during fetching or updating the data
      print('Error loading user list: $e');
    }
  }
  Future<List<dynamic>> getUserList() async {
    // Simulate fetching user list (replace this with your actual API or database call)
    final List<dynamic> temp = await getAllUsers(); // Assuming getAllUsers() returns List<User>
    
    // Print each user for debugging



    return temp;
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

    return  Consumer<WeeklyReportProvider>(
          builder: (context, value, child) {
            final weeklyReportProvider=Provider.of<WeeklyReportProvider>(context);



            return weeklyReportProvider.isLoading ? Center(
                  child: Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()
                      )
                )
                : Scaffold(
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
                    title: Text('Weekly Report List '),
                  ),
                  body: ListView(
                      children:[

                        Container(

                          margin: EdgeInsets.only(top:1,left: 15,right: 15),
                          padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (int i=0;i<weeklyReportProvider.reports.length;i++)
                                GestureDetector(
                                    onTap: () async{
                                      var report_data=await getWeeklyReportsFromUserAscendingByDate(weeklyReportProvider.reports[i].userId,false);
                                      weeklyReportProvider.reports[i].reportList.clear();
                                      for(int j=0;j<report_data.length;j++){
                                        weeklyReportProvider.reports[i].reportList.add(WeeklyReportItemList.fromMap(report_data[j]));
                                        print("Check ReportList:${weeklyReportProvider.reports[i].reportList}");
                                      }
                                      openCard(context, weeklyReportProvider.reports[i]); // Function to open detailed card
                                    },
                                    child: buildReportItem(weeklyReportProvider.reports[i])
                                ),
                            ],
                          ),
                        ),
                      ]
                  )
            );
          },
    );
  }
  Widget buildReportItem(WeeklyReportItem item) {
    DateTime selectedDate=DateTime.now();
    DateTime monday = selectedDate.subtract(Duration(days: (selectedDate.weekday - 1)));
    DateTime sunday = monday.add(Duration(days: 6));
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      'ID:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 150,
                    child: Text(
                      '${item.userId}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Container(color: Colors.grey,width: 200,height: 1,),
              SizedBox(height: 6),

              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      'Name:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 150,
                    child: Text(
                      item.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Container(color: Colors.grey,width: 200,height: 1,),
              SizedBox(height: 6),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      'Role:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 150,
                    child: Text(
                      item.role,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          isInSpecificWeek(item.reportList, monday, sunday) ? Icon(Icons.circle,color: Colors.green,size: 25,) :  Icon(Icons.circle_outlined,color: Colors.red,size: 22,)
        ],
      ),
    );
  }

}




void openCard(BuildContext context, WeeklyReportItem details) {

  showModalBottomSheet(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height,
      maxWidth: MediaQuery.of(context).size.width,
    ),
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      final appSetup=Provider.of<AppSetup>(context);
  print("Nious:${details.userId}");

  return DraggableScrollableSheet(
        shouldCloseOnMinExtent: true,
        minChildSize: 0.0,
        maxChildSize: 0.95,
        initialChildSize: 0.3,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
            height: MediaQuery.of(context).size.height,

            child: ListView(
              controller: scrollController,
              children: [
                Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width*.3,
                  margin: EdgeInsets.only(left: 140,right:140,top: 15),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30)
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Column(
                              children: [
                                Text('Name', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text("${details.name}",style: TextStyle(fontSize: 18  ,color: Colors.black),textAlign: TextAlign.center,)
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * .1,),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Column(
                              children: [
                                Text('Role', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text("${details.role}",style: TextStyle(fontSize: 17,color: Colors.black),textAlign: TextAlign.center,))
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),

                      Center(
                        child: Column(
                          children: [
                            for (var entry in details.reportList)

                              if (entry.userId == details.userId) // Check the user name here
                                WeeklyReportItemList(
                                  userId: entry.userId,
                                  start_date: entry.start_date,
                                  end_date: entry.end_date,
                                  message: entry.message,
                                  check_list: entry.check_list,
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}





