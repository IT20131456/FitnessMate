import 'package:fitness_mate/screens/fitness_reminder/add_reminder.dart';
import 'package:fitness_mate/services/reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ReminderDashboard extends StatefulWidget {
  const ReminderDashboard({super.key});

  @override
  State<ReminderDashboard> createState() => _ReminderDashboardState();
}

class _ReminderDashboardState extends State<ReminderDashboard> {
  final TextEditingController _todoTaskNameController = TextEditingController();
  final TextEditingController _todoCompletionStatusController =
      TextEditingController();
  Stream<QuerySnapshot> getAllReminders() {
    return FirebaseFirestore.instance.collection('reminders').snapshots();
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return const AddReminder();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: getAllReminders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> documentData =
                    documents[index].data()! as Map<String, dynamic>;
                // DateTime date =
                //     DateTime.parse(documentData['date'].toDate().toString());

                return Card(
                  margin: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                        "Reminder Name : " + documentData['reminderName'],
                        style: TextStyle(fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text("Date : " + documentData['reminderName'],
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Time : " + documentData['type'].toString(),
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Type : " + documentData['message'].toString(),
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    // trailing: SizedBox(
                    //   width: 100,
                    //   child: Row(
                    //     children: [
                    //       IconButton(
                    //         icon: const Icon(Icons.edit),
                    //         color: Colors.green,
                    //         onPressed: () => Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => BmiFormUpdate(
                    //               documentSnapshot: documents[index],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       IconButton(
                    //           icon: const Icon(Icons.delete),
                    //           color: Colors.red,
                    //           onPressed: () => _delete(documents[index].id)),
                    //     ],
                    //   ),
                    // ),
                    // onTap: () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => BmiReport(
                    //               documentSnapshot: documents[index])));
                    // },
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
//       floatingActionButton: FloatingActionButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BmiForm(),
//       ),
//     );
//   },
//   child: const Icon(Icons.add),
// ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
