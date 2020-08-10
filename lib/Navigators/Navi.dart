import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyNavigator {
  static void goToHome(BuildContext context) {
    Navigator.pushNamed(context, "/home");
  }

  static void goToStudent(BuildContext context, String serializedString) {
    // print(serializedString);
    Navigator.pushNamed(context, "/student", arguments: serializedString);
  }

  static void goToAdmin(BuildContext context, String serializedString) {
    Navigator.pushNamed(context, "/admin", arguments: serializedString);
  }

  static void goToPush(BuildContext context) {
    Navigator.pushNamed(context, "/push");
  }

  static void goToEdit(BuildContext context, String serializedString) {
    Navigator.pushNamed(context, "/add", arguments: serializedString);
  }

  static void goToAdminEdit(BuildContext context, String serializedString) {
    Navigator.pushNamed(context, "/editAdmin", arguments: serializedString);
  }

  static void gotoOverview(BuildContext context, String serializedString) {
    Navigator.pushNamed(context, "/overview", arguments: serializedString);
  }

  static void gotoAddStudent(BuildContext context) {
    Navigator.pushNamed(context, "/add");
  }

  static void gotoEditStudent(BuildContext context, String serializedString) {
    Navigator.pushNamed(context, "/studentEdit", arguments: serializedString);
  }
}

class AndroidBackTop {
  ///通讯名称,回到手机桌面
  static const String chanel = "android/back/desktop";

  //返回手机桌面事件
  static const String eventBackDesktop = "backDesktop";

  ///设置回退到手机桌面
  static Future<bool> backDesktop() async {
    final platform = MethodChannel(chanel);
    try {
      await platform.invokeMethod(eventBackDesktop);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(false);
  }
}
