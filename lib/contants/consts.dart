import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pomodoro/model/pomodoro_model.dart';

Map<PomodoroSession, Constants> sessionValues = {
  PomodoroSession.STUDY: Constants('Focus on your task :)', Colors.red),
  PomodoroSession.BREAK: Constants('Take a break', Colors.blue),
};

class Constants {
  final String topText;
  final Color color;

  Constants(this.topText, this.color);
}
