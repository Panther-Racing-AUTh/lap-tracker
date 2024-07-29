import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/models/notification_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_date_model.dart';
import 'package:flutter_complete_guide/models/weekly_report_models/weekly_report_item_model.dart';
import 'package:flutter_complete_guide/providers/calendar_providers/appointment.dart';
import 'package:flutter_complete_guide/providers/device.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_data.dart';
import 'package:flutter_complete_guide/providers/feedback_providers/feedback.dart';
import 'package:flutter_complete_guide/providers/settings_providers/settings.dart';
import 'package:flutter_complete_guide/providers/weekly_report_providers/weekly_report.dart';
import 'package:flutter_complete_guide/routes.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/provider.dart';
import 'package:flutter_complete_guide/supabase/chat_service.dart';
import 'package:flutter_complete_guide/supabase/weekly_report_functions.dart';
import 'package:googleapis/apigeeregistry/v1.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;
import 'providers/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'configs/supabase_credentials.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'view/graphql_view.dart';

final graphqlEndpoint = 'https://funny-sculpin-82.hasura.app/v1/graphql';
final subscriptionEndpoint = 'wss://funny-sculpin-82.hasura.app/v1/graphql';


Future<Map<String,dynamic>> getUserByID(int id) async {
  // Simulate fetching user list (replace this with your actual API or database call)
  final Map<String,dynamic> temp = await getUserById(id); // Assuming getAllUsers() returns List<User>

  // Print each user for debugging



  return temp;
}
Future<void> _loadUserList(BuildContext context) async {
  try {
    // Get the WeeklyReportProvider instance using Provider.of
    WeeklyReportProvider weeklyReportProvider =provider.Provider.of<WeeklyReportProvider>(context, listen: false);
    AppSetup appSetup= provider.Provider.of<AppSetup>(context,listen: false);
    weeklyReportProvider.setIsLoading(true);

    final user=await getUserByID(appSetup.supabase_id);
    weeklyReportProvider.reports.clear();

    weeklyReportProvider.addMeeting(WeeklyReportItem.fromMap(user));
    var report_data=await getNumWeeklyReportsFromUserAscendingByDate(appSetup.supabase_id,false,3);
    print(report_data.toString());
    weeklyReportProvider.reports[0].reportList.clear();
    if(report_data.isNotEmpty){
      for(var temp in report_data){
        weeklyReportProvider.reports[0].reportList.add(WeeklyReportItemList.fromMap(temp));
      }
    }
    print("Check ReportList:${weeklyReportProvider.reports[0].reportList.toString()}");
    weeklyReportProvider.setIsLoading(false);


    // Once the user list is loaded, you can perform other tasks or update the UI
    // For example, setState() to trigger a rebuild if necessary

  } catch (e) {
    // Handle any errors that occur during fetching or updating the data
    print('Error loading user list: $e');
  }
}

