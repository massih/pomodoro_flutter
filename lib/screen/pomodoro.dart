import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/service/database.dart';

class Pomodoro extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _PomodoroState();

}

class _PomodoroState extends State<Pomodoro> {
  final Database _db = Database();
  bool _inProgress = false;
  DateTime _startTime;

  String _getButtonText() {
    return _inProgress ? 'Pause' : 'Start';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(_getButtonText()),
              onPressed: () {
                if (_inProgress) {
                  setState(() {
                    _inProgress = false;
                  });
                  print('Paussed');
                }else {
                  setState(() {
                    _inProgress = true;
                    _startTime = DateTime.now();
                  });
                  print(_startTime);
                }
              },
            )
          ],
        ),
      ),
    );
  }

}