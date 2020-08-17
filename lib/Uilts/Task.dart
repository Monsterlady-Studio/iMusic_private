import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:studentmanager/Widgets/notification_widget.dart';

class TaskNotification {
  int read = 0;
  BuildContext _context;
  JPush jpush;
  factory TaskNotification() => _taskNotification();
  static TaskNotification get instance => _taskNotification();
  static TaskNotification _instance;

  TaskNotification._() {
    jpush = new JPush();
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    jpush.setup(
      appKey: "dbd432a6add6b7f420edeae3",
      channel: "flutter_channel",
      production: true,
      debug: true, //是否打印debug日志
    );

    /// 设置tags
    jpush.setTags(["student"]).then((value) => print(value));

    jpush.setBadge(0);
  }

  static TaskNotification _taskNotification() {
    if (_instance == null) {
      _instance = TaskNotification._();
    }
    return _instance;
  }

  void runTask(BuildContext context) async {
    if (_context == null) {
      _context = context;
      if (Platform.isIOS) {
        final map = await jpush.getLaunchAppNotification();
        if (map != null && map.isNotEmpty) {
          jump(map);
        }
      }
    }
  }

  void jump(var message) {
    if (_context != null) {
      Future.delayed(Duration(seconds: 1), () {
        showDialog(
            context: _context,
            builder: (_) => NotificationWidget(message['aps']['alert']['title'],
                message['aps']['alert']['body']));
      });
    }
  }

  void clearContext() {
    if (_context != null) {
      _context = null;
    }
  }
}
