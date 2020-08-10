import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:studentmanager/Model/record.dart';
import 'package:studentmanager/Navigators/Navi.dart';

class RestApi {
  int counts;

  Future<bool> attendClass(LCObject lcbobject, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      if (connectivityResult == ConnectivityResult.none) {
        Fluttertoast.showToast(
            msg: '网络连接异常',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      } else {
        try {
          if (lcbobject['totalclass'] == 0 || lcbobject['totalclass'] < 0) {
            EasyLoading.instance
              ..displayDuration = const Duration(milliseconds: 1000)
              ..indicatorType = EasyLoadingIndicatorType.fadingCircle
              ..loadingStyle = EasyLoadingStyle.custom
              ..progressColor = Colors.black
              ..indicatorSize = 45.0
              ..radius = 10.0
              ..backgroundColor = Colors.red
              ..indicatorColor = Colors.white
              ..textColor = Colors.white
              ..maskType = EasyLoadingMaskType.none
              ..userInteractions = false;
            EasyLoading.showError('没有足够课时了哦!');
            return false;
          } else {
            EasyLoading.instance
              ..displayDuration = const Duration(milliseconds: 3000)
              ..indicatorType = EasyLoadingIndicatorType.chasingDots
              ..loadingStyle = EasyLoadingStyle.dark
              ..maskColor = Colors.grey.withOpacity(0.5)
              ..maskType = EasyLoadingMaskType.black
              ..userInteractions = false;
            EasyLoading.show(status: '签到中...');

            ///history
            List<Record> record = new List<Record>();
            if (lcbobject['history'] != null &&
                lcbobject['history'].length > 2) {
              for (var each in json.decode(lcbobject['history'])) {
                record.add(Record.fromJson(each));
              }
            }
            record.add(new Record(
                DateTime.now().year.toString() +
                    '-' +
                    DateTime.now().month.toString() +
                    '-' +
                    DateTime.now().day.toString() +
                    ' ' +
                    DateTime.now().hour.toString() +
                    ':' +
                    DateTime.now().minute.toString() +
                    ':' +
                    DateTime.now().second.toString(),
                (lcbobject['totalclass'] - 1).toString()));
            print(json.encode(record));
            lcbobject['history'] = json.encode(record).toString();
            lcbobject.increment('totalclass', -1);
            await lcbobject.save();
            return true;
          }
        } on LCException catch (e) {
          if (e.code == 305) {
            EasyLoading.instance
              ..displayDuration = const Duration(milliseconds: 1000)
              ..indicatorType = EasyLoadingIndicatorType.fadingCircle
              ..loadingStyle = EasyLoadingStyle.custom
              ..progressColor = Colors.black
              ..indicatorSize = 45.0
              ..radius = 10.0
              ..backgroundColor = Colors.red
              ..indicatorColor = Colors.white
              ..textColor = Colors.white
              ..maskType = EasyLoadingMaskType.none
              ..userInteractions = false;
            EasyLoading.showError("签到失败");
            return false;
          }
        }
      }
    } on Exception catch (e) {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1000)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..progressColor = Colors.black
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..backgroundColor = Colors.red
        ..indicatorColor = Colors.white
        ..textColor = Colors.white
        ..maskType = EasyLoadingMaskType.none
        ..userInteractions = false;
      EasyLoading.showError("签到失败");
      return false;
    }
  }

  void login(String string, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1000)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..progressColor = Colors.black
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..backgroundColor = Colors.red
        ..indicatorColor = Colors.white
        ..textColor = Colors.white
        ..maskType = EasyLoadingMaskType.none
        ..userInteractions = false;
      EasyLoading.showError('网络连接异常');
      return;
    } else {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.chasingDots
        ..loadingStyle = EasyLoadingStyle.dark
        ..maskColor = Colors.grey.withOpacity(0.5)
        ..maskType = EasyLoadingMaskType.black
        ..userInteractions = false;
      EasyLoading.show(status: '登录中...');
      int isCorrect = await RestApi().determineRoute(string);
      String hint = isCorrect != 2 ? '登录成功' : '代码不正确';
      if (isCorrect != 2) {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..progressColor = Colors.black
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..backgroundColor = Colors.green
          ..indicatorColor = Colors.yellow
          ..textColor = Colors.yellow
          ..maskType = EasyLoadingMaskType.none
          ..userInteractions = false;
        EasyLoading.showSuccess(hint);
        Timer(new Duration(milliseconds: 1000), () async {
          if (isCorrect == 0) {
            String teacher = await getTeacherByCode(string);
            MyNavigator.goToAdmin(context, teacher);
          } else {
            String student = await getStudentByCode(string);
            //print(student);
            MyNavigator.goToStudent(context, student);
          }
        });
      } else {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..progressColor = Colors.black
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..backgroundColor = Colors.red
          ..indicatorColor = Colors.white
          ..textColor = Colors.white
          ..maskType = EasyLoadingMaskType.none
          ..userInteractions = false;
        EasyLoading.showError(hint);
      }
    }
  }

  Future<int> determineRoute(String str) async {
    int type = 2;
    //precondition
    if (str == 'null') {
      return 2;
    }
    //check student
    LCQuery<LCObject> query = new LCQuery<LCObject>('student');
    query.whereEqualTo('code', str);
    List<LCObject> list = await query.find();
    list.forEach((object) {
      if (str == object['code']) {
        type = 1;
      }
    });
    //check teacher
    LCQuery<LCObject> query1 = new LCQuery<LCObject>('admin');
    query1.whereEqualTo('password', str);
    List<LCObject> admins = await query1.find();
    //assert(admins.length > 0);
    admins.forEach((object) {
      if (str == object['password']) {
        type = 0;
      }
    });
    //access denied
    return type;
  }

  Future<String> getStudentByCode(String str) async {
    String serializedString;
    LCQuery<LCObject> query = new LCQuery<LCObject>('student');
    query.whereEqualTo('code', str);
    List<LCObject> list = await query.find();
    list.forEach((object) {
      if (str == object['code']) {
        serializedString = object.toString();
      }
    });
    return serializedString;
  }

  Future<String> getTeacherByCode(String str) async {
    String serializedString;
    LCQuery<LCObject> query = new LCQuery<LCObject>('admin');
    query.whereEqualTo('password', str);
    List<LCObject> list = await query.find();
    list.forEach((object) {
      if (str == object['password']) {
        serializedString = object.toString();
      }
    });
    return serializedString;
  }

  Future<void> saveEditedStudent(
      LCObject lcObject, BuildContext context, bool isEditMode) async {
    //print(lcObject);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1000)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..progressColor = Colors.black
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..backgroundColor = Colors.red
        ..indicatorColor = Colors.white
        ..textColor = Colors.white
        ..maskType = EasyLoadingMaskType.none
        ..userInteractions = false;
      EasyLoading.showError(
        '网络连接异常',
      );
    } else {
      try {
        EasyLoading.instance
          ..indicatorType = EasyLoadingIndicatorType.chasingDots
          ..loadingStyle = EasyLoadingStyle.dark
          ..maskColor = Colors.grey.withOpacity(0.5)
          ..maskType = EasyLoadingMaskType.black
          ..userInteractions = false;
        EasyLoading.show(status: '加载中...');
        await lcObject.save(fetchWhenSave: true).then((value) {
          EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 1000)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..progressColor = Colors.black
            ..indicatorSize = 45.0
            ..radius = 10.0
            ..backgroundColor = Colors.green
            ..indicatorColor = Colors.yellow
            ..textColor = Colors.yellow
            ..maskType = EasyLoadingMaskType.none
            ..userInteractions = false;
          EasyLoading.showSuccess('保存成功！');
          Timer(new Duration(milliseconds: 2000), () async {
            Navigator.pop(context, isEditMode);
          });
          print(value.toString());
        });
      } on LCException catch (e) {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..progressColor = Colors.black
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..backgroundColor = Colors.red
          ..indicatorColor = Colors.white
          ..textColor = Colors.white
          ..maskType = EasyLoadingMaskType.none
          ..userInteractions = false;
        EasyLoading.showError('更新失败');
      }
    }
  }

  Future<void> uploadProfile(LCObject lcObject, BuildContext context) async {
    //print(lcObject);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1000)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..progressColor = Colors.black
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..backgroundColor = Colors.red
        ..indicatorColor = Colors.white
        ..textColor = Colors.white
        ..maskType = EasyLoadingMaskType.none
        ..userInteractions = false;
      EasyLoading.showError(
        '网络连接异常',
      );
    } else {
      try {
        EasyLoading.instance
          ..indicatorType = EasyLoadingIndicatorType.chasingDots
          ..loadingStyle = EasyLoadingStyle.dark
          ..maskColor = Colors.grey.withOpacity(0.5)
          ..maskType = EasyLoadingMaskType.black
          ..userInteractions = false;
        EasyLoading.show(status: '加载中...');
        await lcObject.save(fetchWhenSave: true).then((value) {
          EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 1000)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..progressColor = Colors.black
            ..indicatorSize = 45.0
            ..radius = 10.0
            ..backgroundColor = Colors.green
            ..indicatorColor = Colors.yellow
            ..textColor = Colors.yellow
            ..maskType = EasyLoadingMaskType.none
            ..userInteractions = false;
          EasyLoading.showSuccess('保存成功！');
          Timer(new Duration(milliseconds: 2000), () async {
            MyNavigator.goToStudent(context, value.toString());
          });
          print(value.toString());
        });
      } on LCException catch (e) {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..progressColor = Colors.black
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..backgroundColor = Colors.red
          ..indicatorColor = Colors.white
          ..textColor = Colors.white
          ..maskType = EasyLoadingMaskType.none
          ..userInteractions = false;
        EasyLoading.showError('更新失败');
      }
    }
  }

  Future<void> pushNotification(var sample, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1000)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..progressColor = Colors.black
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..backgroundColor = Colors.red
        ..indicatorColor = Colors.white
        ..textColor = Colors.white
        ..maskType = EasyLoadingMaskType.none
        ..userInteractions = false;
      EasyLoading.showError(
        '网络连接异常',
      );
    } else {
      try {
        EasyLoading.instance
          ..indicatorType = EasyLoadingIndicatorType.chasingDots
          ..loadingStyle = EasyLoadingStyle.dark
          ..maskColor = Colors.grey.withOpacity(0.5)
          ..maskType = EasyLoadingMaskType.black
          ..userInteractions = false;
        EasyLoading.show(status: '加载中...');
        var dio = new Dio();
        dio.options.headers['Content-Type'] = 'application/json';
        dio.options.headers["Authorization"] =
            "Basic ZGJkNDMyYTZhZGQ2YjdmNDIwZWRlYWUzOmY0ODZlMWJmNTQyMGI4YTIyMzQyYzk2OQ==";
        await dio
            .post('https://api.jpush.cn/v3/push', data: sample)
            .whenComplete(() {
          EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 1000)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..progressColor = Colors.black
            ..indicatorSize = 45.0
            ..radius = 10.0
            ..backgroundColor = Colors.green
            ..indicatorColor = Colors.yellow
            ..textColor = Colors.yellow
            ..maskType = EasyLoadingMaskType.none
            ..userInteractions = false;
          EasyLoading.showSuccess('发布成功！');
        });
      } on DioError catch (e) {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..progressColor = Colors.black
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..backgroundColor = Colors.red
          ..indicatorColor = Colors.white
          ..textColor = Colors.white
          ..maskType = EasyLoadingMaskType.none
          ..userInteractions = false;
        EasyLoading.showError('发布失败！');
      }
    }
  }

  String getStudentName(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    String name = newObject['name'];
    return name;
  }

  String getStudentCode(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    String code = newObject['code'];
    return code;
  }

  String getStudentBirthday(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    String birthday = newObject['birthday'];
    return birthday;
  }

  String getStudentComment(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    String comment = newObject['comment'];
    return comment;
  }

  bool getStudentGender(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    bool gender = newObject['gender'];
    return gender;
  }

  String getStudentLevel(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    String level = newObject['level'];
    return level;
  }

  String getStudentTotalClass(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    int totalClass = newObject['totalclass'];
    return totalClass.toString();
  }

  String getStudentSchool(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    String school = newObject['school'];
    return school;
  }

  LCObject getObject(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    return newObject;
  }

  String getAdminCode(String serializedString) {
    LCObject newObject = LCObject.parseObject(serializedString);
    String code = newObject['password'];
    return code;
  }

  Future<int> getCount() async {
    LCQuery<LCObject> query = new LCQuery<LCObject>('student');
    int count = await query.count();
    return count;
  }

  Future<List<LCObject>> getStudentList() async {
    LCQuery<LCObject> query = new LCQuery<LCObject>('student');
    List<LCObject> list = await query.find();
    return list;
  }
}
