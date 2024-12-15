import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/assets/Medicine.dart';
import 'package:medical_app/pages/base_page.dart';
import 'package:medical_app/pages/home_page.dart';
import 'package:medical_app/pages/login_page.dart';
import 'package:medical_app/pages/welcome_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:medical_app/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(MedicineAdapter());
  await Hive.openBox('userBox');

  // Initialize timezones
  tz.initializeTimeZones();

  // Initialize notification service
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasSeenWelcomepage = Hive.box('userBox').get("has_seen_welcome", defaultValue: false);
    bool loggedIn = Hive.box('userBox').get('logged_in', defaultValue: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loggedIn ? const BasePage() : hasSeenWelcomepage ? LoginPage() : const WelcomePage(),
      routes: {
        '/welcome' : (context) => const WelcomePage(),
        '/login' : (context) => LoginPage(),
        '/home' : (context) => const HomePage(),
        '/base': (context) => const BasePage(),
      },
    );
  }
}
