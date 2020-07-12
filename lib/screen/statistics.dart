import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/model/study_time.dart';
import 'package:pomodoro/service/times_bloc.dart';

class Statistics extends StatelessWidget {
  final TimeBloc _timeBloc = new TimeBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<List<StudyTime>>(
              future: _timeBloc.fetchAllStudyTimes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("There is no record :(");
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, int index) {
                      final item = snapshot.data[index];
                      return Card(
                        child: ListTile(
                            title: Text("${item.date} -> ${item.start} - ${item.end} for ${item.minutes} minutes")
                        ),
                      );
                    });
              })),
    );
  }
}
