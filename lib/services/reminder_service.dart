import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ReminderRepository {
  final CollectionReference _reminder =
      FirebaseFirestore.instance.collection('reminders');

  Future getAllReminders() async {
    return _reminder;
  }

  Future addReminder(String name, String type, String message, String date,
      String time) async {
    return await _reminder.add({
      "reminderName": name,
      "type": type,
      "message": message,
      "date": date,
      "time": time,
    });
  }

  Future<void> updateReminder(String id, String name, String type,
      String message, String date, String time) async {
    return await _reminder.doc(id).update({
      "reminderName": name,
      "type": type,
      "message": message,
      "date": date,
      "time": time,
    });
  }

  Future deleteReminder(id) async {
    await _reminder.doc(id).delete();
  }
}
