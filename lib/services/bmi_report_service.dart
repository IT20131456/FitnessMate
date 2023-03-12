import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ffi';

class BmiReportService {
  final CollectionReference _bmiReport =
      FirebaseFirestore.instance.collection('BMI Reports');

  Future getAllBMIReports() async {
    return _bmiReport;
  }

  Future addBMIReport(String _name, String _gender, int _age,DateTime? _date, int _height, int _weight, String _bmiValue,String _status) async {
    return await _bmiReport.add({
      "name": _name,
      "gender": _gender,
      "age": _age,
      'date': _date,
      "height": _height,
      "weight": _weight,
      "bmiValue": _bmiValue,
      "status":_status,
    });
  }

  Future<void> updateBMIReport(String id,String _name, String _gender, int _age,DateTime? _date) async {
    return await _bmiReport.doc(id).update({
      "name": _name,
      "gender": _gender,
      "age": _age,
      'date': _date,      
    });
  }

  Future deleteBMIReport(id) async {
    await _bmiReport.doc(id).delete();
  }
}
