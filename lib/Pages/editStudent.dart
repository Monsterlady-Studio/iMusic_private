import 'dart:io';

import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:studentmanager/Uilts/api.dart';
import 'package:studentmanager/Uilts/data.dart';
import 'package:studentmanager/Uilts/fontsStyle.dart';

class EditStudent extends StatefulWidget {
  _EditStudent createState() => new _EditStudent();
}

class _EditStudent extends State<EditStudent>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNode = FocusNode();
  LCObject _lcObject;
  String name, phoneNum, schoolName;
  bool gender;
  bool isClicked = false;
  DateTime birthday;
  bool isPhoneCorrect = false;
  List<String> schoolNamelist;
  TextEditingController myController;

  @override
  void initState() {
    super.initState();
    getPostsList();
    initEditingData();
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: ScreenUtil().setHeight(400.0))
        .animate(_controller)
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

  void getPostsList() async {
    schoolNamelist =
        await getPrimarySchoolName() + await getMiddileSchoolName();
  }

  void initEditingData() {
    Future.delayed(Duration.zero, () {
      setState(() {
        final String serializedString =
            ModalRoute.of(context).settings.arguments;
        if (serializedString != null) {
          setState(() {
            _lcObject = RestApi().getObject(serializedString);
            //必填项
            name = _lcObject['name'];
            gender = _lcObject['gender'];

            //非必填项
            if (_lcObject['birthday'] != "未填写") {
              birthday = new DateTime(
                  int.parse(_lcObject['birthday'].toString().split('-')[0]),
                  int.parse(_lcObject['birthday'].toString().split('-')[1]),
                  int.parse(_lcObject['birthday'].toString().split('-')[2]));
              //print(birthday);
            }
            phoneNum = _lcObject['phone'];
            print(phoneNum);
            RegExp exp = RegExp(
                r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$");
            isPhoneCorrect = exp.hasMatch(phoneNum);

            if (schoolName != '未填写') {
              schoolName = _lcObject['school'];
            }
          });
          myController = TextEditingController.fromValue(
              TextEditingValue(text: (phoneNum == '未填写' ? "" : phoneNum)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FlutterEasyLoading(
          child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              setState(() {});
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent),
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
                              if (name == null || name.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "名字不可以为空！",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (gender == null) {
                                Fluttertoast.showToast(
                                    msg: "性别还未填写哦！",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (!isPhoneCorrect &&
                                  phoneNum != null &&
                                  phoneNum.length != 0 &&
                                  phoneNum != '未填写') {
                                Fluttertoast.showToast(
                                    msg: "电话号码格式不对！",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                LCObject object;
                                //必填项
                                _lcObject['name'] = name;
                                _lcObject['gender'] = gender;
                                //非必填项
                                if (birthday != null) {
                                  _lcObject['birthday'] =
                                      birthday.year.toString() +
                                          '-' +
                                          birthday.month.toString() +
                                          '-' +
                                          birthday.day.toString();
                                }
                                if (phoneNum != null && isPhoneCorrect) {
                                  _lcObject['phone'] = phoneNum;
                                }
                                if (schoolName != null) {
                                  _lcObject['school'] = schoolName;
                                }
                                RestApi().uploadProfile(_lcObject, context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          //top: ScreenUtil().setHeight(40),
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

                          ///个人信息
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Container(
                                      width: double.maxFinite,
                                      height: 2,
                                      color: Colors.black26.withOpacity(.2),
                                    ),
                                  )),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  '个人信息',
                                  style: large,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
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

                          ///name input field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 22.0, vertical: 6.0),
                                    child: Text("重要",
                                        style: TextStyle(
                                            color: Colors.transparent,
                                            fontFamily: "Poppins-Bold")),
                                  ),
                                ),
                              ),
                              Text("姓名/Name", style: medium),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFff6e6e),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 22.0, vertical: 6.0),
                                    child: Text("重要",
                                        style: TextStyle(
                                            color: Color(0xFF1b1e44),
                                            fontFamily: "Poppins-Bold")),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          BeautyTextfield(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setHeight(40),
                                right: ScreenUtil().setHeight(40)),
                            cornerRadius: BorderRadius.circular(20),
                            width: double.maxFinite,
                            height: ScreenUtil().setHeight(100),
                            inputType: TextInputType.text,
                            prefixIcon: Icon(Icons.perm_identity),
                            autofocus: false,
                            duration: Duration(milliseconds: 300),
                            suffixIcon: isClicked
                                ? Icon(Icons.thumb_down)
                                : Icon(Icons.thumb_up),
                            placeholder: name,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            accentColor: isClicked ? Colors.red : Colors.green,
                            onTap: () {
                              setState(() {
                                if (!isClicked) {
                                  isClicked = !isClicked;
                                }
                              });
                            },
                            onChanged: (text) {
                              setState(() {
                                name = text;
                              });
                            },
                            onSubmitted: (data) {
                              if (data.length >= 2 && data.length < 6) {
                                setState(() {
                                  name = data;
                                  isClicked = !isClicked;
                                });
                              } else {
                                if (data == null || data.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "名字不可以为空！",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else if (data.length > 6) {
                                  Fluttertoast.showToast(
                                      msg: "名字过长哦！",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else if (data.length < 2) {
                                  Fluttertoast.showToast(
                                      msg: "名字过短哦！",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),

                          ///birthday input field
                          Center(
                            child: Text(
                              "生日/Birthday",
                              style: medium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          FlatButton(
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(1970, 1, 1),
                                    maxTime: DateTime.now(), onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  print('confirm $date');
                                  setState(() {
                                    birthday = date;
                                  });
                                },
                                    currentTime: birthday == null
                                        ? DateTime.now()
                                        : birthday,
                                    locale: LocaleType.zh);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  //year
                                  Expanded(
                                      child: Text(
                                          birthday == null
                                              ? '????'
                                              : birthday.year.toString(),
                                          style: medium)),
                                  Expanded(child: Text('年', style: medium)),
                                  //month
                                  Expanded(
                                      child: Text(
                                          birthday == null
                                              ? '?'
                                              : birthday.month.toString(),
                                          style: medium)),
                                  Expanded(child: Text('月', style: medium)),
                                  //day
                                  Expanded(
                                      child: Text(
                                          birthday == null
                                              ? '?'
                                              : birthday.day.toString(),
                                          style: medium)),
                                  Expanded(child: Text('日', style: medium)),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),

                          ///gender choose field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 22.0, vertical: 6.0),
                                    child: Text("必填",
                                        style: TextStyle(
                                            color: Colors.transparent,
                                            fontFamily: "Poppins-Bold")),
                                  ),
                                ),
                              ),
                              Text("性别/Gender",
                                  style: medium, textAlign: TextAlign.center),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFff6e6e),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 22.0, vertical: 6.0),
                                    child: Text("必填",
                                        style: TextStyle(
                                            color: Color(0xFF1b1e44),
                                            fontFamily: "Poppins-Bold")),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          FlatButton(
                              onPressed: () {
                                Picker picker = new Picker(
                                    adapter: PickerDataAdapter<String>(
                                        pickerdata: PickerData2),
                                    changeToFirst: false,
                                    textAlign: TextAlign.center,
                                    columnPadding: const EdgeInsets.all(8.0),
                                    onConfirm: (Picker picker, List value) {
                                      print(value.toString());
                                      print(picker.getSelectedValues());
                                      setState(() {
                                        if (picker
                                                .getSelectedValues()
                                                .toString() ==
                                            '[男]') {
                                          gender = true;
                                        } else {
                                          gender = false;
                                        }
                                      });
                                    });
                                picker.show(_scaffoldKey.currentState);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                  Expanded(
                                      child: gender == null
                                          ? SvgPicture.asset(
                                              "assets/images/valentine_-love-gender-symbol-sex.svg",
                                              height:
                                                  ScreenUtil().setHeight(64),
                                              width: ScreenUtil().setHeight(64),
                                              allowDrawingOutsideViewBox: false,
                                            )
                                          : (gender
                                              ? SvgPicture.asset(
                                                  "assets/images/male.svg",
                                                  height: ScreenUtil()
                                                      .setHeight(64),
                                                  width: ScreenUtil()
                                                      .setHeight(64),
                                                  allowDrawingOutsideViewBox:
                                                      false,
                                                )
                                              : SvgPicture.asset(
                                                  "assets/images/female.svg",
                                                  height: ScreenUtil()
                                                      .setHeight(64),
                                                  width: ScreenUtil()
                                                      .setHeight(64),
                                                  allowDrawingOutsideViewBox:
                                                      false,
                                                ))),
                                  Expanded(
                                      child: Text(
                                          gender == null
                                              ? '未选择'
                                              : (gender ? '男' : '女'),
                                          style: medium)),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: ScreenUtil().setHeight(40),
                          ),

                          ///联系方式
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Container(
                                      width: double.maxFinite,
                                      height: 2,
                                      color: Colors.black26.withOpacity(.2),
                                    ),
                                  )),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  '联系方式',
                                  style: large,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
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

                          ///电话号码
                          Center(
                            child: Text("电话号码/Phone", style: medium),
                          ),
                          Container(
                            margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
                            child: PinInputTextField(
                              focusNode: _focusNode,
                              pinLength: 11,
                              controller: myController,
                              textInputAction: TextInputAction.go,
                              enabled: true,
                              autoFocus: false,
                              decoration: BoxTightDecoration(
                                strokeColor: isPhoneCorrect
                                    ? Colors.green
                                    : Colors.redAccent,
                                strokeWidth: 3,
                                radius: Radius.circular(5),
                              ),
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.characters,
                              onSubmit: (pin) {
                                RegExp exp = RegExp(
                                    r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$");
                                setState(() {
                                  isPhoneCorrect = exp.hasMatch(pin);
                                  phoneNum = pin;
                                });
                                print(phoneNum);
                              },
                              onChanged: (pin) {
                                RegExp exp = RegExp(
                                    r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$");
                                setState(() {
                                  isPhoneCorrect = exp.hasMatch(pin);
                                  phoneNum = pin;
                                });
                                print(phoneNum);
                              },
                              enableInteractiveSelection: true,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),

                          ///选择学校
                          Center(
                            child: Text("学校/School", style: medium),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                  child: FlatButton(
                                onPressed: () {
                                  Picker picker = new Picker(
                                      adapter: PickerDataAdapter<String>(
                                          pickerdata: schoolNamelist),
                                      changeToFirst: false,
                                      textAlign: TextAlign.center,
                                      columnPadding: const EdgeInsets.all(8.0),
                                      onConfirm: (Picker picker, List value) {
                                        setState(() {
                                          setState(() {
                                            schoolName =
                                                picker.getSelectedValues()[0];
                                          });
                                        });
                                      });
                                  picker.show(_scaffoldKey.currentState);
                                },
                                child: Center(
                                    child: Text(
                                  "名称:" +
                                      ((schoolName == null)
                                          ? '未选择'
                                          : schoolName),
                                  style: medium,
                                )),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),

                          ///底部
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          SizedBox(
                              height:
                                  Platform.isAndroid ? _animation.value : 0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      )),
    );
  }
}
