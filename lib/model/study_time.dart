class StudyTime {
  final DateTime date;
  final int minutes;

  StudyTime(this.date, this.minutes);

  Map<String, dynamic> toMap() {
    return {
      'year': date.year,
      'month': date.month,
      'day': date.day,
      'minutes': minutes
    };
  }

  static StudyTime fromMap(Map<String, dynamic> data) {
    DateTime _datetime = new DateTime(data['year'], data['month'], data['day']);
    return StudyTime(_datetime, data['minutes']);
  }
}