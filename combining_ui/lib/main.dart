import 'package:combining_ui/pages/HomePage.dart';
import 'package:combining_ui/pages/SignUpPage.dart';
import 'package:combining_ui/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await _initNotifications();
  await scheduleDailyNotification();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

Future<void> _initNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();

  const settings = InitializationSettings(android: android, iOS: ios);

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      
      // Save a flag in SharedPreferences
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('fromNotification', true);
      });
    },
  );

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF074493)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      home: const SessionManager(),
    );
  }
}

class SessionManager extends StatefulWidget {
  const SessionManager({super.key});

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  bool _isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  Future<void> _checkUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final fromNoti = prefs.getBool('fromNotification') ?? false;

    if (fromNoti) {

      prefs.setBool('fromNotification', false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomePage(userId: userId!)),
        );
      });
  }

    setState(() {
      _userId = userId;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _userId != null
        ? HomePage(userId: _userId!)
        : SignUpPage();
  }
}

Future<void> scheduleDailyNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'daily_reminder_channel_id',
    'Daily Reminders',
    channelDescription: 'Hey there! Don\'t forget to jot down your expenses for today. 💸 9 PM is money-time!',
    importance: Importance.max,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(
    android: androidDetails
    );

  final now = tz.TZDateTime.now(tz.local);

 //Uncomment the line below to test the notification after 1 minute
 // final scheduledDate = now.add(const Duration(minutes: 1));

//Comment These lines to test the notification after 1 minute
  var scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    21, // (9 pm) 
    0,
    0,
  );

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Reminder',
    "Don't forget to record your expense!",
    scheduledDate,
    notificationDetails,
    androidAllowWhileIdle: true,
    matchDateTimeComponents: DateTimeComponents.time,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}