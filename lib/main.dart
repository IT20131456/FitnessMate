// ignore_for_file: prefer_const_constructors
import 'package:fitness_mate/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_mate/screens/login_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:fitness_mate/screens/workouts/workouts_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          // backgroundColor: Color.fromARGB(255, 7, 167, 13),
           backgroundColor: Color(0xFF40D876),

        ),
      ),
      home: LoginScreen(),
    );
  }
}
