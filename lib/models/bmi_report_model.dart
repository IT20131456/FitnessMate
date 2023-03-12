import 'dart:ffi';

class BmiReport {
  String name;
  String gender;
  int age;
  DateTime date;
  int height;
  int weight;
  int bmiValue;
  String status;

  BmiReport({
    required this.name,
    required this.gender,
    required this.age,
    required this.date,
    required this.height,
    required this.weight,
    required this.bmiValue,
    required this.status,
  });
}
