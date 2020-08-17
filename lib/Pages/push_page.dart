import 'dart:async';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studentmanager/Uilts/api.dart';

import '../Uilts/fontsStyle.dart';

class PushScreen extends StatefulWidget {
  @override
  _PushScreenState createState() => new _PushScreenState();
}

class _PushScreenState extends State<PushScreen>
    with SingleTickerProviderStateMixin {
  String title = "这是标题";
  String content = '这是内容';
  String animationName = 'default';
  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 300.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: FlutterEasyLoading(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 45.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text("通知预览",
                      style: TextStyle(
                          color: Color(0xFF1b1e44),
                          fontSize: 46.0,
                          fontFamily: "Poppins-Bold",
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold)),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/preview1.png'),
                      Stack(
                        children: <Widget>[
                          Image.asset("assets/images/preview2.png"),
                          Center(
                            child: Container(
                              width: ScreenUtil().setWidth(500),
                              height: ScreenUtil().setHeight(160),
                              decoration: BoxDecoration(
                                  color: Color(0xFFf3f5f5),
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
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
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: ScreenUtil().setHeight(10),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: ScreenUtil().setWidth(20),
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(40),
                                        width: ScreenUtil().setWidth(40),
                                        child: Image.asset(
                                            'assets/images/logo4.png'),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(15),
                                      ),
                                      Text(
                                        "iMusic",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(0xFF1b1e44),
                                            fontSize: ScreenUtil().setSp(32),
                                            letterSpacing: .6,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: ScreenUtil().setWidth(20),
                                        ),
                                        Text(
                                            title.length > 12
                                                ? title.substring(0, 12) + "..."
                                                : title,
                                            style: TextStyle(
                                                color: Color(0xFF1b1e44),
                                                fontSize:
                                                    ScreenUtil().setSp(32),
                                                letterSpacing: .6,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: ScreenUtil().setWidth(20),
                                        ),
                                        Text(
                                            content.length > 12
                                                ? content.substring(0, 12) +
                                                    "..."
                                                : content,
                                            style: TextStyle(
                                                color: Color(0xFF1b1e44),
                                                fontSize:
                                                    ScreenUtil().setSp(32),
                                                letterSpacing: .6,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Text("编辑标题",
                            style: TextStyle(
                              color: Color(0xFF1b1e44),
                              fontSize: 46.0,
                              fontFamily: "Poppins-Bold",
                              letterSpacing: 1.0,
                            )),
                      ),
//                    Container(
//                      width: double.maxFinite,
//                      height: ScreenUtil().setHeight(150),
//                      child: BeautyTextfield(
//                        width: double.maxFinite,
//                        height: double.maxFinite,
//                        autofocus: false,
//                        duration: Duration(milliseconds: 300),
//                        inputType: TextInputType.text,
//                        prefixIcon: Icon(Icons.title),
//                        suffixIcon: Icon(Icons.remove_red_eye),
//                        placeholder: "在这输入标题",
//                        onTap: () {
//                          print('Click');
//                        },
//                        onChanged: (text) {
//                          setState(() {
//                            title = text;
//                          });
//                        },
//                        onSubmitted: (data) {
//                          print(data.length);
//                        },
//                      ),
//                    ),
                      Container(
                        margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(15),
                            left: ScreenUtil().setWidth(15)),
                        width: double.maxFinite,
                        height: ScreenUtil().setHeight(150),
                        child: TextFormField(
                          decoration: new InputDecoration(
                            labelText: "在这输入标题",
                            labelStyle: medium,
                            fillColor: Colors.white10,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          onChanged: (text) {
                            setState(() {
                              title = text;
                            });
                          },
                          keyboardType: TextInputType.text,
                          style: medium,
                        ),
//                        child: TextField(
//                          keyboardType: TextInputType.text,
//                          onChanged: (text) {
//                            setState(() {
//                              title = text;
//                            });
//                          },
//                          decoration: InputDecoration(
//                            hintText: "在这输入标题",
//                            hintStyle: small,
//                          ),
//                          controller: TextEditingController.fromValue(
//                              TextEditingValue(
//                                  text: title == null ? "" : title,
//                                  selection: TextSelection.fromPosition(
//                                      TextPosition(
//                                          affinity: TextAffinity.downstream,
//                                          offset: this.title.length)))),
//                        ),

//                        child: BeautyTextfield(
//                          focusNode: _focusNode,
//                          //accentColor: Colors.black,
//                          width: double.maxFinite,
//                          height: double.maxFinite,
//                          autofocus: false,
//                          duration: Duration(milliseconds: 300),
//                          inputType: TextInputType.text,
//                          prefixIcon: Icon(Icons.title),
//                          suffixIcon: Icon(Icons.remove_red_eye),
//                          placeholder: "在这输入标题",
//                          onChanged: (text) {
//                            setState(() {
//                              title = text;
//                            });
//                          },
//                          onSubmitted: (data) {
//                            print(data.length);
//                          },
//                        ),
                      ),
                      Center(
                        child: Text("编辑内容",
                            style: TextStyle(
                              color: Color(0xFF1b1e44),
                              fontSize: 46.0,
                              fontFamily: "Poppins-Bold",
                              letterSpacing: 1.0,
                            )),
                      ),
//                    Container(
//                      width: double.maxFinite,
//                      height: ScreenUtil().setHeight(600),
//                      child: BeautyTextfield(
//                        width: double.maxFinite,
//                        height: double.maxFinite,
//                        autofocus: false,
//                        duration: Duration(milliseconds: 300),
//                        inputType: TextInputType.text,
//                        prefixIcon: Icon(Icons.textsms),
//                        suffixIcon: Icon(Icons.remove_red_eye),
//                        placeholder: "在这编辑内容",
//                        onTap: () {
//                          print('Click');
//                        },
//                        onChanged: (text) {
//                          setState(() {
//                            content = text;
//                          });
//                        },
//                        onSubmitted: (data) {
//                          print(data.length);
//                        },
//                      ),
//                    ),
                      Container(
                        margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(15),
                            left: ScreenUtil().setWidth(15)),
                        width: double.maxFinite,
                        //height: ScreenUtil().setHeight(600),
                        child: TextFormField(
                          focusNode: _focusNode,
                          maxLines: null,
                          decoration: new InputDecoration(
                            labelText: "在这编辑内容",
                            labelStyle: medium,
                            fillColor: Colors.white10,
                            contentPadding: new EdgeInsets.only(
                                top: ScreenUtil().setHeight(150),
                                bottom: ScreenUtil().setHeight(150)),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          onChanged: (text) {
                            setState(() {
                              content = text;
                            });
                          },
                          keyboardType: TextInputType.text,
                          style: medium,
                        ),
//                        child: BeautyTextfield(
//                          focusNode: _focusNode,
//                          width: double.maxFinite,
//                          height: double.maxFinite,
//                          autofocus: false,
//                          accentColor: Colors.blue,
//                          duration: Duration(milliseconds: 300),
//                          inputType: TextInputType.text,
//                          prefixIcon: Icon(Icons.textsms),
//                          suffixIcon: Icon(Icons.remove_red_eye),
//                          placeholder: "在这编辑内容",
//                          onTap: () {},
//                          onChanged: (text) {
//                            setState(() {
//                              content = text;
//                            });
//                          },
//                          onSubmitted: (data) {
//                            print(data.length);
//                          },
//                        ),
                      ),
                      new Divider(),
                      Center(
                        child: SizedBox(
                          width: ScreenUtil().setWidth(250),
                          height: ScreenUtil().setHeight(120),
                          child: GestureDetector(
                            onTap: () async {
                              if (title == "这是标题" || title.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: '标题不可以为空!',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (content == "这是内容" || content.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: '内容不可以为空!',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => Material(
                                    child: FlutterEasyLoading(
                                        child: new AlertDialog(
                                      title: new Text('发布 ' + title),
                                      content: new Text('您想要发布吗?'),
                                      actions: <Widget>[
                                        new InkWell(
                                          child: Container(
                                            width: ScreenUtil().setWidth(150),
                                            height: ScreenUtil().setHeight(80),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
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
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    '取消',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "Poppins-Bold",
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
                                                    colors: [
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
                                                onTap: () async {
                                                  var sample = {
                                                    "platform": [
                                                      "android",
                                                      "ios"
                                                    ],
                                                    "audience": {
                                                      "tag": ["student", "test"]
                                                    },
                                                    "notification": {
                                                      "android": {
                                                        "alert": content,
                                                        "title": title
                                                      },
                                                      "ios": {
                                                        "alert": {
                                                          "title": title,
                                                          "body": content
                                                        }
                                                      }
                                                    },
                                                    "options": {
                                                      "apns_production": true
                                                    }
                                                  };
                                                  RestApi()
                                                      .pushNotification(
                                                          sample, context)
                                                      .whenComplete(() => Timer(
                                                              new Duration(
                                                                  milliseconds:
                                                                      2000),
                                                              () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          }));
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "确定",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "Poppins-Bold",
                                                        fontSize: 15,
                                                        letterSpacing: 1.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                  ),
                                );
                              }
                            },
                            child: new FlareActor('assets/animation/yes.flr',
                                animation: animationName,
                                fit: BoxFit.cover, callback: (str) {
                              print(str);
                              if (str == 'success') {
                                setState(() {
                                  animationName = 'default';
                                });
                              }
                            }),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(15),
                      ),
                      SizedBox(
                          height: Platform.isAndroid ? _animation.value : 0)
                    ],
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
