import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/providers/calendar_providers/appointment.dart';
import 'package:flutter_complete_guide/providers/device.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/providers/feedback_providers/feedback.dart';
import 'package:flutter_complete_guide/providers/settings_providers/settings.dart';
import 'package:flutter_complete_guide/providers/weekly_report_providers/weekly_report.dart';
import 'package:flutter_complete_guide/routes.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_provider.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/provider.dart';
import 'package:provider/provider.dart' as provider;
import 'providers/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'configs/supabase_credentials.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'view/graphql_view.dart';

final graphqlEndpoint = 'https://funny-sculpin-82.hasura.app/v1/graphql';
final subscriptionEndpoint = 'wss://funny-sculpin-82.hasura.app/v1/graphql';
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
          provider.ChangeNotifierProvider<ExpenseData>(
            create: (_) => ExpenseData(),
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