List<bool> isInSpecificDay(List<WeeklyReportItemList> reportList) {
  List<bool> boolVals=[false,false,false];



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
      if(tempReport.start_date.isAfter(before_monday) && tempReport.start_date.isBefore(sunday)){
        if(tempReport.start_date.weekday == DateTime.monday || tempReport.start_date.weekday == DateTime.wednesday || tempReport.start_date.weekday == DateTime.saturday){
          boolVals[i]=true;
        }
      }
    }

  }else{
    for(int i=0;i<reportList.length;i++){
      WeeklyReportItemList tempReport = reportList[i];
      print('Length : ${reportList.length}');
      print("temp report : ${reportList.length} ${DateFormat('EEEE dd/MM/yyyy').format(tempReport.start_date)}");
      print("mday : ${reportList.length} ${DateFormat('EEEE dd/MM/yyyy').format(monday)}");

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

@pragma('vm:entry-point')
void callbackDispatcher(BuildContext context) {
  WeeklyReportProvider weeklyReportProvider =provider.Provider.of<WeeklyReportProvider>(context, listen: false);
  _loadUserList(context);
  final boolVals=isInSpecificDay(weeklyReportProvider.reports[0].reportList);
  Workmanager().executeTask((task, inputData) async {
    final now = DateTime.now();
    print('just checking');
    NotificationModelFunction notificationModelFunction=NotificationModelFunction();
    if (task == 'mondayTask' && now.weekday == DateTime.monday ) {
      notificationModelFunction.showNotification(1,'Monday Recap Reminder 📃', 'Hey👋Time for your Monday Recap!');
      notificationModelFunction.rescheduleTask('mondayTask', Duration(days: 1));
    } else if (task == 'tuesdayTask' && now.weekday == DateTime.tuesday) {
      notificationModelFunction.showNotification(2,'Did you forget Monday Recap?📃', 'Hey👋Just a little reminder of your Monday recap');
      notificationModelFunction.rescheduleTask('tuesdayTask', Duration(days: 1));
    }else if (task == 'wednesdayTask' && now.weekday == DateTime.wednesday) {
      notificationModelFunction.showNotification(3,'Wednesday Recap Reminder 📃', 'Hey👋Time for your Wednesday Recap');
      notificationModelFunction.rescheduleTask('wednesdayTask', Duration(days: 1));
    } else if (task == 'thursdayTask' && now.weekday == DateTime.thursday) {
      notificationModelFunction.showNotification(4,'Did you forget Wednesday Recap?📃', 'Hey👋Just a little reminder of your Wednesday recap');
      notificationModelFunction.rescheduleTask('thursdayTask', Duration(days: 1));
    } else if (task == 'fridayTask' && now.weekday == DateTime.friday) {
      notificationModelFunction.showNotification(5,'Did you forget Wednesday Recap?📃', 'Hey👋Just a little reminder of your Wednesday recap');
      notificationModelFunction.rescheduleTask('fridayTask', Duration(days: 1));
    } else if (task == 'saturdayTask' && now.weekday == DateTime.saturday) {
      notificationModelFunction.showNotification(6,'Saturday Recap Reminder 📃', 'Hey👋Time for your Saturday Recap');
      notificationModelFunction.rescheduleTask('saturdayTask', Duration(days: 1));
    }else if (task == 'sundayTask' && now.weekday == DateTime.sunday) {
      notificationModelFunction.showNotification(7,'❗ Week Almost Done ❗', 'Have you noticed that it\'s the end of the week?\nYou missed some recaps!');
      notificationModelFunction.rescheduleTask('sundayTask', Duration(days: 1));
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  await initHiveForFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseCredentials.APIURL,
    anonKey: SupabaseCredentials.APIKEY,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);



  // WidgetsFlutterBinding.ensureInitialized();
  //
  // // Initialize Awesome Notifications
  // AwesomeNotifications().initialize(
  //   'resource://drawable/ic_notification',
  //   [
  //     NotificationChannel(
  //       channelKey: 'recap_channel',
  //       channelName: 'Recap notifications',
  //       channelDescription: 'Notification channel for basic tests',
  //       defaultColor: Color(0xFF9D50DD),
  //       ledColor: Colors.white,
  //       importance: NotificationImportance.None,
  //       channelShowBadge: false,
  //       defaultRingtoneType: DefaultRingtoneType.Notification,
  //
  //       icon: 'resource://drawable/panther_logo_transparent_117x117',
  //     ),
  //   ],
  // );
  //
  // // Initialize WorkManager
  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: false, // Set to false in production
  // );
  //
  // // Register the initial one-off tasks for each day
  // Workmanager().registerOneOffTask(
  //   '1',
  //   'mondayTask',
  //   initialDelay: Duration(seconds: 15),
  // );
  // Workmanager().registerOneOffTask(
  //   '2',
  //   'tuesdayTask',
  //   initialDelay: Duration(seconds: 15),
  // );
  // Workmanager().registerOneOffTask(
  //   '3',
  //   'wednesdayTask',
  //   initialDelay: Duration(seconds: 15),
  // );
  // Workmanager().registerOneOffTask(
  //   '4',
  //   'thursdayTask',
  //   initialDelay: Duration(seconds: 15),
  // );
  // Workmanager().registerOneOffTask(
  //   '5',
  //   'fridayTask',
  //   initialDelay: Duration(seconds: 15),
  // );
  // Workmanager().registerOneOffTask(
  //   '6',
  //   'saturdayTask',
  //   initialDelay: Duration(seconds: 15),
  // );
  // Workmanager().registerOneOffTask(
  //   '7',
  //   'sundayTask',
  //   initialDelay: Duration(seconds: 15),
  // );


  print('main');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClientProvider(
      uri: graphqlEndpoint,
      subscriptionUri: subscriptionEndpoint,
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider<ThemeChanger>(
            create: (_) => ThemeChanger(),
          ),
          provider.ChangeNotifierProvider<DeviceManager>(
            create: (_) => DeviceManager(),
          ),
          provider.ChangeNotifierProvider<AppSetup>(
            create: (_) => AppSetup(),
          ),
          provider.ChangeNotifierProvider<MeetingProvider>(
            create: (_) => MeetingProvider(),
          ),
          provider.ChangeNotifierProvider<ExpenseAccountProvider>(
            create: (_) => ExpenseAccountProvider(),
          ),
          provider.ChangeNotifierProvider<ExpenseItemProvider>(
            create: (_) => ExpenseItemProvider(),
          ),
          provider.ChangeNotifierProvider<FeedbackProvider>(
            create: (_) => FeedbackProvider(),
          ),
          provider.ChangeNotifierProvider<WeeklyReportProvider>(
            create: (_) => WeeklyReportProvider(),
          ),
          provider.ChangeNotifierProvider<SettingsProvider>(
            create: (_) => SettingsProvider(),
          ),
        ],
        child: MaterialAppWithTheme(),
      ),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    final theme = provider.Provider.of<ThemeChanger>(context);
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: theme.getLightTheme(),
      darkTheme: theme.getDarkTheme(),
      themeMode: (theme.dark) ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
