import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ReminderRepository {
  final CollectionReference _reminder =
      FirebaseFirestore.instance.collection('reminders');

  Future getAllReminders() async {
    return _reminder;
  }

  Future addReminder(String name, String type, String message) async {
    return await _reminder.add({
      "reminderName": name,
      "type": type,
      "message": message,
    });
  }

  Future<void> updateReminder(String id, String name) async {
    return await _reminder.doc(id).update({
      "taskName": name,
      "completionStatus": true,
    });
  }

  Future deleteReminder(id) async {
    await _reminder.doc(id).delete();
  }
}
