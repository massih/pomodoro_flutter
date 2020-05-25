import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/model/pomodoro_model.dart';
import 'package:pomodoro/service/pomodoro_bloc.dart';
import 'package:provider/provider.dart';

class Pomodoro extends StatelessWidget {
  final PomodoroBloc _pomodoroBloc = PomodoroBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Consumer<PomodoroModel>(
              builder: (BuildContext context, PomodoroModel value, Widget child) {
                if (value == null) {
                  _pomodoroBloc.initStudy();
                  return CircularProgressIndicator();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.all(30.0),
                        child: buildTopText(value.session)
                    ),
                    buildPomodoro(context, value),
                    Container(
                      padding: const EdgeInsets.all(50.0),
                      child: buildStartRaisedButton(value),
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }

  Text buildTopText(PomodoroSession _session) {
    var _text =  _session == PomodoroSession.STUDY ? 'Focus on your task :)' : 'Take a break';
    return Text(_text);
  }

  Stack buildPomodoro(BuildContext context, PomodoroModel _data) {
    return Stack(
        children: <Widget>[
          SizedBox(
            width: 300,
            height: 300,
            child: buildCircularProgressIndicator(context, _data),
          ),
          Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: buildTimerText(_data),
              )
          ),
        ]
    );
  }

  CircularProgressIndicator buildCircularProgressIndicator(BuildContext context, PomodoroModel data) {
    return CircularProgressIndicator(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      valueColor: AlwaysStoppedAnimation<Color>(Theme
          .of(context)
          .canvasColor),
      value: _getIndicatorValue(data),
      strokeWidth: 15,
    );
  }

  Text buildTimerText(PomodoroModel _data) {
    return Text(
      _getTimerText(_data),
      style: TextStyle(
        fontFamily: 'digital7',
        fontSize: 84,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  double _getIndicatorValue(PomodoroModel _data) {
    if (_data.elapsed.inSeconds == 0) {
      return 0;
    }
    return _data.elapsed.inSeconds / (_data.remaining.inSeconds + _data.elapsed.inSeconds);
  }

  String _getTimerText(PomodoroModel _data) {
    var minutes = _data.remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    var seconds = _data.remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  RaisedButton buildStartRaisedButton(PomodoroModel _pomodoroTimer) {
    final _buttonText = _pomodoroTimer.inProgress ? 'Cancel' : 'Start';
    if (_pomodoroTimer.inProgress) {
      return RaisedButton(child: Text(_buttonText), onPressed: () {
        _pomodoroBloc.cancelTimer();
      });
    }

    if (_pomodoroTimer.session == PomodoroSession.STUDY) {
      return RaisedButton(child: Text(_buttonText), onPressed: () {
        _pomodoroBloc.startStudySession(_pomodoroTimer.remaining);
      });
    } else {
      return RaisedButton(child: Text(_buttonText), onPressed: () {
        _pomodoroBloc.startBreakSession(_pomodoroTimer.remaining);
      });
    }
  }
}
