// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_mate/services/bmi_report_service.dart';
import 'package:fitness_mate/screens/wellness_reports/bmi_report.dart';
import 'package:fitness_mate/screens/wellness_reports/bmi_report_update.dart';
import 'package:fitness_mate/screens/wellness_reports/bmi_form_screen.dart';
import 'package:fitness_mate/screens/wellness_reports/bmi_chart_screen.dart';

class BmiReportsView extends StatefulWidget {
  const BmiReportsView({super.key});

  @override
  State<BmiReportsView> createState() => _BmiReportsViewState();
}

class _BmiReportsViewState extends State<BmiReportsView> {
  Stream<QuerySnapshot> getAllBMIReports() {
    return FirebaseFirestore.instance.collection('BMI Reports').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("BMI Reports"),
      //   centerTitle: true,
      //   brightness: Brightness.dark,
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fitness1.jpg"),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: getAllBMIReports(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> documentData =
                      documents[index].data()! as Map<String, dynamic>;
                  DateTime date =
                      DateTime.parse(documentData['date'].toDate().toString());

                  return Card(
                    margin: const EdgeInsets.all(18),
                    color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.95),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    elevation: 100,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text("Name : " + documentData['name'],
                          style: TextStyle(fontSize: 18)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          // Text("Gender : " + documentData['gender'],
                          //     style: TextStyle(fontSize: 16)),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text("Age : " + documentData['age'].toString(),
                          //     style: TextStyle(fontSize: 16)),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text("Height : " + documentData['height'].toString(),
                          //     style: TextStyle(fontSize: 16)),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text("Weight : " + documentData['weight'].toString(),
                          //     style: TextStyle(fontSize: 16)),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          Text("BMI Value : " + documentData['bmiValue'],
                              style: TextStyle(fontSize: 16)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Status : " + documentData['status'],
                              style: TextStyle(fontSize: 16,
                              color: Color.fromARGB(255, 224, 21, 89))
                              ),
                              
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Date : " +
                                  DateFormat('dd/MM/yyyy').format(date),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 2, 90, 8))),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.green,
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BmiFormUpdate(
                                    documentSnapshot: documents[index],
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => _delete(documents[index].id)),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BmiReport(
                                    documentSnapshot: documents[index])));
                      },
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BmiForm(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BmiChart(),
                  ),
                );
              },
              child: Icon(Icons.timeline)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  _delete(String id) async {
    try {
      await BmiReportService().deleteBMIReport(id);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Record deleted successfully."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Failed to delete record."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
