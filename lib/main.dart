import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_mate/screens/login_screen.dart';
import 'package:fitness_mate/screens/wellness_reports/bmi_form_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
          backgroundColor: Color.fromARGB(255, 36, 55, 30),
        ),
      ),
      home: BmiForm(),
    );
  }
}
