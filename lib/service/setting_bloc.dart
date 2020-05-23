import 'dart:async';

import 'package:pomodoro/model/setting_model.dart';
import 'package:pomodoro/utils/database.dart';

class SettingBloc {
  final DBHelper _dbHelper = DBHelper();
  static StreamController settingController = StreamController<SettingModel>.broadcast();

  Stream<SettingModel> get setting => settingController.stream;

  SettingBloc() {
    fetchSetting();
  }

  Future<SettingModel> fetchSetting() async {
    final SettingModel _fetchedSettings = await _dbHelper.settingFetch();
    settingController.sink.add(_fetchedSettings);
    return _fetchedSettings;
  }

  updateSetting(SettingModel newSetting) async {
    _dbHelper.settingUpdate(newSetting);
    fetchSetting();
  }

  dispose() {
    settingController.close();
  }
}