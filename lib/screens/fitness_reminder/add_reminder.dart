import 'package:date_time_picker/date_time_picker.dart';
import 'package:fitness_mate/services/reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({Key? key}) : super(key: key);

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final TextEditingController _reminderNameController = TextEditingController();
  TimeOfDay _reminderTimeController = TimeOfDay.now();
  DateTime _reminderDayController = DateTime.now();
  final TextEditingController _reminderTypeController = TextEditingController();
  final TextEditingController _reminderMessageController =
      TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _reminderDayController,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _reminderDayController)
      setState(() {
        _reminderDayController = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTimeController,
    );
    if (picked != null && picked != _reminderTimeController)
      setState(() {
        _reminderTimeController = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _reminderNameController,
            decoration: const InputDecoration(labelText: 'Reminder Name'),
          ),
          TextField(
            controller: _reminderTypeController,
            decoration: const InputDecoration(labelText: 'Type'),
          ),
          TextField(
            controller: _reminderMessageController,
            decoration: const InputDecoration(labelText: 'Message'),
          ),
          Row(
            children: [
              Expanded(
                child: Text('Selected Date: $_reminderDayController'),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Select Date'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Selected Time: $_reminderTimeController'),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: const Text('Select Time'),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () async {
              final String name = _reminderNameController.text;
              final String type = _reminderTypeController.text;
              final String message = _reminderMessageController.text;
              await ReminderRepository().addReminder(name, type, message);

              _reminderNameController.text = '';
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
