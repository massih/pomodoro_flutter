import 'dart:async';

import 'package:pomodoro/model/setting_model.dart';
import 'package:pomodoro/utils/database.dart';

class SettingBloc {
  final DBHelper _dbHelper = DBHelper();
  final _settingController =  StreamController<SettingModel>();

  Stream<SettingModel> get setting => _settingController.stream;

  SettingBloc() {
    fetchSetting();
  }

  fetchSetting() async {
    final SettingModel _fetchedSettings = await _dbHelper.settingFetch();
    _settingController.add(_fetchedSettings);
  }

  updateSetting(SettingModel newSetting) async {
    _dbHelper.settingUpdate(newSetting);
    fetchSetting();
  }

  dispose() {
    _settingController.close();
  }
}