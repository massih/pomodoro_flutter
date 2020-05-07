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

//  final Duration studyDuration = Duration(minutes: 25);
  final Duration studyDuration = Duration(seconds: 25);
  final Duration breakDuration = Duration(minutes: 5);

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
    _countdownTimer = CountdownTimer(studyDuration, Duration(seconds: 1));

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

  double _getIndicatorValue() {
    if (!_inProgress) {
      return 0;
    }
    return _countdownTimer.elapsed.inSeconds / (_countdownTimer.remaining.inSeconds + _countdownTimer.elapsed.inSeconds);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: buildCircularProgressIndicator(context),
                    ),
                    Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: buildTimerText(context),
                        )
                    ),
                  ]
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: buildStartRaisedButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CircularProgressIndicator buildCircularProgressIndicator(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
      valueColor: AlwaysStoppedAnimation<Color>(Theme
          .of(context)
          .canvasColor),
      value: _getIndicatorValue(),
      strokeWidth: 15,
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
