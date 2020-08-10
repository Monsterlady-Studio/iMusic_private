import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentmanager/Pages/addstudent_page.dart';
import 'package:studentmanager/Pages/admin_view.dart';
import 'package:studentmanager/Pages/editAdmin_page.dart';
import 'package:studentmanager/Pages/editStudent.dart';
import 'package:studentmanager/Pages/home_page.dart';
import 'package:studentmanager/Pages/push_page.dart';
import 'package:studentmanager/Pages/student_view.dart';

import 'Pages/time_sheet.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => MyApp(),
  "/student": (BuildContext context) => StudentScreen(),
  "/admin": (BuildContext context) => AdminScreen(),
  "/push": (BuildContext context) => PushScreen(),
  "/editStudent": (BuildContext context) => AddNewStudent(),
  "/editAdmin": (BuildContext context) => EditAdminPage(),
  "/overview": (BuildContext context) => TimeSchedule(),
  "/add": (BuildContext context) => AddNewStudent(),
  "/studentEdit": (BuildContext context) => EditStudent()
};
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MaterialApp(
        debugShowCheckedModeBanner: false, home: MyApp(), routes: routes));
  });
}
