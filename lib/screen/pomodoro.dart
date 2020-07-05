import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pomodoro/contants/consts.dart';
import 'package:pomodoro/model/pomodoro_model.dart';
import 'package:pomodoro/service/pomodoro_bloc.dart';
import 'package:provider/provider.dart';

class Pomodoro extends StatelessWidget {
  final PomodoroBloc _pomodoroBloc = PomodoroBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<PomodoroModel>(builder: (BuildContext context, PomodoroModel pomodoroModel, Widget child) {
          if (pomodoroModel == null) {
            _pomodoroBloc.initStudy();
            return CircularProgressIndicator();
          }
          var _sessionValue = sessionValues[pomodoroModel.session];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(_sessionValue.topText),
              buildPomodoro(context, pomodoroModel),
              buildStartRaisedButton(pomodoroModel, _sessionValue.color),
            ],
          );
        }),
      ),
    );
  }

  Stack buildPomodoro(BuildContext context, PomodoroModel _data) {
    return Stack(children: <Widget>[
      SizedBox(
        width: 300,
        height: 300,
        child: buildCircularProgressIndicator(context, _data),
      ),
      Positioned.fill(
          child: Align(
        alignment: Alignment.center,
        child: buildTimerText(_data),
      )),
    ]);
  }

  CircularProgressIndicator buildCircularProgressIndicator(BuildContext context, PomodoroModel data) {
    return CircularProgressIndicator(
      backgroundColor: data.session == PomodoroSession.STUDY ? Theme.of(context).primaryColor : Colors.blue,
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).canvasColor),
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

  MaterialButton buildStartRaisedButton(PomodoroModel _pomodoroTimer, Color color) {
    final _buttonText = _pomodoroTimer.inProgress ? 'Cancel' : 'Start';
    if (_pomodoroTimer.inProgress) {
      return _roundRaisedButton(_buttonText, color, () {
        _pomodoroBloc.cancelTimer();
      });
    }
    if (_pomodoroTimer.session == PomodoroSession.STUDY) {
      return _roundRaisedButton(_buttonText, color,() {
        _pomodoroBloc.startStudySession(_pomodoroTimer.remaining);
      });
    } else {
      return _roundRaisedButton(_buttonText, color, () {
        _pomodoroBloc.startBreakSession(_pomodoroTimer.remaining);
      });
    }
  }

  MaterialButton _roundRaisedButton(String label, Color color, Function callBack) {
    return MaterialButton(
      minWidth: 170,
      child: Text(label),
      color: color,
      onPressed: callBack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red)),
    );
  }
}
