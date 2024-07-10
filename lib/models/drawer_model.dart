
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/icon__panther_icons.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/about_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/admin_panel_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/chart_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/chat_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/data_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/expenses_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/feedback_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/main_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/motostudent_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/pre_release_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/profile_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/settings_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/timeline_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_screen.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';


enum DrawerIndexValue{
  home,
  profile,
  data,
  chat,
  calendar,
  chart,
  expenses,
  settings,
  admin,
  feedback,
  about,
  weekly_report,
  timeline,
  motostudent
}

extension DrawerIndexValueExtension on DrawerIndexValue{
  int getInt() {
    switch (this) {
      case DrawerIndexValue.home:
        return 0;
      case DrawerIndexValue.data:
        return 1;
      case DrawerIndexValue.chat:
        return 2;
      case DrawerIndexValue.calendar:
        return 3;
      case DrawerIndexValue.chart:
        return 4;
      case DrawerIndexValue.settings:
        return 5;
      case DrawerIndexValue.admin:
        return 6;
      case DrawerIndexValue.feedback:
        return 7;
      case DrawerIndexValue.about:
        return 8;
      case DrawerIndexValue.profile:
        return 9;
      case DrawerIndexValue.expenses:
        return 10;
      case DrawerIndexValue.weekly_report:
        return 11;
      case DrawerIndexValue.timeline:
        return 12;
      case DrawerIndexValue.motostudent:
        return 13;
    }
  }
  String getString() {
    switch (this) {
      case DrawerIndexValue.home:
        return 'Home';
      case DrawerIndexValue.data:
        return 'Data';
      case DrawerIndexValue.chat:
        return 'Chat';
      case DrawerIndexValue.calendar:
        return 'Calendar';
      case DrawerIndexValue.chart:
        return 'Chart';
      case DrawerIndexValue.settings:
        return 'Settings';
      case DrawerIndexValue.admin:
        return 'Admin';
      case DrawerIndexValue.feedback:
        return 'Feedback';
      case DrawerIndexValue.about:
        return 'About';
      case DrawerIndexValue.profile:
        return 'Profile';
      case DrawerIndexValue.expenses:
        return 'Expenses';
      case DrawerIndexValue.weekly_report:
        return 'Weekly Report';
      case DrawerIndexValue.timeline:
        return 'Timeline';
      case DrawerIndexValue.motostudent:
        return 'MotoStudent';
    }
  }
}

