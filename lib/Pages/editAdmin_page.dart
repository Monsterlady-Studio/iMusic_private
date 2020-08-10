import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:studentmanager/Uilts/api.dart';

import '../Uilts/fontsStyle.dart';

class EditAdminPage extends StatefulWidget {
  @override
  _EditAdminPageState createState() => new _EditAdminPageState();
}

class _EditAdminPageState extends State<EditAdminPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNode = FocusNode();
  String currentPsw;
  String newPsw;
  String confirmPsw;
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
    final String serializedString = ModalRoute.of(context).settings.arguments;
    LCObject admin = RestApi().getObject(serializedString);
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
                    IconButton(
                      icon: Icon(
                        Icons.file_upload,
                      ),
                      onPressed: () {
                        if (currentPsw == null || currentPsw.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "现有密码不可以为空！",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (currentPsw != admin['password']) {
                          Fluttertoast.showToast(
                              msg: "现有密码不正确！",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (newPsw == null || newPsw.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "新密码不可以为空！",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (confirmPsw == null || confirmPsw.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "重复密码不可以为空！",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (confirmPsw != newPsw) {
                          Fluttertoast.showToast(
                              msg: "新密码与重复密码不匹配！",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (currentPsw == admin['password'] &&
                            newPsw == confirmPsw) {
                          admin['password'] = newPsw;
                          RestApi().saveEditedStudent(admin, context, false);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(40),
                    bottom: ScreenUtil().setHeight(50),
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(40)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  //border: Border.all(width: 2.0, color: Colors.black),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),

                    ///现有密码
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                width: double.maxFinite,
                                height: 2,
                                color: Colors.black26.withOpacity(.2),
                              ),
                            )),
                        Expanded(
                          flex: 4,
                          child: Text(
                            '现有密码',
                            style: large,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              width: double.maxFinite,
                              height: 2,
                              color: Colors.black26.withOpacity(.2),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(15),
                          left: ScreenUtil().setWidth(15)),
                      width: double.maxFinite,
                      height: ScreenUtil().setHeight(150),
                      child: TextFormField(
                        obscureText: true,
                        decoration: new InputDecoration(
                          labelText: "在这输入现有密码",
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
                            currentPsw = text;
                          });
                        },
                        keyboardType: TextInputType.text,
                        style: medium,
                      ),
                    ),

                    ///新密码
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                width: double.maxFinite,
                                height: 2,
                                color: Colors.black26.withOpacity(.2),
                              ),
                            )),
                        Expanded(
                          flex: 4,
                          child: Text(
                            '新密码',
                            style: large,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              width: double.maxFinite,
                              height: 2,
                              color: Colors.black26.withOpacity(.2),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(15),
                          left: ScreenUtil().setWidth(15)),
                      width: double.maxFinite,
                      height: ScreenUtil().setHeight(150),
                      child: TextFormField(
                        obscureText: true,
                        decoration: new InputDecoration(
                          labelText: "在这输入新密码",
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
                            newPsw = text;
                          });
                        },
                        keyboardType: TextInputType.text,
                        style: medium,
                      ),
                    ),

                    ///重复密码
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                width: double.maxFinite,
                                height: 2,
                                color: Colors.black26.withOpacity(.2),
                              ),
                            )),
                        Expanded(
                          flex: 4,
                          child: Text(
                            '重复密码',
                            style: large,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              width: double.maxFinite,
                              height: 2,
                              color: Colors.black26.withOpacity(.2),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(15),
                          left: ScreenUtil().setWidth(15)),
                      width: double.maxFinite,
                      height: ScreenUtil().setHeight(150),
                      child: TextFormField(
                        obscureText: true,
                        focusNode: _focusNode,
                        decoration: new InputDecoration(
                          labelText: "在这输入重复密码",
                          labelStyle: medium,
                          fillColor: Colors.white10,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        onChanged: (text) {
                          confirmPsw = text;
                        },
                        keyboardType: TextInputType.text,
                        style: medium,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Platform.isAndroid ? _animation.value : 0),
            ],
          ))),
        ),
      ),
    );
  }
}
