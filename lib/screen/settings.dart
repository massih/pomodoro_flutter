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

  @override
  Widget build(BuildContext context) {
//    TODO change to CONSUMER and change this stateful, save in DB onChangeDone
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<SettingModel>(
            stream: _settingBloc.setting,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('LOADING...');
              }
              SettingModel _fetchedSetting = snapshot.data;
              return Wrap(
                children: <Widget>[
                  buildStudyPeriodSlider(_fetchedSetting),
                  buildBreakPeriodSlider(_fetchedSetting)
                ],
              );
            }
        )
      ],
    );
  }

  Row buildBreakPeriodSlider(SettingModel _fetchedSetting) {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Break Period:'),
                    Slider(
                      min: SettingModel.minBreakPeriodValue,
                      max: SettingModel.maxBreakPeriodValue,
                      divisions: 20,
                      value: _fetchedSetting.breakPeriod,
                      onChanged: (value) {
                        SettingModel _newValue = SettingModel(_fetchedSetting.studyPeriod, value);
                        _settingBloc.updateSetting(_newValue);
                      },
                    ),
                    Text('${_fetchedSetting.breakPeriod.toInt()} min'),
                  ],
                );
  }

  Row buildStudyPeriodSlider(SettingModel _fetchedSetting) {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Study Period:'),
                    Slider(
                      min: SettingModel.minStudyPeriodValue,
                      max: SettingModel.maxStudyPeriodValue,
                      divisions: 6,
                      value: _fetchedSetting.studyPeriod,
                      onChanged: (value) {
                        SettingModel _newValue = SettingModel(value, _fetchedSetting.breakPeriod);
                        _settingBloc.updateSetting(_newValue);
                      },
                    ),
                    Text('${_fetchedSetting.studyPeriod.toInt()} min'),
                  ],
                );
  }

}

