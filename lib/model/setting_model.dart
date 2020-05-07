class SettingModel {
  static const double minStudyPeriodValue = 25;
  static const double maxStudyPeriodValue = 60;
  static const double minBreakPeriodValue = 5;
  static const double maxBreakPeriodValue = 25;
  final double studyPeriod;
  final double breakPeriod;

  SettingModel(this.studyPeriod, this.breakPeriod);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'study_period': studyPeriod,
      'break_period': breakPeriod
    };
    return map;
  }

  static SettingModel fromMap(Map<String, dynamic> map) {
    return SettingModel(map['study_period'], map['break_period']);
  }
}