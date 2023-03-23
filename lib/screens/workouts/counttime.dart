import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeCountWidget extends StatefulWidget {
  final int countTimeInMinutes;

  const TimeCountWidget({Key? key, required this.countTimeInMinutes})
      : super(key: key);

  @override
  _TimeCountWidgetState createState() => _TimeCountWidgetState();
}

class _TimeCountWidgetState extends State<TimeCountWidget> {
  late Timer _timer;
  int _remainingSeconds = 0;
  bool _isCountingDown = false;
  AudioCache _audioCache = AudioCache();

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.countTimeInMinutes * 60;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          _isCountingDown = false;
          AudioPlayer player = AudioPlayer();
          player.play(AssetSource('alarm.wav'));
        }
      });
    });
    _isCountingDown = true;
  }

  @override
  Widget build(BuildContext context) {
    String displayTime =
        '${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          displayTime,
          style: TextStyle(fontSize: 32),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isCountingDown ? null : _startCountdown,
              child: Text('START'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
