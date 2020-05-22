import 'dart:async';

import 'package:pomodoro/service/setting_bloc.dart';
import 'package:pomodoro/utils/database.dart';
import 'package:pomodoro/model/pomodoro_model.dart';
import 'package:quiver/async.dart';

class PomodoroBloc {
  static const Duration _increment = Duration(milliseconds: 500);
  static PomodoroBloc _instance;
  static CountdownTimer _countdownTimer;
  final DBHelper _dbHelper = DBHelper();
  final StreamController _streamController = StreamController<PomodoroModel>();

  bool _inProgress = false;
  PomodoroSession _session;

  factory PomodoroBloc() {
    if (_instance == null) {
      _instance = PomodoroBloc._();
    }
    return _instance;
  }


  PomodoroBloc._() {
    SettingBloc.settingController.stream.listen((event) {
      if (!_inProgress) {
        if (_session == PomodoroSession.STUDY) {
          initStudy();
        }
        else {
          initBreak();
        }
      }
    });
  }

  Stream<PomodoroModel> get timer {
    return _streamController.stream;
  }

  void startStudySession(Duration _duration) {
    _session = PomodoroSession.STUDY;
    _inProgress = true;
//    final _studyPeriod = Duration(minutes: _minutes);
    final _duration = Duration(seconds: 25);
    _countdownTimer = CountdownTimer(_duration, _increment);
    _countdownTimer.listen((event) {
      streamPomodoroTimer(event);
    }, onDone: () {
      initBreak();
    });
//  TODO save the timestamp for stats
  }

  void startBreakSession(Duration _duration) {
    _session = PomodoroSession.BREAK;
    _inProgress = true;

    _countdownTimer = CountdownTimer(_duration, _increment);
    _countdownTimer.listen((event) {
      streamPomodoroTimer(event);
    }, onDone: () {
      initStudy();
    });
//  TODO save the timestamp for stats
  }

  void cancelTimer() {
    _countdownTimer.cancel();
    initStudy();
  }

  void initStudy() async {
    _inProgress = false;
    _session = PomodoroSession.STUDY;
    final Duration _studyPeriod = await _dbHelper.getStudyDuration();
    final PomodoroModel _pomodoroTimer = PomodoroModel(
        Duration(minutes: 0),
        _studyPeriod,
        _session,
        _inProgress);
    _streamController.add(_pomodoroTimer);
  }

  void initBreak() async {
    _inProgress = false;
    _session = PomodoroSession.BREAK;

    final Duration _breakPeriod = await _dbHelper.getBreakDuration();
    final PomodoroModel _pomodoroTimer = PomodoroModel(
        Duration(minutes: 0),
        _breakPeriod,
        _session,
        _inProgress);
    _streamController.add(_pomodoroTimer);
  }

  void streamPomodoroTimer(CountdownTimer event) {
    final _timerData = PomodoroModel(event.elapsed, event.remaining, _session, _inProgress);
    _streamController.add(_timerData);
  }


  dispose() {
    _streamController.close();
  }
}
