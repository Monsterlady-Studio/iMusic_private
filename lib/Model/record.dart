class Record {
  final String time;
  final String restClasses;

  Record(this.time, this.restClasses);

  Map<String, dynamic> toJson() => {"time": time, "rest": restClasses};

  Record.fromJson(Map<String, dynamic> json)
      : time = json["time"],
        restClasses = json["rest"];

  @override
  String toString() {
    // TODO: implement toString
    return this.time + this.restClasses;
  }
}
