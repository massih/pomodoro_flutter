class DateTimeHelper {
  static const Map<int, String> monthInYear = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "APR",
    5: "MAY",
    6: "JUN",
    7: "JUL",
    8: "AUG",
    9: "SEP",
    10: "OCT",
    11: "NOV",
    12: "DEC",
  };

  static List<int> yearList = List<int>.generate(5, (index) => index + 1).map((e) => e + (DateTime.now().year - 2)).toList();

}