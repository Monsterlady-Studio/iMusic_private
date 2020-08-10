import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:studentmanager/Model/school.dart';

List<String> images = [
  "assets/images/image_04.jpg",
  "assets/images/image_03.jpg",
  "assets/images/image_02.jpg",
  "assets/images/image_01.png",
];

List<String> title = [
  "Hounted Ground",
  "Fallen In Love",
  "The Dreaming Moon",
  "Jack the Persian and the Black Castel",
];

List<String> girlsimages = [
  "assets/images/girl1.jpg",
  "assets/images/girl2.jpg",
  "assets/images/girl3.jpg",
];

List<String> boysimages = [
  "assets/images/boy1.jpg",
  "assets/images/boy2.jpg",
  "assets/images/boy3.jpg",
];

const List<String> PickerData2 = ['男', '女'];

const List<int> classTimes = [0, 1, 2, 3, 4, 5, 6, 7];
const List<int> levels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

List<int> getClassNum() {
  List<int> nwlist = new List<int>();
  for (var i = 1; i <= 100; i++) {
    nwlist.add(i);
  }
  return nwlist;
}

List<String> schoolType = ['小学', '中学'];

Future<List<String>> getMiddileSchoolName() async {
  List<String> nwlist = List<String>();
  Response response;
  Dio dio = new Dio();
  response =
      await dio.get("https://restapi.amap.com/v3/place/text", queryParameters: {
    "city": 420100,
    "output": "json",
    "key": "06d4827dd602c892292af073b86bbd22",
    "extensions": "base",
    "citylimit": false,
    "types": "中学",
    "offset": 5000,
    "page": 1
  });
  for (var school in response.data['pois']) {
    nwlist.add(School.fromJson(school).name);
  }
  return nwlist;
}

Future<List<String>> getPrimarySchoolName() async {
  List<String> nwlist = List<String>();
  Response response;
  Dio dio = new Dio();
  response =
      await dio.get("https://restapi.amap.com/v3/place/text", queryParameters: {
    "city": 420100,
    "output": "json",
    "key": "06d4827dd602c892292af073b86bbd22",
    "extensions": "base",
    "citylimit": false,
    "types": "小学",
    "offset": 5000,
    "page": 1
  });
  for (var school in response.data['pois']) {
    nwlist.add(School.fromJson(school).name);
  }
  return nwlist;
}

List<Color> timesheetColors = [
  Color(0xFF484041),
  Color(0xFFE07A5F),
  Color(0xFF3D405B),
  Color(0xFF81B29A),
  Color(0xFFF2CC8F),
  Color(0xFFA18276),
  Color(0xFFB9D2B1),
  Color(0xFFDAC6B5),
  Color(0xFFF1D6B8),
  Color(0xFFFBACBE),
  Color(0xFF35FF69),
  Color(0xFF44CCFF),
  Color(0xFF7494EA),
  Color(0xFFD138BF),
];
