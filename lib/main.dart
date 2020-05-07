import 'package:flutter/material.dart';
import 'package:pomodoro/screen/pomodoro.dart';
import 'package:pomodoro/screen/settings.dart';
import 'package:pomodoro/screen/statistics.dart';
import 'package:pomodoro/service/pomodoro_bloc.dart';
import 'package:pomodoro/service/setting_bloc.dart';
import 'package:pomodoro/utils/pomodoro_helper.dart';
import 'package:provider/provider.dart';

import 'model/setting_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  final List<Widget> _widgetOptions = <Widget>[
    Statistics(),
    Pomodoro(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<SettingModel>.value(value: SettingBloc().setting),
        StreamProvider<PomodoroTimer>.value(value: PomodoroBloc().timer)
      ],
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.red,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.equalizer),
              title: Text('Stats'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              title: Text('Timer'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}