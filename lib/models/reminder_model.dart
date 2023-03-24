import 'dart:ffi';

class Reminder {
  String name;
  String type;
  String message;
  String date;
  String time;

  Reminder({
    required this.name,
    required this.type,
    required this.message,
    required this.date,
    required this.time,
  });
}
