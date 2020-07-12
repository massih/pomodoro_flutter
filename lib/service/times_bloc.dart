import 'dart:async';

import 'package:pomodoro/model/study_time.dart';
import 'package:pomodoro/utils/database.dart';

class TimeBloc {
  final DBHelper _dbHelper = DBHelper();

  Future<List<StudyTime>> fetchAllStudyTimes() async {
    return await _dbHelper.studyTimeGetAll();
  }

  addStudyTime(StudyTime data) async {
    _dbHelper.studyTimeAdd(data);
  }
}
