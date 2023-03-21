import 'package:flutter/material.dart';
import 'package:fitness_mate/screens/workouts/workouts_screen.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Center(
    //     child: Text("Dashboard Page"),
    //   ),
    // );


      return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home Page'),
      // ),
      body: Center(
        child: InkWell(
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Text('Go to Second Page'),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Workouts()),
            );
          },
        ),
      ),
    );
  }
}