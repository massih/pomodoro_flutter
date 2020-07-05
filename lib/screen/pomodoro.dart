import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pomodoro/model/consts.dart';
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(_getTopText(pomodoroModel)),
              buildPomodoro(context, pomodoroModel),
              buildStartRaisedButton(pomodoroModel),
            ],
          );
        }),
      ),
    );
  }

  Stack buildPomodoro(BuildContext context, PomodoroModel data) {
    return Stack(children: <Widget>[
      SizedBox(
        width: 300,
        height: 300,
        child: buildCircularProgressIndicator(context, data),
      ),
      Positioned.fill(
          child: Align(
        alignment: Alignment.center,
        child: buildTimerText(data),
      )),
    ]);
  }

  CircularProgressIndicator buildCircularProgressIndicator(BuildContext context, PomodoroModel data) {
    return CircularProgressIndicator(
      backgroundColor: _getColor(data),
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

  MaterialButton buildStartRaisedButton(PomodoroModel data) {
    if (data.inProgress) {
      return _roundRaisedButton(data, () {
        _pomodoroBloc.cancelTimer();
      });
    }
    if (data.session == PomodoroSession.STUDY) {
      return _roundRaisedButton(data, () {
        _pomodoroBloc.startStudySession(data.remaining);
      });
    } else {
      return _roundRaisedButton(data, () {
        _pomodoroBloc.startBreakSession(data.remaining);
      });
    }
  }

  MaterialButton _roundRaisedButton(PomodoroModel data, Function callBack) {
    return MaterialButton(
      minWidth: 170,
      child: Text(_getButtonText(data)),
      color: _getColor(data),
      onPressed: callBack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: _getColor(data))),
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

  String _getTopText(PomodoroModel data) {
    return data.session == PomodoroSession.STUDY ? topTextStudy : topTextBreak;
  }
  String _getButtonText(PomodoroModel data) {
    return data.inProgress ? buttonTextCancel : buttonTextStart;
  }
  Color _getColor(PomodoroModel data) {
    return data.session == PomodoroSession.STUDY ? colorStudy : colorBreak;
  }

}
