class Event {
  final int weekday;
  final String start;

  Event(this.weekday, this.start);

  Event.fromJson(Map<String, dynamic> json)
      : weekday = json["weekday"],
        start = json["start"];

  Map<String, dynamic> toJson() => {
        "weekday": weekday,
        "start": start,
      };

  @override
  String toString() {
    String weekday;
    switch (this.weekday) {
      case 1:
        weekday = "星期一";
        break;
      case 2:
        weekday = "星期二";
        break;
      case 3:
        weekday = "星期三";
        break;
      case 4:
        weekday = "星期四";
        break;
      case 5:
        weekday = "星期五";
        break;
      case 6:
        weekday = "星期六";
        break;
      case 7:
        weekday = "星期天";
        break;
    }
    return weekday + ' ' + this.start;
  }
}
