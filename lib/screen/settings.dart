import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/model/setting_model.dart';
import 'package:pomodoro/service/setting_bloc.dart';

class SettingsPage extends StatefulWidget {

  @override
  createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> {
  final SettingBloc _settingBloc = SettingBloc();
  double _studyPeriod;
  double _breakPeriod;

  @override
  void initState() {
    _settingBloc.fetchSetting().then((value) {
      setState(() {
        _studyPeriod = value.studyPeriod;
        _breakPeriod = value.breakPeriod;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_breakPeriod == null || _studyPeriod == null) {
      return CircularProgressIndicator();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildStudyPeriodSlider(),
        buildBreakPeriodSlider(),
      ],
    );
  }

  Row buildBreakPeriodSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Break Period:'),
        Slider(
          min: SettingModel.minBreakPeriodValue,
          max: SettingModel.maxBreakPeriodValue,
          divisions: 20,
          value: _breakPeriod,
          onChanged: (value) {
            setState(() {
              _breakPeriod = value;
            });
          },
          onChangeEnd: (value) {
            SettingModel _newValue = SettingModel(_studyPeriod, value);
            _settingBloc.updateSetting(_newValue);
          },
        ),
        Text('${_breakPeriod.toInt()} min'),
      ],
    );
  }

  Row buildStudyPeriodSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Study Period:'),
        Slider(
          min: SettingModel.minStudyPeriodValue,
          max: SettingModel.maxStudyPeriodValue,
          divisions: 6,
          value: _studyPeriod,
          onChanged: (value) {
            setState(() {
              _studyPeriod = value;
            });
          },
          onChangeEnd: (value) {
            SettingModel _newValue = SettingModel(value, _breakPeriod);
            _settingBloc.updateSetting(_newValue);
          },
        ),
        Text('${_studyPeriod.toInt()} min'),
      ],
    );
  }

}

