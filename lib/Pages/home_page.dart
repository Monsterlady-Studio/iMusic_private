import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentmanager/Uilts/api.dart';
import 'package:studentmanager/Widgets/brandName.dart';
import 'package:studentmanager/Widgets/customIcons.dart';
import 'package:studentmanager/Widgets/notification_widget.dart';
import 'package:studentmanager/Widgets/policy.dart';
import 'package:studentmanager/Widgets/wechatContact.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/SocialIcon.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSelected = false;
  String _keyword;
  bool _visible = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  LCObject superadmin;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('退出'),
            content: new Text('您想要退出应用吗?'),
            actions: <Widget>[
              new InkWell(
                child: Container(
                  width: ScreenUtil().setWidth(150),
                  height: ScreenUtil().setHeight(80),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
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
                      gradient: LinearGradient(
                          colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
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
                        SystemNavigator.pop();
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
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
    initJpush();
    LeanCloud.initialize(
        'mMxKina1uSmeMnvCUsD3ozOS-MdYXbMMI', 'KCrLXxMU7xSijKgymAuPhyhV');
    initFromCache();
    initSuperAdmin();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        setState(() {
          _connectionStatus = "手机网络";
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          _connectionStatus = "Wifi网络";
        });
      } else {
        setState(() {
          _connectionStatus = "无网络";
        });
      }
      Fluttertoast.showToast(
          msg: _connectionStatus,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Future<void> initPermissions() async {
    var notificationStatus = await Permission.notification.status;
    var smsStatus = await Permission.sms.status;
    var phoneStatus = await Permission.phone.status;
    var contacts = await Permission.contacts.status;
    if (!notificationStatus.isGranted) {
      await Permission.notification.request();
    }
    if (Platform.isAndroid) {
      if (!smsStatus.isGranted) {
        await Permission.sms.request();
      }
      if (!phoneStatus.isGranted) {
        await Permission.phone.request();
      }
      if (!contacts.isGranted) {
        await Permission.contacts.request();
      }
    }
  }

  Future<void> initSuperAdmin() async {
    setState(() async {
      LCQuery<LCObject> query = LCQuery('admin');
      superadmin = await query.get('5ec5ada7c1c17600084c1ff4');
    });
  }

  Future<void> initJpush() async {
    JPush jpush = new JPush();
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        //print(message['title'] + message['alert']);
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        showDialog(
          context: context,
          builder: (_) =>
              NotificationWidget(message['title'], message['alert']),
        );
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        //print("flutter onReceiveMessage: $message");
      },
    );
    jpush.setup(
      appKey: "dbd432a6add6b7f420edeae3",
      channel: "flutter_channel",
      production: true,
      debug: true, //是否打印debug日志
    );

    /// 设置tags
    jpush.setTags(["student"]).then((value) => print(value));
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    jpush.setBadge(0);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  //平台消息是异步的，所以我们用异步方法初始化。
  Future<Null> initConnectivity() async {
    String connectionStatus;
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // 如果在异步平台消息运行时从树中删除了该小部件，
    // 那么我们希望放弃回复，而不是调用setstate来更新我们不存在的外观。
    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
  }

//保存数据
  void saveMethodName(bool b) async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool("strKey", b);
  }

  void saveCode(String str) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString("code", str);
  }

//获取数据
  void initFromCache() async {
    SharedPreferences prefs = await _prefs;
    final isSelected = prefs.getBool("strKey");
    final _keyword = prefs.getString("code");
    setState(() {
      this.isSelected = (isSelected == null ? false : isSelected);
      this._keyword = (_keyword == null ? "" : _keyword);
    });
  }

  bool fadeout() {
    if (_visible) {
      return _visible;
    } else {
      Timer(Duration(seconds: 5), () {
        setState(() {
          _visible = true;
        });
      });
      return _visible;
    }
  }

  Widget radioButton(bool isSelected) => Container(
      width: 16.0,
      height: 16.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Colors.black)),
      child: isSelected
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            )
          : Container());

  Widget loginWidget(bool isShow) => isShow
      ? FadeIn(
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // 触摸收起键盘
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: FlutterEasyLoading(
                  child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment(-1.1, -1),
                                child: brandName()),
                            SizedBox(
                              height: ScreenUtil().setHeight(210),
                            ),
                            Container(
                              width: double.infinity,
                              height: ScreenUtil().setHeight(400),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.transparent,
                                        offset: Offset(0.0, 15.0),
                                        blurRadius: 15.0),
                                    BoxShadow(
                                        color: Colors.transparent,
                                        offset: Offset(0.0, -10.0),
                                        blurRadius: 10.0)
                                  ]),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("登录",
                                        style: TextStyle(
                                            color: Color(0xFF1b1e44),
                                            fontSize: ScreenUtil().setSp(45),
                                            fontFamily: "Poppins-Bold",
                                            letterSpacing: .6)),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(60),
                                    ),
                                    Text("课程代码",
                                        style: TextStyle(
                                          fontFamily: "Poppins-Medium",
                                          fontSize: ScreenUtil().setSp(26),
                                          color: Color(0xFF1b1e44),
                                        )),
                                    TextField(
                                      textAlign: TextAlign.center,
                                      obscureText: true,
                                      onSubmitted: (value) {
                                        //value is entered text after ENTER press
                                        //you can also call any function here or make setState() to assign value to other variable
                                        RestApi().login(value, context);
                                      },
                                      onChanged: (value) {
                                        this._keyword = value;
                                        if (isSelected) {
                                          saveCode(this._keyword);
                                        }
                                      },
                                      decoration: InputDecoration(
                                          hintText: "输入课程代码",
                                          hintStyle: TextStyle(
                                            fontSize: 12.0,
                                            color: Color(0xFF1b1e44),
                                            fontFamily: "Poppins-Bold",
                                          )),
                                      controller: TextEditingController
                                          .fromValue(TextEditingValue(
                                              text:
                                                  '${(this._keyword == null) ? "" : this._keyword}',
                                              selection:
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          affinity: TextAffinity
                                                              .downstream,
                                                          offset:
                                                              '${this._keyword}'
                                                                  .length)))),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(70),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                              text: "《用户协议 & 隐私政策》",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontFamily: "Poppins-Medium",
                                                  fontSize:
                                                      ScreenUtil().setSp(28)),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => policy(),
                                                  );
                                                }),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(40)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Checkbox(
                                        value: isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            this.isSelected = value;
                                            if (!this.isSelected) {
                                              saveCode("");
                                            } else {
                                              saveCode(this._keyword);
                                            }
                                            saveMethodName(this.isSelected);
                                          });
                                        }),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text("记住代码",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF1b1e44),
                                            fontFamily: "Poppins-Medium"))
                                  ],
                                ),
                                InkWell(
                                  child: Container(
                                    width: ScreenUtil().setWidth(330),
                                    height: ScreenUtil().setHeight(100),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Color(0xFF17ead9),
                                          Color(0xFF6078ea)
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xFF6078ea)
                                                  .withOpacity(.3),
                                              offset: Offset(0.0, 8.0),
                                              blurRadius: 8.0)
                                        ]),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => RestApi()
                                            .login(this._keyword, context),
                                        child: Center(
                                          child: Text(
                                            "登录",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Poppins-Bold",
                                                fontSize: 18,
                                                letterSpacing: 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(40),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                horizontalLine(),
                                Text(
                                  "联系方式",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "Poppins-Medium",
                                    color: Color(0xFF1b1e44),
                                  ),
                                ),
                                horizontalLine()
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(60)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SocialIcon(
                                  colors: [
                                    Color(0xFF808080),
                                    Color(0xFF808080),
                                  ],
                                  iconData: customIcons.email,
                                  onPressed: () async {
                                    var url = 'mailto:' +
                                        superadmin['email'] +
                                        '?subject=主题&body=王老师您好,';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw '不支持发送邮件';
                                    }
                                  },
                                ),
                                SocialIcon(
                                  colors: [
                                    Color(0xFFFF8A65),
                                    Color(0xFFF4511E),
                                  ],
                                  iconData: customIcons.msg,
                                  onPressed: () async {
                                    var url = 'sms:' + superadmin['phone'];
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw '不支持发送短信';
                                    }
                                  },
                                ),
                                SocialIcon(
                                  colors: [
                                    Color(0xFF51C332),
                                    Color(0xFF51C333)
                                  ],
                                  iconData: customIcons.wechat,
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (_) => wechatContact());
                                  },
                                ),
                                SocialIcon(
                                  colors: [
                                    Color(0xFFFF6E40),
                                    Color(0xFFE64A19),
                                  ],
                                  iconData: customIcons.call,
                                  onPressed: () async {
                                    var url = 'tel:' + superadmin['phone'];
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw '不支持拨打电话';
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(60)),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("©生活即艺术 - 爱乐教室",
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: Color(0xFF1b1e44),
                                          fontFamily: "Poppins-Medium")),
                                ],
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: ScreenUtil().setHeight(450),
                    )
                  ],
                ),
              ))),
          duration: Duration(milliseconds: 2000),
          curve: Curves.easeIn,
        )
      : Container();

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return new WillPopScope(
        child: new Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            body: Stack(fit: StackFit.expand, children: <Widget>[
              new GestureDetector(
                child: Column(children: <Widget>[
                  Expanded(
                      child: new FlareActor(
                    "assets/animation/123.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                    animation: "Flow",
                  )),
                ]),
                onTap: () {
                  setState(() {
                    _visible = !_visible;
                  });
                },
              ),
              FadeIn(
                duration: Duration(milliseconds: 3000),
                curve: Curves.easeIn,
                child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil().setHeight(600),
                      ),
                      Container(
                        child: Offstage(
                          offstage: _visible,
                          child: Transform.scale(
                            scale: 2,
                            child: brandName(),
                          ),
                        ),
                      ),
                    ]),
              ),
              loginWidget(fadeout())
            ])),
        onWillPop: _onWillPop);
  }
}
