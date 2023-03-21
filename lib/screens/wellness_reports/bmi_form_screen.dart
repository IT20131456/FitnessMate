// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitness_mate/services/bmi_report_service.dart';
import 'package:fitness_mate/screens/wellness_reports/bmi_reports_view_screen.dart';
import 'package:date_time_picker/date_time_picker.dart';

class BmiForm extends StatefulWidget {
  const BmiForm({super.key});

  @override
  _BmiFormState createState() => _BmiFormState();
}

class _BmiFormState extends State<BmiForm> {
  final _formKey = GlobalKey<FormState>();
  final _bmireportNameController = TextEditingController();
  final _bmireportAgeController = TextEditingController();
  final _bmireportHeightController = TextEditingController();
  final _bmireportWeightController = TextEditingController();
  final _bmireportBmiValueController = TextEditingController();
  final BmiReportService _bmiReportService = BmiReportService();

  String? _gender;
  String? _name;
  int? _age;
  int? _height;
  int? _weight;
  double _bmi = 0.0;
  DateTime? _date;

  final List<String> _genderOptions = ['Male', 'Female'];

  double calculateBMI(int height, int weight) {
    return weight / (height * height) * 10000;
  }

  String categorizeBMI(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 25) {
      return "Normal";
    } else if (bmi >= 25 && bmi < 30) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  Color getBmiColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi >= 18.5 && bmi < 25) {
      return Colors.green;
    } else if (bmi >= 25 && bmi < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate BMI Report'),
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
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                        controller: _bmireportNameController,
                        maxLength: 25,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          labelText: 'Name *',
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (text) {
                          _name = text;
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: InputDecoration(
                        hintText: 'Select your gender',
                        labelText: 'Gender *',
                        labelStyle: TextStyle(
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _genderOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _bmireportAgeController,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter your age',
                        labelText: 'Age *',
                        labelStyle: TextStyle(
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                      onSaved: (value) {
                        _age = int.tryParse(value!);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        initialValue: DateTime.now().toString(),
                        icon: Icon(Icons.calendar_today),
                        decoration: InputDecoration(
                          labelText: 'Measurement Date *',
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _date = DateTime.parse(val);
                          });
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Date cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _date = DateTime.parse(val!);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _bmireportHeightController,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter your height',
                        labelText: 'Height (cm) *',
                        labelStyle: TextStyle(
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Height cannot be empty';
                        } else {
                          int? height = int.tryParse(value);
                          if (height == null) {
                            return 'Height must be a number';
                          } else if (height < 50 || height > 200) {
                            return 'Height must be between 50cm to 200cm';
                          }
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _height = int.tryParse(value!);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _bmireportWeightController,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter your weight',
                        labelText: 'Weight (kg) *',
                        labelStyle: TextStyle(
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Weight cannot be empty';
                        } else {
                          int? weight = int.tryParse(value);
                          if (weight == null) {
                            return 'Weight must be a number';
                          } else if (weight < 5 || weight > 150) {
                            return 'Weight must be between 5kg to 150kg';
                          }
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _weight = int.tryParse(value!);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'BMI Value : ${_bmi.toStringAsFixed(1)} - ${categorizeBMI(_bmi)}',
                      style: TextStyle(
                        fontSize: 20,
                        color: getBmiColor(_bmi),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.calculate),
                              label: Text(
                                'Calculate',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true) {
                                  _formKey.currentState?.save();
                                  setState(() {
                                    double heightInMeters = _height! / 100;
                                    _bmi = _weight! /
                                        (heightInMeters * heightInMeters);
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save),
                                  SizedBox(width: 8),
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                if (_formKey.currentState?.validate() == true) {
                                  _formKey.currentState?.save();
                                  String name = _bmireportNameController.text;
                                  String? gender = _gender;
                                  int age =
                                      int.parse(_bmireportAgeController.text);
                                  int height = int.parse(
                                      _bmireportHeightController.text);
                                  int weight = int.parse(
                                      _bmireportWeightController.text);
                                  double bmi = calculateBMI(height, weight);
                                  // Save the values to the Firebase database
                                  try {
                                    await _bmiReportService.addBMIReport(
                                        name,
                                        gender!,
                                        age,
                                        _date,
                                        height,
                                        weight,
                                        bmi.toStringAsFixed(1),
                                        categorizeBMI(_bmi));

                                    // Show a success message
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Success!'),
                                          content: Text(
                                              'The BMI report was saved successfully.'),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BmiReportsView(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    // Clear the text controllers
                                    _bmireportNameController.clear();
                                    _bmireportAgeController.clear();
                                    _bmireportHeightController.clear();
                                    _bmireportWeightController.clear();
                                    _bmireportBmiValueController.clear();
                                    setState(() {
                                      _gender = null;
                                    });
                                  } catch (e) {
                                    // Show an error message
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text(
                                              'An error occurred while saving the BMI report. Please try again later.'),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
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
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
