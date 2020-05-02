import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/service/database.dart';
import 'package:quiver/async.dart';

class Pomodoro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  final Database _db = Database();
//  final Duration studyDuration = new Duration(minutes: 25);
  final Duration studyDuration = new Duration(seconds: 25);
  final Duration breakDuration = new Duration(minutes: 5);

  bool _inProgress;
  CountdownTimer _countdownTimer;
  Duration _timer;

  @override
  void initState() {
    super.initState();
    _inProgress = false;
    _timer = studyDuration;
  }

  void _startTimer() {
    _countdownTimer =
        new CountdownTimer(studyDuration, new Duration(seconds: 1));

    _countdownTimer.listen(_timerListener, onDone: _timerDone);
    setState(() {
      _inProgress = true;
      _countdownTimer = _countdownTimer;
      _timer = _countdownTimer.remaining;
    });
  }

  void _timerListener(CountdownTimer event) {
    Duration remainingTime = event.remaining;
    print(remainingTime);
    setState(() {
      _timer = remainingTime;
    });
  }

  void _timerDone() {
    print('Timer FINITO');
  }


  void _cancelTimer() {
    setState(() {
      _inProgress = false;
      _countdownTimer = _countdownTimer.cancel();
      _timer = studyDuration;
    });
    print('canceled');
  }
  
  String _getTimerText() {
    var minutes = _timer.inMinutes.remainder(60).toString().padLeft(2, '0');
    var seconds = _timer.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[buildTimerText(context), buildStartRaisedButton()],
        ),
      ),
    );
  }

  Text buildTimerText(BuildContext context) {
    return Text(
      _getTimerText(),
      style: TextStyle(
        fontFamily: 'digital7',
        fontSize: 84,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  RaisedButton buildStartRaisedButton() {
    return RaisedButton(
      child: Text(_inProgress ? 'Cancel' : 'Start'),
      onPressed: () {
        if (_inProgress) {
          _cancelTimer();
        } else {
          _startTimer();
        }
      },
    );
  }

}
