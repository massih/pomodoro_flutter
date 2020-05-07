import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _studySliderValue;
  double _breakSliderValue;

  @override
  void initState() {
    _studySliderValue = 25;
    _breakSliderValue = 5;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center ,
      children: <Widget>[
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Study Period:'),
              Slider(
                min: 25,
                max: 60,
                divisions: 7,
                value: _studySliderValue,
                onChanged: (value) {
                  setState(() {
                    _studySliderValue = value;
                  });
                },
              ),
              Text('${_studySliderValue.toInt()} min'),
            ],
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Break Period:'),
              Slider(
                min: 5,
                max: 25,
                value: _breakSliderValue,
                onChanged: (value) {
                  setState(() {
                    _breakSliderValue = value;
                  });
                },
              ),
              Text('${_breakSliderValue.toInt()} min'),
            ],
          ),
        )
      ],);
  }
}