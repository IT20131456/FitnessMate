// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BmiReport extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  const BmiReport({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date =
        DateTime.parse(documentSnapshot['date'].toDate().toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Report Details'),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 60),
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 300,
                      child: Image.asset(
                        "assets/images/bmi.png",
                        fit: BoxFit.cover,
                      )),                 
                  Text(
                    'Name: ${documentSnapshot['name']}',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Gender: ${documentSnapshot['gender']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Age: ${documentSnapshot['age']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Height: ${documentSnapshot['height']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Weight: ${documentSnapshot['weight']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'BMI Value: ${documentSnapshot['bmiValue']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Status: ${documentSnapshot['status']}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: documentSnapshot['status'] == 'Normal'
                            ? Colors.green
                            : Colors.red),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Measurement Date : " +
                        DateFormat('dd/MM/yyyy').format(date),
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 6, 119, 14)),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.2,
          //     child: Image.asset(
          //       "assets/images/bmi.png",
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
