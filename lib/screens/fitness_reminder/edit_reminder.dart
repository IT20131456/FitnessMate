import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_mate/services/notification_service.dart';
import 'package:fitness_mate/services/reminder_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class EditReminder extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;

  const EditReminder({Key? key, this.documentSnapshot}) : super(key: key);

  @override
  State<EditReminder> createState() => _EditReminderState();
}

class _EditReminderState extends State<EditReminder> {
  late String _id;
  late TextEditingController _reminderName;
  late TextEditingController _message;
  late String _type;
  late String _date;
  late String _time;

  @override
  void initState() {
    super.initState();

    _id = widget.documentSnapshot!.id;
    _reminderName =
        TextEditingController(text: widget.documentSnapshot!['reminderName']);
    _message = TextEditingController(text: widget.documentSnapshot!['message']);
    _type = widget.documentSnapshot!['type'];
    _date = widget.documentSnapshot!['date']; //?.toDate();
    _time = widget.documentSnapshot!['time']; //?.toDate();

    _checkType();
  }

  TimeOfDay _reminderTimeController = TimeOfDay.now();
  DateTime _reminderDayController = DateTime.now();

  late String selectedDate =
      DateFormat('yyyy-MM-dd').format(_reminderDayController);
  late String selectedTime =
      '${_reminderTimeController.hour.toString().padLeft(2, '0')}:${_reminderTimeController.minute.toString().padLeft(2, '0')}';
  // Reminder Types

  bool notification = false;
  bool alarm = false;
  bool vibration = false;

  final List<String> options = [
    'Workout',
    'Meal',
    'Stretching',
    'Meditation',
    'Sleep',
    'Appointment'
  ];
  String? selectedOption;

  _checkType() {
    if (_type == 'notification') {
      setState(() {
        notification = true;
      });
    } else if (_type == 'alarm') {
      setState(() {
        alarm = true;
      });
    } else if (_type == 'vibration') {
      setState(() {
        vibration = true;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _reminderDayController,
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _reminderDayController) {
      setState(() {
        _reminderDayController = picked;
        print(_reminderDayController.toString());
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTimeController,
    );
    if (picked != null && picked != _reminderTimeController) {
      setState(() {
        _reminderTimeController = picked;
        print(_reminderTimeController);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
              child: const Center(
                child: Text(
                  "Update Reminder",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey, // set the color of the line
              thickness: 1, // set the thickness of the line
              height: 20, // set the height of the line
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Color.fromARGB(255, 20, 116, 9),
                    ),
                    label: Text(
                      _date,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 20, 116, 9),
                      ),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 18.0),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 163, 241, 154),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(
                      Icons.watch_later,
                      color: Color.fromARGB(255, 20, 116, 9),
                    ),
                    label: Text(
                      _time,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 20, 116, 9),
                      ),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 18.0),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 163, 241, 154),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _reminderName,
              decoration: const InputDecoration(labelText: 'Reminder Name'),
            ),
            TextField(
              controller: _message,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            CustomDropdownButton(
              options: options,
              onChanged: (String? value) {
                selectedOption = value;
                print(selectedOption);
              },
              value: selectedOption,
            ),
            Container(
                margin: const EdgeInsets.only(top: 2.0, bottom: 8.0),
                child: const Text("Select Type")),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Row(
                children: [
                  // Notification Btn
                  Tooltip(
                    message: 'Notification',
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _type = 'notification';
                          notification = true;
                          alarm = false;
                          vibration = false;
                        });
                      },
                      icon: const Icon(
                        Icons.notifications,
                        color: Color.fromARGB(255, 20, 116, 9),
                      ),
                      label: const Text(
                        'Notification',
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 116, 9),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          notification
                              ? const Color.fromARGB(255, 163, 241, 154)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(
                              color: Color.fromARGB(255, 163, 241, 154),
                              width: 0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Alarm Btn
                  Tooltip(
                    message: 'Alarm',
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _type = 'alarm';
                          notification = false;
                          alarm = true;
                          vibration = false;
                        });
                      },
                      icon: const Icon(
                        Icons.alarm,
                        color: Color.fromARGB(255, 20, 116, 9),
                      ),
                      label: const Text(
                        'Alarm',
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 116, 9),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          alarm
                              ? const Color.fromARGB(255, 163, 241, 154)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(
                              color: Color.fromARGB(255, 163, 241, 154),
                              width: 0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Vibration Btn
                  Tooltip(
                    message: 'Vibration ',
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _type = 'vibration';
                          notification = false;
                          alarm = false;
                          vibration = true;
                        });
                      },
                      icon: const Icon(
                        Icons.vibration,
                        color: Color.fromARGB(255, 20, 116, 9),
                      ),
                      label: const Text(
                        'Vibration',
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 116, 9),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          vibration
                              ? const Color.fromARGB(255, 163, 241, 154)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(
                              color: Color.fromARGB(255, 163, 241, 154),
                              width: 0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text(
                'Update Reminder',
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () async {
                //Add Notification

                DateTime schTime = DateTime(
                    _reminderDayController.year,
                    _reminderDayController.month,
                    _reminderDayController.day,
                    _reminderTimeController.hour,
                    _reminderTimeController.minute);
                NotificationService().scheduleNotification(
                    title: 'FitnessMate Reminder',
                    body: _reminderName.text,
                    scheduledNotificationDateTime: schTime);
                //Add Reminder
                final String id = _id;
                final String name = _reminderName.text;
                final type = _type;
                final String message = _message.text;
                final String date =
                    DateFormat('yyyy-MM-dd').format(_reminderDayController);
                // final String date = _reminderDayController;
                final String time =
                    '${_reminderTimeController.hour.toString().padLeft(2, '0')}:${_reminderTimeController.minute.toString().padLeft(2, '0')}';
                await ReminderRepository()
                    .updateReminder(id, name, type, message, date, time);

                _reminderName.text = '';
                _message.text = '';
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    ));
  }
}

class CustomDropdownButton extends StatelessWidget {
  final List<String> options;
  final String? value;
  final Function(String?) onChanged;

  const CustomDropdownButton({
    Key? key,
    required this.options,
    required this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 10.0),
      child: DropdownButton<String>(
        value: value,
        hint: const Text('Select Category'),
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
