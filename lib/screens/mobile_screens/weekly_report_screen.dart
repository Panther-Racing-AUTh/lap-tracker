import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:flutter_complete_guide/widgets/calendar_widgets/edit_meeting_form_widget.dart';
import 'package:flutter_complete_guide/widgets/weekly_report_widgets/weekly_report_admin_widget.dart';
import 'package:flutter_complete_guide/widgets/weekly_report_widgets/weekly_report_member_widget.dart';
import 'package:provider/provider.dart';

class WeeklyReportScreen extends StatefulWidget {

  WeeklyReportScreen({super.key});

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  TextEditingController dialogText=TextEditingController(text: '');
  TextEditingController feedbackText=TextEditingController(text: '');

  bool isSaveable=false;
  bool isSubmitted=false;
  RacingTeamRoles role=RacingTeamRoles.category;


  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final appSetup=Provider.of<AppSetup>(context);
    print(appSetup.role);
    print(appSetup.supabase_id);


    return appSetup.role=='admin' ?
    Scaffold(
      backgroundColor: Colors.white,

        appBar: AppBar(

          centerTitle: true,
          title: Text('Weekly Report'),
          actions: [
            Padding(
              padding: EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {

                },
                child: Icon(Icons.upload),
              ),
            )
          ],
        ),
        drawer: DrawerModel(context,DrawerIndexValue.weekly_report.getInt()), 
        
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(minWidth: MediaQuery.of(context).size.width*.8,height:  MediaQuery.of(context).size.height*.3,color: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => WeeklyReportAdminWidget(),));}, child: Text('Admin',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
                SizedBox(height: 30,),
                MaterialButton(minWidth:  MediaQuery.of(context).size.width*.8,height: MediaQuery.of(context).size.height*.3,color: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => WeeklyReportMemberWidget(),));}, child: Text('Member',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),

              ],
            ),
          ),
        )
    ) : WeeklyReportMemberWidget();
  }
}
