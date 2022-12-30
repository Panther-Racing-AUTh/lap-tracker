import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import 'screens/desktop_screens/main_screen_desktop.dart';
import './screens/signin_screen.dart';
import 'screens/mobile_screens/main_screen.dart';
import 'screens/mobile_screens/chat_screen.dart';
import 'screens/mobile_screens/data_screen.dart';
import 'screens/mobile_screens/profile_screen.dart';
import 'screens/mobile_screens/settings_screen.dart';
import 'screens/mobile_screens/chart_screen.dart';
import 'screens/mobile_screens/panther_screen.dart';
import 'screens/mobile_screens/edit_profile_screen.dart';

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
      case '/main':
        if (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android) {
          return MaterialPageRoute(builder: (_) => MainScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => MainScreenDesktop(),
          );
        }
      case '/main-mobile':
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/main-desktop':
        return MaterialPageRoute(builder: (_) => MainScreenDesktop());
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(),
        );
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
      case '/panther':
        return MaterialPageRoute(
          builder: (_) => PantherScreen(),
        );
      case '/profile/edit':
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(),
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
        title: Text('Error'),
      ),
      body: Center(
        child: Text('Error Screen'),
      ),
    );
  }
}
