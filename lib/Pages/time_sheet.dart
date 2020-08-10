import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:studentmanager/Model/event.dart';
import 'package:studentmanager/Uilts/api.dart';
import 'package:studentmanager/Uilts/data.dart';
import 'package:studentmanager/Uilts/fontsStyle.dart';

class TimeSchedule extends StatefulWidget {
  @override
  _timescheduleState createState() => new _timescheduleState();
}

class _timescheduleState extends State<TimeSchedule> {
  String serializedNum;
  List<FlutterWeekViewEvent> posts = List<FlutterWeekViewEvent>();
  DateTime qwe = DateTime.now();
  void getPostsList(String serializedNum) async {
    if (serializedNum == 'admin') {
      final fetchedPosts = await getEvents();
      setState(() {
        posts = fetchedPosts;
      });
    } else {
      final fetchedPosts = await getStudentEvents(serializedNum);
      setState(() {
        posts = fetchedPosts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String serializedNum = ModalRoute.of(context).settings.arguments;
    if (posts == null) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                        child: new FlareActor(
                      "assets/animation/wait.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      animation: "animation",
                    )),
                  ])
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: Colors.black),
          title: Center(
            child: Text(
              '课程总览',
              style: medium,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                getPostsList(serializedNum);
                Fluttertoast.showToast(
                    msg: "已刷新",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.yellow,
                    fontSize: 16.0);
              },
              icon: Icon(
                Icons.refresh,
                color: Color(0xFF1b1e44),
              ),
            ),
          ],
        ),
        body: WeekView(
          dayViewStyleBuilder: (qwe) {
            return DayViewStyle(
              backgroundColor: Colors.white,
              currentTimeRuleColor: Colors.green,
              currentTimeRuleHeight: ScreenUtil().setHeight(5),
            );
          },
          style: WeekViewStyle(
              hourRowHeight: ScreenUtil().setHeight(200),
              dayBarHeight: ScreenUtil().setHeight(100),
              dayViewWidth: ScreenUtil().setWidth(205),
              dayBarTextStyle: medium,
              dayViewSeparatorColor: Colors.black,
              dayBarBackgroundColor: Colors.white,
              hoursColumnBackgroundColor: Colors.white,
              dayViewSeparatorWidth: ScreenUtil().setWidth(5),
              dateFormatter: (int year, int month, int day) {
                DateTime nw = new DateTime(year, month, day);
                String weekday;
                switch (nw.weekday) {
                  case 1:
                    weekday = '星期一';
                    break;
                  case 2:
                    weekday = '星期二';
                    break;
                  case 3:
                    weekday = '星期三';
                    break;
                  case 4:
                    weekday = '星期四';
                    break;
                  case 5:
                    weekday = '星期五';
                    break;
                  case 6:
                    weekday = '星期六';
                    break;
                  case 7:
                    weekday = '星期天';
                    break;
                }
                return ' ' +
                    weekday +
                    '\n' +
                    nw.month.toString() +
                    '月' +
                    nw.day.toString() +
                    '日';
              }),
          dates: getDates(),
          events: posts,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        serializedNum = ModalRoute.of(context).settings.arguments;
      });
      print(serializedNum);
      getPostsList(serializedNum);
    });
  }
}

List<DateTime> getDates() {
  DateTime now = DateTime.now();
  DateTime date = DateTime(now.year, now.month, now.day, now.weekday);
  return [
    date,
    date.add(const Duration(days: 1)),
    date.add(const Duration(days: 2)),
    date.add(const Duration(days: 3)),
    date.add(const Duration(days: 4)),
    date.add(const Duration(days: 5)),
    date.add(const Duration(days: 6))
  ];
}

Future<List<FlutterWeekViewEvent>> getStudentEvents(
    String serializedNum) async {
  List<FlutterWeekViewEvent> eventslist = List<FlutterWeekViewEvent>();
  LCQuery<LCObject> query = new LCQuery<LCObject>('student');
  query.whereEqualTo('code', RestApi().getStudentCode(serializedNum));
  List<LCObject> list = await query.find();
  list.forEach((object) {
    print(object.toString() + "6589");
    for (var events in json.decode(object['events'])) {
      eventslist.add(nwEvent(
          object['name'],
          object['phone'],
          Event.fromJson(events).weekday,
          Event.fromJson(events).start,
          object['StudentID']));
    }
  });
  return eventslist;
}

Future<List<FlutterWeekViewEvent>> getEvents() async {
  List<FlutterWeekViewEvent> eventslist = List<FlutterWeekViewEvent>();
  LCQuery<LCObject> query = new LCQuery<LCObject>('student');
  query.whereExists('events');
  List<LCObject> list = await query.find();
  list.forEach((object) {
    print(object.toString() + "6589");
    for (var events in json.decode(object['events'])) {
      eventslist.add(nwEvent(
          object['name'],
          object['phone'],
          Event.fromJson(events).weekday,
          Event.fromJson(events).start,
          object['StudentID']));
    }
  });
  return eventslist;
}

FlutterWeekViewEvent nwEvent(
    String name, String phone, int weekday, String startTime, int studentNum) {
  DateTime now = DateTime.now();
  DateTime nowDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
  print(nowDate.weekday);
  DateTime date;
  print(name + " " + phone + " " + weekday.toString() + " " + startTime);
  if (weekday == nowDate.weekday) {
    date = nowDate;
  } else if (weekday == 7) {
    date = nowDate.add(Duration(days: 7 - nowDate.weekday));
  } else {
    date = nowDate.add(Duration(
        days: now.weekday > weekday
            ? 7 - (now.weekday - weekday)
            : (weekday - now.weekday)));
  }
  List<String> time = startTime.split(':');
  int hour = int.parse(time[0]);
  print(hour);
  int minus = int.parse(time[1]);
  print(minus);
  return FlutterWeekViewEvent(
      title: name,
      description: phone == "未填写" ? '未填写' : phone,
      start: date.add(Duration(hours: hour, minutes: minus)),
      end: date.add(Duration(hours: hour + 1, minutes: minus)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: timesheetColors[studentNum % timesheetColors.length]),
      onLongPress: () {
        Fluttertoast.showToast(
            msg: "已复制电话号码",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.yellow,
            fontSize: 16.0);
      },
      textStyle: TextStyle(fontSize: ScreenUtil().setSp(25)));
}
