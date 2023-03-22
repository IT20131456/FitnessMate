// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_mate/services/bmi_report_service.dart';

class BmiFormUpdate extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  BmiFormUpdate({required this.documentSnapshot});

  @override
  _BmiFormUpdateState createState() => _BmiFormUpdateState();
}

class _BmiFormUpdateState extends State<BmiFormUpdate> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String? _gender;
  late int _age;
  late DateTime? _date;

  @override
  void initState() {
    super.initState();
    _name = widget.documentSnapshot['name'];
    _gender = widget.documentSnapshot['gender'];
    _age = widget.documentSnapshot['age'];
    _date = widget.documentSnapshot['date']?.toDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update BMI Report'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fitness1.jpg"),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.only(left: 10,right: 10,top: 50,bottom: 50),
            color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              // side: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            child: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(top: 40, left: 24, right: 24),
                child: SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        maxLength: 25,
                        initialValue: _name,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          labelText: 'Name *',
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (value) => _name = value!,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _gender,
                        items: [
                          DropdownMenuItem(
                            child: Text('Male'),
                            value: 'Male',
                          ),
                          DropdownMenuItem(
                            child: Text('Female'),
                            value: 'Female',
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Gender *',
                          hintText: 'Select your gender',
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Gender cannot be empty';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        onSaved: (value) => _gender = value!,
                      ),
                      SizedBox(height: 35),
                      TextFormField(
                        maxLength: 3,
                        initialValue: _age.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Age *',
                          hintText: 'Enter your age',
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Age cannot be empty';
                          } else {
                            int? age = int.tryParse(value);
                            if (age == null) {
                              return 'Age must be a number';
                            } else if (age < 1 || age > 120) {
                              return 'Age must be between 1 to 120';
                            }
                          }
                          return null;
                        },
                        onSaved: (value) => _age = int.parse(value!),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        initialValue:
                            _date == null ? '' : _date.toString().substring(0, 10),
                        decoration: InputDecoration(
                          labelText: 'Measurement Date *',
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _date ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _date = pickedDate;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() == true) {
                            _formKey.currentState?.save();
                
                            // Calculate the BMI value
                            try {
                              // Update the BMI report in Firebase database
                              await BmiReportService().updateBMIReport(
                                widget.documentSnapshot.id,
                                _name,
                                _gender!,
                                _age,
                                _date,
                              );
                
                              // Show success message
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('BMI report updated'),
                                  content: Text(
                                      'The BMI report was updated successfully.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } catch (e) {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to update BMI report')),
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.update),
                              SizedBox(width: 15),
                              Text('Update Report'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
