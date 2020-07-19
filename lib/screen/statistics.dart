import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/model/chart/MonthlyChart.dart';
import 'package:pomodoro/model/study_time.dart';
import 'package:pomodoro/service/times_bloc.dart';
import 'package:pomodoro/utils/datetime_helper.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final TimeBloc _timeBloc = new TimeBloc();

  int month;
  int year;

  @override
  void initState() {
    var now = DateTime.now();
    month = now.month;
    year = now.year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildDropdownYear(),
              buildDropdownMonth(),
            ],
          ),
          FutureBuilder<List<StudyTime>>(
              future: _timeBloc.getAll(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("There is no record :(");
                }
                return createMonthlyChart(snapshot.data);
              }),
        ],
      )),
    );
  }

  Widget createMonthlyChart(List<StudyTime> data) {
    List<MonthlyChart> res = data.map((e) => MonthlyChart("${e.date.month}/${e.date.day}", e.minutes)).toList();
    var series = [
      new Series(id: "Monthly", data: res, domainFn: (MonthlyChart m, _) => m.date, measureFn: (MonthlyChart m, _) => m.minutes)
    ];
    var chart = new BarChart(series, animate: true, vertical: false);
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
    return chartWidget;
  }

  DropdownButton buildDropdownMonth() {
    return DropdownButton<String>(
      value: DateTimeHelper.monthInYear[this.month],
      items: DateTimeHelper.monthInYear.values
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (String newValue) {
        setState(() {
          this.month = DateTimeHelper.monthInYear.entries.firstWhere((element) => element.value == newValue).key;
        });
      },
    );
  }

  DropdownButton buildDropdownYear() {
    DateTimeHelper.yearList.map((item) => print(item));
    return DropdownButton<String>(
      value: this.year.toString(),
      items: DateTimeHelper.yearList.map((item) => DropdownMenuItem(value: item.toString(), child: Text(item.toString()),)).toList(),
      onChanged: (String newValue) {
        setState(() {
          this.year = int.parse(newValue);
        });
      },
    );
  }
}
