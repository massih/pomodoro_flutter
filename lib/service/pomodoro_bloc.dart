import 'dart:async';

import 'package:pomodoro/service/setting_bloc.dart';
import 'package:pomodoro/utils/database.dart';
import 'package:pomodoro/utils/pomodoro_helper.dart';
import 'package:quiver/async.dart';

class PomodoroBloc {
  static const Duration _increment = Duration(milliseconds: 500);
  static PomodoroBloc _instance;
  static CountdownTimer _countdownTimer;
  final DBHelper _dbHelper = DBHelper();
  final StreamController _streamController = StreamController<PomodoroTimer>();

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
       if (_session == PomodoroSession.STUDY) {initStudy();}
       else {initBreak();}
      }
    });
  }


  Stream<PomodoroTimer> get timer {
    return _streamController.stream;
  }

  void startStudySession(Duration _duration) {
    _session = PomodoroSession.STUDY;
    _inProgress = true;
//    final _studyPeriod = Duration(minutes: _minutes);
    final _duration = Duration(seconds: 25);
    _countdownTimer = CountdownTimer(_duration, _increment);
    _countdownTimer.listen((event) {
      final _timerData = PomodoroTimer(event.elapsed, event.remaining, PomodoroSession.STUDY, _inProgress);
      _streamController.add(_timerData);
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
      final _timerData = PomodoroTimer(event.elapsed, event.remaining, PomodoroSession.BREAK, _inProgress);
      _streamController.add(_timerData);
    });
//  TODO save the timestamp for stats
  }
  void cancelTimer() {
    _inProgress = false;
    _countdownTimer.cancel();
    initStudy();
  }

  void initStudy() async {
    _session = PomodoroSession.STUDY;
    final Duration _studyPeriod = await _dbHelper.getStudyDuration();
    final PomodoroTimer _pomodoroTimer = PomodoroTimer(
        Duration(minutes: 0),
        _studyPeriod,
        PomodoroSession.STUDY,
        _inProgress);
    _streamController.add(_pomodoroTimer);
  }

  void initBreak() async {
    _session = PomodoroSession.BREAK;
    final Duration _breakPeriod = await _dbHelper.getBreakDuration();
    final PomodoroTimer _pomodoroTimer = PomodoroTimer(
        Duration(minutes: 0),
        _breakPeriod,
        PomodoroSession.BREAK,
        _inProgress);
    _streamController.add(_pomodoroTimer);
  }


  dispose() {
    _streamController.close();
  }
}