Widget DrawerModel(BuildContext context,int index){
  AppSetup appSetup = Provider.of<AppSetup>(context);


  if(appSetup.role=='admin' || appSetup.role=='chief_engineer' ){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if(index==DrawerIndexValue.home.getInt()){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
                          }else{
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
                          }
                        },
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade300.withOpacity(0.5),
                            child: Image.asset('assets/panther_logo_transparent-2.png',errorBuilder: (context, error, stackTrace) => Icon(Icons.add_a_photo,size: 40,),)
                        ),
                      ),
                      Spacer(),
                      Text(appSetup.username,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
                    ],
                  )
              )
          ),
          /*
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black45
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.purple
                    ),
                  ),
                  onPressed: (){}
              ),
              MaterialButton(
                  minWidth: 150,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.purple
                    ),
                  ),
                  onPressed: (){}
              ),
            ],
          ),
        ),
         */
          Container(
              margin: EdgeInsets.only(left: 25,top: 20,bottom: 2),
              child: Text(
                'Main',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    leading: Icon(Icons.home,color: index==DrawerIndexValue.home.getInt() ? Colors.purple: Colors.black,),
                    title: Text('Home',style: TextStyle(color: index==DrawerIndexValue.home.getInt() ? Colors.purple: Colors.black),),
                    onTap: () {
                      Navigator.popUntil(context,(route) => route.isFirst);

                    },
                  ),
                ),
                Container(color: Colors.grey,height: 1,),

                ListTile(
                  leading: Icon(Icons.data_object,color: index==DrawerIndexValue.data.getInt() ? Colors.purple: Colors.black),
                  title: Text('Data',style: TextStyle(color: index==DrawerIndexValue.data.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.data.getInt()){
                      if(index==DrawerIndexValue.home.getInt()){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DataScreen(),));
                      }else{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DataScreen(),));
                      }
                    }

                  },
                ),
                ListTile(
                  leading: Icon(Icons.chat,color: index==DrawerIndexValue.chat.getInt() ? Colors.purple: Colors.black),
                  title: Text('Chat',style: TextStyle(color: index==DrawerIndexValue.chat.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if(index!=DrawerIndexValue.chat.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month,color: index==DrawerIndexValue.calendar.getInt() ? Colors.purple: Colors.black),
                  title: Text('Calendar',style: TextStyle(color: index==DrawerIndexValue.calendar.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if(index!=DrawerIndexValue.calendar.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                    leading: Icon(Icons.bar_chart,color: index==DrawerIndexValue.chart.getInt() ? Colors.purple: Colors.black),
                    title: Text('Chart',style: TextStyle(color: index==DrawerIndexValue.chart.getInt() ? Colors.purple: Colors.black),),
                    onTap: () {
                      Navigator.pop(context);
                      if(index!=DrawerIndexValue.chart.getInt()){
                        if (index == DrawerIndexValue.home.getInt()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartScreen(),
                              ));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartScreen(),
                              ));
                        }
                      }
                    }
                ),
                // ListTile(
                //   leading: Icon(Icons.currency_pound,color: index==DrawerIndexValue.expenses.getInt() ? Colors.purple: Colors.black),
                //   title: Text('Expenses',style: TextStyle(color: index==DrawerIndexValue.expenses.getInt() ? Colors.purple: Colors.black),),
                //   onTap: () {
                //     Navigator.pop(context);
                //     print(index);
                //     if(index!=DrawerIndexValue.expenses.getInt()){
                //       if (index == DrawerIndexValue.home.getInt()) {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => ExpensesScreen(),
                //             ));
                //       } else {
                //         Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => ExpensesScreen(),
                //             ));
                //       }
                //     }
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.timeline,color: index==DrawerIndexValue.timeline.getInt() ? Colors.purple: Colors.black),
                  title: Text('Timeline',style: TextStyle(color: index==DrawerIndexValue.timeline.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.timeline.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimelinePage(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimelinePage(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.timeline,color: index==DrawerIndexValue.motostudent.getInt() ? Colors.purple: Colors.black),
                  title: Text('Motostudent',style: TextStyle(color: index==DrawerIndexValue.motostudent.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.motostudent.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewerPage1(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewerPage1(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.move_to_inbox_rounded,color: index==DrawerIndexValue.weekly_report.getInt() ? Colors.purple: Colors.black),
                  title: Text('Weekly Report',style: TextStyle(color: index==DrawerIndexValue.weekly_report.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.weekly_report.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeeklyReportScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeeklyReportScreen(),
                            ));
                      }
                    }
                  },
                ),

              ],
            ),
          ),
          
          Container(
              margin: EdgeInsets.only(left: 25,top: 20,bottom: 2),
              child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
              )
          ),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300
            ),
            child: Column(
              children: [
                ListTile(

                  leading: Icon(Icons.settings,color: index==DrawerIndexValue.settings.getInt() ? Colors.purple: Colors.black),
                  title: Text('Settings',style: TextStyle(color: index==DrawerIndexValue.settings.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if (index != DrawerIndexValue.settings.getInt()) {
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ));
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.admin_panel_settings,color: index==DrawerIndexValue.admin.getInt() ? Colors.purple: Colors.black),
                  title: Text('Admin',style: TextStyle(color: index==DrawerIndexValue.admin.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if (index != DrawerIndexValue.admin.getInt()) {
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminPanel(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminPanel(),
                            ));
                      }
                    }
                  },
                ),




                ListTile(
                  leading: Icon(Icons.feedback,color: index==DrawerIndexValue.feedback.getInt() ? Colors.purple: Colors.black),
                  title: Text('Feedback',style: TextStyle(color: index==DrawerIndexValue.feedback.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if (index != DrawerIndexValue.feedback.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackScreen(),
                            ));
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),


              ],
            ),
          ),


          Container(
              margin: EdgeInsets.only(left: 25,top: 20,bottom: 2),
              child: Text(
                'Info',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300
              ),
              child: Column(
                  children: [
                    // ListTile(
                    //   leading: Icon(Icon_Panther.helmet,size: 23,color: Colors.black),
                    //   title: Text('Moto Student',style: TextStyle(color:Colors.black),),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     if(index==DrawerIndexValue.home.getInt()){
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => Motostudent(),));
                    //     }else{
                    //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MotoStudent(),));
                    //     }
                    //
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.new_releases,color: Colors.black),
                      title: Text('Future Releases',style: TextStyle(color:Colors.black),),
                      onTap: () {
                        Navigator.pop(context);
                        if(index==DrawerIndexValue.home.getInt()){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PreReleaseScreen(),));
                        }else{
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PreReleaseScreen(),));
                        }

                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline_rounded,color: index==DrawerIndexValue.about.getInt() ? Colors.purple: Colors.black),
                      title: Text('About',style: TextStyle(color: index==DrawerIndexValue.about.getInt() ? Colors.purple: Colors.black),),
                      onTap: () {
                        Navigator.pop(context);
                        if (index != DrawerIndexValue.about.getInt()){
                          if (index == DrawerIndexValue.home.getInt()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutScreen(),
                                ));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutScreen(),
                                ));
                          }
                      }
                  },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                  ]
              )
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                signOut(context);
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
        ],
      ),
    );

  }
  else if(appSetup.role=='engineer' || appSetup.role=='hands_on_engineer' ||  appSetup.role=='coordinator'){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if(index==DrawerIndexValue.home.getInt()){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
                          }else{
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
                          }
                        },
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade300.withOpacity(0.5),
                            child: Image.asset('assets/panther_logo_transparent-2.png',errorBuilder: (context, error, stackTrace) => Icon(Icons.add_a_photo,size: 40,),)
                        ),
                      ),
                      Spacer(),
                      Text('data')
                    ],
                  )
              )
          ),
          /*
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black45
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.purple
                    ),
                  ),
                  onPressed: (){}
              ),
              MaterialButton(
                  minWidth: 150,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.purple
                    ),
                  ),
                  onPressed: (){}
              ),
            ],
          ),
        ),
         */
          Container(
              margin: EdgeInsets.only(left: 25,top: 20,bottom: 2),
              child: Text(
                'Main',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    leading: Icon(Icons.home,color: index==DrawerIndexValue.home.getInt() ? Colors.purple: Colors.black,),
                    title: Text('Home',style: TextStyle(color: index==DrawerIndexValue.home.getInt() ? Colors.purple: Colors.black),),
                    onTap: () {
                      Navigator.popUntil(context,(route) => route.isFirst);

                    },
                  ),
                ),
                Container(color: Colors.grey,height: 1,),

                ListTile(
                  leading: Icon(Icons.data_object,color: index==DrawerIndexValue.data.getInt() ? Colors.purple: Colors.black),
                  title: Text('Data',style: TextStyle(color: index==DrawerIndexValue.data.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.data.getInt()){
                      if(index==DrawerIndexValue.home.getInt()){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DataScreen(),));
                      }else{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DataScreen(),));
                      }
                    }

                  },
                ),
                ListTile(
                  leading: Icon(Icons.chat,color: index==DrawerIndexValue.chat.getInt() ? Colors.purple: Colors.black),
                  title: Text('Chat',style: TextStyle(color: index==DrawerIndexValue.chat.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if(index!=DrawerIndexValue.chat.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month,color: index==DrawerIndexValue.calendar.getInt() ? Colors.purple: Colors.black),
                  title: Text('Calendar',style: TextStyle(color: index==DrawerIndexValue.calendar.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if(index!=DrawerIndexValue.calendar.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                    leading: Icon(Icons.bar_chart,color: index==DrawerIndexValue.chart.getInt() ? Colors.purple: Colors.black),
                    title: Text('Chart',style: TextStyle(color: index==DrawerIndexValue.chart.getInt() ? Colors.purple: Colors.black),),
                    onTap: () {
                      Navigator.pop(context);
                      if(index!=DrawerIndexValue.chart.getInt()){
                        if (index == DrawerIndexValue.home.getInt()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartScreen(),
                              ));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartScreen(),
                              ));
                        }
                      }
                    }
                ),
                ListTile(
                  leading: Icon(Icons.timeline,color: index==DrawerIndexValue.timeline.getInt() ? Colors.purple: Colors.black),
                  title: Text('Timeline',style: TextStyle(color: index==DrawerIndexValue.timeline.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.timeline.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimelinePage(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimelinePage(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.move_to_inbox_rounded,color: index==DrawerIndexValue.weekly_report.getInt() ? Colors.purple: Colors.black),
                  title: Text('Weekly Report',style: TextStyle(color: index==DrawerIndexValue.weekly_report.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.weekly_report.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeeklyReportScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeeklyReportScreen(),
                            ));
                      }
                    }
                  },
                ),

              ],
            ),
          ),

          Container(
              margin: EdgeInsets.only(left: 25,top: 20,bottom: 2),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300
            ),
            child: Column(
              children: [
                ListTile(

                  leading: Icon(Icons.settings,color: index==DrawerIndexValue.settings.getInt() ? Colors.purple: Colors.black),
                  title: Text('Settings',style: TextStyle(color: index==DrawerIndexValue.settings.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if (index != DrawerIndexValue.settings.getInt()) {
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ));
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),




                ListTile(
                  leading: Icon(Icons.feedback,color: index==DrawerIndexValue.feedback.getInt() ? Colors.purple: Colors.black),
                  title: Text('Feedback',style: TextStyle(color: index==DrawerIndexValue.feedback.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if (index != DrawerIndexValue.feedback.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackScreen(),
                            ));
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),


              ],
            ),
          ),


          Container(
              margin: EdgeInsets.only(left: 25,top: 20,bottom: 2),
              child: Text(
                'Info',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300
              ),
              child: Column(
                  children: [
                    // ListTile(
                    //   leading: Icon(Icon_Panther.helmet,size: 23,color: Colors.black),
                    //   title: Text('Moto Student',style: TextStyle(color:Colors.black),),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     if(index==DrawerIndexValue.home.getInt()){
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => Motostudent(),));
                    //     }else{
                    //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MotoStudent(),));
                    //     }
                    //
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.new_releases,color: Colors.black),
                      title: Text('Future Releases',style: TextStyle(color:Colors.black),),
                      onTap: () {
                        Navigator.pop(context);
                        if(index==DrawerIndexValue.home.getInt()){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PreReleaseScreen(),));
                        }else{
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PreReleaseScreen(),));
                        }

                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline_rounded,color: index==DrawerIndexValue.about.getInt() ? Colors.purple: Colors.black),
                      title: Text('About',style: TextStyle(color: index==DrawerIndexValue.about.getInt() ? Colors.purple: Colors.black),),
                      onTap: () {
                        Navigator.pop(context);
                        if (index != DrawerIndexValue.about.getInt()){
                          if (index == DrawerIndexValue.home.getInt()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutScreen(),
                                ));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutScreen(),
                                ));
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                  ]
              )
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                signOut(context);
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
        ],
      ),
    );

  }
  else if(appSetup.role=='data_analyst' || appSetup.role=='member'){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if(index==DrawerIndexValue.home.getInt()){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
                          }else{
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
                          }
                        },
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade300.withOpacity(0.5),
                            child: Image.asset('assets/panther_logo_transparent-2.png',errorBuilder: (context, error, stackTrace) => Icon(Icons.add_a_photo,size: 40,),)
                        ),
                      ),
                      Spacer(),
                      Text('data')
                    ],
                  )
              )
          ),
          /*
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black45
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.purple
                    ),
                  ),
                  onPressed: (){}
              ),
              MaterialButton(
                  minWidth: 150,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.purple
                    ),
                  ),
                  onPressed: (){}
              ),
            ],
          ),
        ),
         */
          Container(
              margin: EdgeInsets.only(left: 25,top: 20,bottom: 2),
              child: Text(
                'Main',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    leading: Icon(Icons.home,color: index==DrawerIndexValue.home.getInt() ? Colors.purple: Colors.black,),
                    title: Text('Home',style: TextStyle(color: index==DrawerIndexValue.home.getInt() ? Colors.purple: Colors.black),),
                    onTap: () {
                      Navigator.popUntil(context,(route) => route.isFirst);

                    },
                  ),
                ),
                Container(color: Colors.grey,height: 1,),

                ListTile(
                  leading: Icon(Icons.data_object,color: index==DrawerIndexValue.data.getInt() ? Colors.purple: Colors.black),
                  title: Text('Data',style: TextStyle(color: index==DrawerIndexValue.data.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.data.getInt()){
                      if(index==DrawerIndexValue.home.getInt()){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DataScreen(),));
                      }else{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DataScreen(),));
                      }
                    }

                  },
                ),
                ListTile(
                  leading: Icon(Icons.chat,color: index==DrawerIndexValue.chat.getInt() ? Colors.purple: Colors.black),
                  title: Text('Chat',style: TextStyle(color: index==DrawerIndexValue.chat.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if(index!=DrawerIndexValue.chat.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month,color: index==DrawerIndexValue.calendar.getInt() ? Colors.purple: Colors.black),
                  title: Text('Calendar',style: TextStyle(color: index==DrawerIndexValue.calendar.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if(index!=DrawerIndexValue.calendar.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                    leading: Icon(Icons.bar_chart,color: index==DrawerIndexValue.chart.getInt() ? Colors.purple: Colors.black),
                    title: Text('Chart',style: TextStyle(color: index==DrawerIndexValue.chart.getInt() ? Colors.purple: Colors.black),),
                    onTap: () {
                      Navigator.pop(context);
                      if(index!=DrawerIndexValue.chart.getInt()){
                        if (index == DrawerIndexValue.home.getInt()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartScreen(),
                              ));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartScreen(),
                              ));
                        }
                      }
                    }
                ),
                ListTile(
                  leading: Icon(Icons.timeline,color: index==DrawerIndexValue.timeline.getInt() ? Colors.purple: Colors.black),
                  title: Text('Timeline',style: TextStyle(color: index==DrawerIndexValue.timeline.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.timeline.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimelinePage(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimelinePage(),
                            ));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.move_to_inbox_rounded,color: index==DrawerIndexValue.weekly_report.getInt() ? Colors.purple: Colors.black),
                  title: Text('Weekly Report',style: TextStyle(color: index==DrawerIndexValue.weekly_report.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    print(index);
                    if(index!=DrawerIndexValue.weekly_report.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeeklyReportScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeeklyReportScreen(),
                            ));
                      }
                    }
                  },
                ),

              ],
            ),
          ),

          Container(
              margin: EdgeInsets.only(left: 25,top: 20,bottom: 2),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300
            ),
            child: Column(
              children: [
                ListTile(

                  leading: Icon(Icons.settings,color: index==DrawerIndexValue.settings.getInt() ? Colors.purple: Colors.black),
                  title: Text('Settings',style: TextStyle(color: index==DrawerIndexValue.settings.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if (index != DrawerIndexValue.settings.getInt()) {
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ));
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),






                ListTile(
                  leading: Icon(Icons.feedback,color: index==DrawerIndexValue.feedback.getInt() ? Colors.purple: Colors.black),
                  title: Text('Feedback',style: TextStyle(color: index==DrawerIndexValue.feedback.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if (index != DrawerIndexValue.feedback.getInt()){
                      if (index == DrawerIndexValue.home.getInt()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackScreen(),
                            ));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackScreen(),
                            ));
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),


              ],
            ),
          ),


          Container(
              margin: EdgeInsets.only(left: 25,top: 20,bottom: 2),
              child: Text(
                'Info',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300
              ),
              child: Column(
                  children: [
                    // ListTile(
                    //   leading: Icon(Icon_Panther.helmet,size: 23,color: Colors.black),
                    //   title: Text('Moto Student',style: TextStyle(color:Colors.black),),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     if(index==DrawerIndexValue.home.getInt()){
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => Motostudent(),));
                    //     }else{
                    //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MotoStudent(),));
                    //     }
                    //
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.new_releases,color: Colors.black),
                      title: Text('Future Releases',style: TextStyle(color:Colors.black),),
                      onTap: () {
                        Navigator.pop(context);
                        if(index==DrawerIndexValue.home.getInt()){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PreReleaseScreen(),));
                        }else{
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PreReleaseScreen(),));
                        }

                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline_rounded,color: index==DrawerIndexValue.about.getInt() ? Colors.purple: Colors.black),
                      title: Text('About',style: TextStyle(color: index==DrawerIndexValue.about.getInt() ? Colors.purple: Colors.black),),
                      onTap: () {
                        Navigator.pop(context);
                        if (index != DrawerIndexValue.about.getInt()){
                          if (index == DrawerIndexValue.home.getInt()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutScreen(),
                                ));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutScreen(),
                                ));
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                  ]
              )
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                signOut(context);
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
        ],
      ),
    );

  }
  else{
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(index==DrawerIndexValue.profile.getInt()){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
                          }else{
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
                          }
                        },
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade300.withOpacity(0.5),
                            child: Image.asset('assets/panther_logo_transparent.png',errorBuilder: (context, error, stackTrace) => Icon(Icons.photo_camera,size: 40,),)
                        ),
                      ),
                      Spacer(),
                      Text('data')
                    ],
                  )
              )
          ),
          /*
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black45
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.purple
                    ),
                  ),
                  onPressed: (){}
              ),
              MaterialButton(
                  minWidth: 150,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.purple
                    ),
                  ),
                  onPressed: (){}
              ),
            ],
          ),
        ),
         */
          Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            child: ListTile(
              leading: Icon(Icons.home,color: index==DrawerIndexValue.home.getInt() ? Colors.purple: Colors.black,),
              title: Text('Home',style: TextStyle(color: index==DrawerIndexValue.home.getInt() ? Colors.purple: Colors.black),),
              onTap: () {
                Navigator.popUntil(context,(route) => route.isFirst);

              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300
            ),
            child: Column(
              children: [
                ListTile(

                  leading: Icon(Icons.settings,color: index==DrawerIndexValue.settings.getInt() ? Colors.purple: Colors.black),
                  title: Text('Settings',style: TextStyle(color: index==DrawerIndexValue.settings.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    if(index==DrawerIndexValue.home.getInt()){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));
                    }else{
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.feedback,color: index==DrawerIndexValue.feedback.getInt() ? Colors.purple: Colors.black),
                  title: Text('Feedback',style: TextStyle(color: index==DrawerIndexValue.feedback.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    // Handle item 2 tap
                    Navigator.pop(context); // Close the drawer
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline_rounded,color: index==DrawerIndexValue.about.getInt() ? Colors.purple: Colors.black),
                  title: Text('About',style: TextStyle(color: index==DrawerIndexValue.about.getInt() ? Colors.purple: Colors.black),),
                  onTap: () {
                    // Handle item 2 tap
                    Navigator.pop(context); // Close the drawer
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                signOut(context);
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
        ],
      ),
    );
  }

}


