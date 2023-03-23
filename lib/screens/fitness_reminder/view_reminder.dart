import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ViewReminder extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;

  const ViewReminder({Key? key, this.documentSnapshot}) : super(key: key);

  @override
  State<ViewReminder> createState() => _ViewReminderState();
}

class _ViewReminderState extends State<ViewReminder> {
  late TextEditingController _reminderName;
  late TextEditingController _message;
  late String _date;
  late String _time;
  late String _type;

  @override
  void initState() {
    super.initState();

    _reminderName =
        TextEditingController(text: widget.documentSnapshot!['reminderName']);
    _message = TextEditingController(text: widget.documentSnapshot!['message']);
    _date = widget.documentSnapshot!['date'];
    _time = widget.documentSnapshot!['time'];
    _type = widget.documentSnapshot!['type'];

    _checkType();
  }

  bool notification = false;
  bool alarm = false;
  bool vibration = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reminder'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fitness1.jpg"),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Stack(
          children: [
            Card(
              margin:
                  EdgeInsets.only(top: 18, right: 18, left: 18, bottom: 200),
              color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                    child: Text(
                      _reminderName.text,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8, left: 8),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton.icon(
                            onPressed: () => {},
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
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 18.0),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 241, 255, 239),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton.icon(
                            onPressed: () => {},
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
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 18.0),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 241, 255, 239),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 50.0, right: 50.0, bottom: 20),
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
                              '✓',
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
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                              'X',
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
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                              'X',
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
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                  Container(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      _message.text,
                    ),
                  )
                ],
              ),
            )
          ],
          // child: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(children: [
          //     Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: ElevatedButton.icon(
          //         onPressed: () => {},
          //         icon: const Icon(
          //           Icons.calendar_today,
          //           color: Color.fromARGB(255, 20, 116, 9),
          //         ),
          //         label: const Text(
          //           "Hello",
          //           style: TextStyle(
          //             fontSize: 18,
          //             color: Color.fromARGB(255, 20, 116, 9),
          //           ),
          //         ),
          //         style: ButtonStyle(
          //           padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          //             const EdgeInsets.symmetric(
          //                 vertical: 12.0, horizontal: 18.0),
          //           ),
          //           backgroundColor: MaterialStateProperty.all<Color>(
          //             const Color.fromARGB(255, 163, 241, 154),
          //           ),
          //         ),
          //       ),
          //     ),
          //     const Spacer(),
          //     Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: ElevatedButton.icon(
          //         onPressed: () => {},
          //         icon: const Icon(
          //           Icons.watch_later,
          //           color: Color.fromARGB(255, 20, 116, 9),
          //         ),
          //         label: const Text(
          //           "Hello",
          //           style: TextStyle(
          //             fontSize: 18,
          //             color: Color.fromARGB(255, 20, 116, 9),
          //           ),
          //         ),
          //         style: ButtonStyle(
          //           padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          //             const EdgeInsets.symmetric(
          //                 vertical: 12.0, horizontal: 18.0),
          //           ),
          //           backgroundColor: MaterialStateProperty.all<Color>(
          //             const Color.fromARGB(255, 163, 241, 154),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ]),
          // ),
        ),
      ),
    );
  }
}
