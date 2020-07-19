import 'dart:async';

import 'package:pomodoro/model/study_time.dart';
import 'package:pomodoro/utils/database.dart';
import 'package:sqflite/sqflite.dart';

class TimeBloc {
  final DBHelper _dbHelper = DBHelper();
  final String _table = DBHelper.STUDY_TABLE;

  Future<List<StudyTime>> getAll() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(_table);
    return result.map((e) => StudyTime.fromMap(e)).toList();
  }

  addStudyTime(StudyTime data) async {
    final Database db = await _dbHelper.database;
    db.insert(_table, data.toMap());
  }

  Future<List<StudyTime>> getByMonth(int month) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(_table, where: "month = ?", whereArgs: [month.toString()]);
    return result.map((e) => StudyTime.fromMap(e)).toList();
  }
}
