class School {
  final String name;

  School(this.name);

  School.fromJson(Map<String, dynamic> json) : name = json["name"];
}
