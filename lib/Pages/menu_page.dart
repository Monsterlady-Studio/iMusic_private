import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentmanager/Navigators/Navi.dart';
import 'package:studentmanager/Uilts/api.dart';
import 'package:studentmanager/Widgets/brandName.dart';

import '../Navigators/Navi.dart';
import '../Uilts/configuration.dart';
import '../Uilts/fontsStyle.dart';

// ignore: must_be_immutable
class DrawerScreen extends StatefulWidget {
  bool isAdmin;
  String serial;
  DrawerScreen(bool b, String serial) {
    this.isAdmin = b;
    this.serial = serial;
  }
  @override
  _DrawerScreenState createState() => _DrawerScreenState(isAdmin, serial);
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isAdmin;
  String serial;
  String animationName;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _DrawerScreenState(isAdmin, serial) {
    this.isAdmin = isAdmin;
    this.serial = serial;
  }

  void saveisNotification(String str) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString("isNotification", str);
  }

  void initFromCashe() async {
    SharedPreferences prefs = await _prefs;
    final animationName = prefs.getString("isNotification");
    setState(() {
      this.animationName = (animationName == null ? "day_idle" : animationName);
    });
  }

  Future<void> initJpush(bool b) async {
    JPush jpush = new JPush();
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      },
    );

    jpush.setup(
      appKey: "dbd432a6add6b7f420edeae3",
      channel: "flutter_channel",
      production: true,
      debug: true, //是否打印debug日志
    );

    if (b) {
      /// 设置tags
      jpush.setTags(["student"]).then((value) => print(value));
    } else {
      jpush.cleanTags();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFromCashe();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      //padding: EdgeInsets.only(top: 50, bottom: 70, left: 10),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: new FlareActor(
                  "assets/animation/123.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  animation: "Flow",
                )),
              ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 45,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      brandName()
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: ScreenUtil().setWidth(25),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      isAdmin ? Icons.perm_identity : Icons.school,
                      size: ScreenUtil().setSp(70),
                      color: Color(0xFF1b1e44),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(10),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ScreenUtil().setWidth(25),
                      ),
                      Text((isAdmin ? "管理员" : RestApi().getStudentName(serial)),
                          style: small),
                    ],
                  )
                ],
              ),
              Column(
                children: (isAdmin ? adminItems : studentItems)
                    .map<Widget>((element) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: element['index'] == 'editnotification'
                              ? new GestureDetector(
                                  onTap: () {
                                    if (animationName == 'day_idle') {
                                      setState(() {
                                        animationName = 'switch_night';
                                      });
                                    }
                                    if (animationName == 'night_idle') {
                                      setState(() {
                                        animationName = 'switch_day';
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        element['icon'],
                                        color: Color(0xFF1b1e44),
                                        size: ScreenUtil().setSp(60),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(72),
                                        width: ScreenUtil().setHeight(120),
                                        child: new FlareActor(
                                          "assets/animation/switch.flr",
                                          alignment: Alignment.center,
                                          fit: BoxFit.cover,
                                          animation: animationName,
                                          callback: (name) {
                                            if (name == 'switch_night') {
                                              setState(() {
                                                animationName = 'night_idle';
                                                saveisNotification(
                                                    animationName);
                                                initJpush(false);
                                              });
                                            } else if (name == 'switch_day') {
                                              setState(() {
                                                animationName = 'day_idle';
                                                saveisNotification(
                                                    animationName);
                                                initJpush(true);
                                              });
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : new GestureDetector(
                                  onTap: () {
                                    switch (element['index']) {
                                      case 'notification':
                                        {
                                          // statements;
                                          MyNavigator.goToPush(context);
                                        }
                                        break;
                                      case 'edit':
                                        if (isAdmin) {
                                          MyNavigator.goToAdminEdit(
                                              context, serial);
                                        } else {
                                          MyNavigator.gotoEditStudent(
                                              context, serial);
                                        }
                                        break;
                                      case 'overview':
                                        {
                                          MyNavigator.gotoOverview(
                                              context, 'admin');
                                        }
                                        break;
                                      case 'schedule':
                                        {
                                          MyNavigator.gotoOverview(
                                              context, serial);
                                        }
                                        break;
                                      case 'add':
                                        {
                                          MyNavigator.gotoAddStudent(context);
                                        }
                                        break;
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        element['icon'],
                                        color: Color(0xFF1b1e44),
                                        size: ScreenUtil().setSp(60),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(element['title'], style: small)
                                    ],
                                  ),
                                ),
                        ))
                    .toList(),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      title: new Text('退出'),
                      content: new Text('您想要退出登录吗?'),
                      actions: <Widget>[
                        new InkWell(
                          child: Container(
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setHeight(80),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF17ead9),
                                  Color(0xFF6078ea)
                                ]),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078ea).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0)
                                ]),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Center(
                                  child: Text(
                                    "取消",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        new InkWell(
                          child: Container(
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setHeight(80),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF17ead9),
                                  Color(0xFF6078ea)
                                ]),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078ea).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0)
                                ]),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  MyNavigator.goToHome(context);
                                },
                                child: Center(
                                  child: Text(
                                    "确定",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                child: SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '退出',
                        style: small,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              )
            ],
          )
        ],
      ),
    );
  }
}
