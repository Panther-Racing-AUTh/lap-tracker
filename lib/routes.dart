import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/admin_panel_screen_desktop.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/admin_panel_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/feedback_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/motostudent_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/pre_release_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/timeline_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/toolkit_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_screen.dart';
import 'package:flutter_complete_guide/screens/notification_screen.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/home_page.dart';
import './screens/splash_screen.dart';
import 'screens/desktop_screens/main_screen_desktop.dart';
import './screens/signin_screen.dart';
import 'screens/mobile_screens/main_screen.dart';
import 'screens/mobile_screens/chat_screen.dart';
import 'screens/mobile_screens/data_screen.dart';
import 'screens/mobile_screens/profile_screen.dart';
import 'screens/mobile_screens/settings_screen.dart';
import 'screens/mobile_screens/chart_screen.dart';
import 'screens/mobile_screens/calendar_screen.dart';
import 'screens/mobile_screens/edit_profile_screen.dart';
import 'package:flutter_complete_guide/names.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final data = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case '/signin':
        return MaterialPageRoute(
          builder: (_) => SigninScreen(),
        );
      case '/https://pwqrcfdxmgfavontopyn.supabase.co/auth/v1/callback':
        return MaterialPageRoute(
          builder: (_) => SigninScreen(),
        );
      case '/main':
        return MaterialPageRoute(
          builder: (_) => MainScreenDesktop(),
        );

      case '/main-mobile':
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/main-desktop':
        return MaterialPageRoute(builder: (_) => MainScreenDesktop());
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(),
        );
      case '/pre_release':
        return MaterialPageRoute(builder: (_) => PreReleaseScreen());
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(),
        );
      case '/data':
        return MaterialPageRoute(
          builder: (_) => DataScreen(),
        );
      case '/chat':
        return MaterialPageRoute(
          builder: (_) => ChatScreen(),
        );
      case '/chart':
        return MaterialPageRoute(
          builder: (_) => ChartScreen(),
        );
      case '/calendar':
        return MaterialPageRoute(
          builder: (_) => CalendarScreen(),
        );
      case '/timeline':
        return MaterialPageRoute(
          builder: (_) => TimelineScreen(),

        );
      case '/weekly-report':
        return MaterialPageRoute(
          builder: (_) => WeeklyReportScreen(),

        );
      case '/future-releases':
        return MaterialPageRoute(
          builder: (_) => PreReleaseScreen(),

        );
      case '/feedback':
        return MaterialPageRoute(
          builder: (_) => FeedbackScreen(),

        );

      case '/motostudent':
        return MaterialPageRoute(
          builder: (_) => MotostudentScreen(),
        );
      case '/profile/edit':
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(),
        );
      case '/admin-panel-mobile':
        return MaterialPageRoute(
          builder: (_) => AdminPanel(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => ErrorScreen(),
        );
    }
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routes_error),
      ),
      body: Center(
        child: Text(routes_error_screen),
      ),
    );
  }
}
