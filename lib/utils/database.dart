import 'dart:async';

import 'package:path/path.dart';
import 'package:pomodoro/model/setting_model.dart';
import 'package:pomodoro/model/study_time.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _DBNAME = "pomodoro.db";
  static const String _SETTINGS_TABLE = "settings";
  static const String _STUDY_TABLE = "statistics";
  static const int _DEFAULT_STUDY_PERIOD = 25;
  static const int _DEFAULT_BREAK_PERIOD = 5;

  static Database _database;
  static DBHelper _instance;

  static int get _version => 1;

  DBHelper._();

  factory DBHelper() {
    if (_instance == null) {
      _instance = DBHelper._();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    final String _dbPath = join(await getDatabasesPath(), _DBNAME);
    _database = await openDatabase(_dbPath, onCreate: _createTables, version: _version);
    return _database;
  }

  void _createTables(Database db, int version) {
    String _sqlQueries = "CREATE TABLE $_SETTINGS_TABLE(study_period DOUBLE, break_period DOUBLE);";
    db.execute(_sqlQueries);

    _sqlQueries = "CREATE TABLE $_STUDY_TABLE(id INTEGER PRIMARY KEY, date TEXT, start TEXT, end TEXT, minutes INT);";
    db.execute(_sqlQueries);

    _sqlQueries = "INSERT INTO $_SETTINGS_TABLE(study_period, break_period) VALUES($_DEFAULT_STUDY_PERIOD, $_DEFAULT_BREAK_PERIOD);";
    db.execute(_sqlQueries);
  }

  Future<SettingModel> settingFetch() async {
    final Database client = await database;
    final List<Map<String, dynamic>> result = await client.query(_SETTINGS_TABLE);
    return SettingModel.fromMap(result[0]);
  }

  void settingUpdate(SettingModel newSetting) async {
    final Database client = await database;
    client.update(_SETTINGS_TABLE, newSetting.toMap());
  }

  Future<Duration> getStudyDuration() async {
    double _fetchedStudyPeriod = (await settingFetch()).studyPeriod;
    return Duration(minutes: _fetchedStudyPeriod.toInt());
  }

  Future<Duration> getBreakDuration() async {
    double _fetchedBreakPeriod = (await settingFetch()).breakPeriod;
    return Duration(minutes: _fetchedBreakPeriod.toInt());
  }

  void studyTimeAdd(StudyTime data) async {
    final Database client = await database;
    client.insert(_STUDY_TABLE, data.toMap());
  }

  Future<List<StudyTime>> studyTimeGetAll() async {
    final Database client = await database;
    final List<Map<String, dynamic>> result = await client.query(_STUDY_TABLE);
    return result.map((e) => StudyTime.fromMap(e)).toList();
  }
}