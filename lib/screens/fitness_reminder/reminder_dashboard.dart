import 'package:fitness_mate/screens/fitness_reminder/add_reminder.dart';
import 'package:fitness_mate/screens/fitness_reminder/edit_reminder.dart';
import 'package:fitness_mate/screens/fitness_reminder/view_reminder.dart';
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

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    // if (documentSnapshot != null) {
    //   _todoTaskNameController.text = documentSnapshot['taskName'];
    //   _todoCompletionStatusController.text =
    //       documentSnapshot['completionStatus'].toString();
    // }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return EditReminder(
          documentSnapshot: documentSnapshot,
        );
      },
    );
  }

  Future<void> _delete(String reminderId) async {
    //await _todo.doc(productId).delete();
    await ReminderRepository().deleteReminder(reminderId);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have Successfully Cancelled the Reminder')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fitness1.jpg"),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: getAllReminders(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    color: Color.fromARGB(255, 218, 223, 218).withOpacity(0.8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          documentData['reminderName'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Date : " + documentData['date'].toString(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Time : " + documentData['time'].toString(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87)),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.green,
                              onPressed: () => _update(documents[index]),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Color.fromARGB(255, 244, 106, 96),
                              onPressed: () => _delete(documents[index].id),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewReminder(
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
