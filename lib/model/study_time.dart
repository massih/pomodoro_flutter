class StudyTime {
  final String date;
  final String start;
  final String end;
  final int minutes;

  StudyTime(this.date, this.start, this.end, this.minutes);

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'start': start,
      'end': end,
      'minutes': minutes
    };
  }

  static StudyTime fromMap(Map<String, dynamic> data) {
    return StudyTime(data['date'], data['start'], data['end'], data['minutes']);
  }
}