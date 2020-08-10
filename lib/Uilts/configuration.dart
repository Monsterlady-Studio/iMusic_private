import 'package:flutter/material.dart';

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];

List<Map> categories = [
  {'name': 'Cats', 'iconPath': 'images/cat.png'},
  {'name': 'Dogs', 'iconPath': 'images/dog.png'},
  {'name': 'Bunnies', 'iconPath': 'images/rabbit.png'},
  {'name': 'Parrots', 'iconPath': 'images/parrot.png'},
  {'name': 'Horses', 'iconPath': 'images/horse.png'}
];

List<Map> adminItems = [
  {'icon': Icons.schedule, 'title': '课程表', 'index': 'overview'},
  {'icon': Icons.plus_one, 'title': '新增学生', 'index': 'add'},
  {
    'icon': Icons.notifications_active,
    'title': '发送通知',
    'index': 'notification'
  },
  {'icon': Icons.edit, 'title': '编辑个人资料', 'index': 'edit'},
];

List<Map> studentItems = [
  {'icon': Icons.schedule, 'title': '课程表', 'index': 'schedule'},
  {'icon': Icons.edit, 'title': '编辑个人资料', 'index': 'edit'},
  {
    'icon': Icons.notifications_active,
    'title': '打开/关闭通知',
    'index': 'editnotification'
  },
];
