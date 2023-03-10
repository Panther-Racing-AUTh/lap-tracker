import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/providers/device.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/routes.dart';
import 'package:provider/provider.dart' as provider;
import 'providers/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'configs/supabase_credentials.dart';

Future<void> main() async {
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
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
      ],
      child: MaterialAppWithTheme(),
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
