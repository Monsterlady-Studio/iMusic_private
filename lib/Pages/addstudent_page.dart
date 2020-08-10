import 'dart:convert';
import 'dart:io';

import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:studentmanager/Model/event.dart';
import 'package:studentmanager/Uilts/api.dart';
import 'package:studentmanager/Uilts/data.dart';
import 'package:studentmanager/Uilts/fontsStyle.dart';
import 'package:studentmanager/Widgets/gender_picker.dart';
import 'package:uuid/uuid.dart';

class AddNewStudent extends StatefulWidget {
  @override
  _AddNewStudentState createState() => new _AddNewStudentState();
}

class _AddNewStudentState extends State<AddNewStudent>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNode = FocusNode();
  String name;
  DateTime birthday;
  bool gender;
  int times;
  int totalclassNum;
  int level;
  String phoneNum;
  String st;
  String schoolName;
  List<Event> classtime;
  List<String> schoolNamelist;
  bool isClicked = false;
  bool isPhoneCorrect = false;
  bool isPrimarySchool;
  bool isSchoolClicked = false;
  bool isEditMode = false;
  TextEditingController myController;
  LCObject _lcObject;

  @override
  void initState() {
    super.initState();
    initEditingData();
    getPostsList();
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

  void initEditingData() {
    Future.delayed(Duration.zero, () {
      setState(() {
        final String serializedString =
            ModalRoute.of(context).settings.arguments;
        if (serializedString != null) {
          setState(() {
            isEditMode = true;
            _lcObject = RestApi().getObject(serializedString);
            //必填项
            name = _lcObject['name'];
            gender = _lcObject['gender'];
            totalclassNum = _lcObject['totalclass'];

            //非必填项
            if (_lcObject['birthday'] != "未填写") {
              birthday = new DateTime(
                  int.parse(_lcObject['birthday'].toString().split('-')[0]),
                  int.parse(_lcObject['birthday'].toString().split('-')[1]),
                  int.parse(_lcObject['birthday'].toString().split('-')[2]));
              //print(birthday);
            }
            level = _lcObject['level'];
            //TODO
            if (_lcObject['events'] != null && _lcObject['events'].length > 2) {
              classtime = new List<Event>();
              for (var each in json.decode(_lcObject['events'])) {
                classtime.add(new Event(
                    Event.fromJson(each).weekday, Event.fromJson(each).start));
              }
              times = classtime.length;
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
          myController = TextEditingController.fromValue(TextEditingValue(
              text: isEditMode
                  ? (phoneNum == '未填写' ? "" : phoneNum)
                  : (phoneNum == null ? "" : phoneNum)));
        }
      });
    });
  }

  void getPostsList() async {
    schoolNamelist =
        await getPrimarySchoolName() + await getMiddileSchoolName();
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
              setState(() {
                isSchoolClicked = false;
              });
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
                              } else if (totalclassNum == null) {
                                Fluttertoast.showToast(
                                    msg: "课时次数还未填写哦！",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (classtime != null &&
                                  classtime.contains(null)) {
                                Fluttertoast.showToast(
                                    msg: "上课时间还没安排哦!",
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
                                if (!isEditMode) {
                                  object = new LCObject('student');
                                  var uuid = Uuid();
                                  object['code'] =
                                      uuid.v1().substring(25, 31).toLowerCase();
                                } else {
                                  object = _lcObject;
                                }

                                //必填项
                                object['name'] = name;
                                object['gender'] = gender;
                                object['totalclass'] = totalclassNum;

                                //非必填项
                                if (birthday != null) {
                                  object['birthday'] =
                                      birthday.year.toString() +
                                          '-' +
                                          birthday.month.toString() +
                                          '-' +
                                          birthday.day.toString();
                                }
                                if (level != null) {
                                  object['level'] = level;
                                }
                                if (classtime != null) {
                                  object['events'] = json.encode(classtime);
                                }
                                if (phoneNum != null && isPhoneCorrect) {
                                  object['phone'] = phoneNum;
                                }
                                if (schoolName != null) {
                                  object['school'] = schoolName;
                                }
                                RestApi()
                                    .saveEditedStudent(object, context, true);
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
                                    child: Text("必填",
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
                            placeholder: isEditMode ? name : "输入姓名",
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

                          ///课程信息
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
                                  '课程信息',
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

                          ///课时总数
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
                              Text("课时次数/Counts",
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
                                    adapter: PickerDataAdapter<int>(
                                        pickerdata: getClassNum()),
                                    changeToFirst: false,
                                    textAlign: TextAlign.center,
                                    columnPadding: const EdgeInsets.all(8.0),
                                    onConfirm: (Picker picker, List value) {
                                      print(value.toString());
                                      print(picker.getSelectedValues());
                                      setState(() {
                                        totalclassNum = value[0] + 1;
                                      });
                                    });
                                picker.show(_scaffoldKey.currentState);
                              },
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: SvgPicture.asset(
                                    'assets/images/book.svg',
                                    height: ScreenUtil().setHeight(60),
                                    width: ScreenUtil().setHeight(60),
                                    allowDrawingOutsideViewBox: true,
                                  )),
                                  Expanded(
                                      child: Text(
                                          '总共' +
                                              (totalclassNum == null
                                                  ? '0'
                                                  : totalclassNum.toString()) +
                                              "节",
                                          style: medium))
                                ],
                              )),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),

                          ///排课
                          Center(
                            child: Text("上课时间/Schedule",
                                style: medium, textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          FlatButton(
                            onPressed: () {
                              Picker picker = new Picker(
                                  adapter: PickerDataAdapter<int>(
                                      pickerdata: classTimes),
                                  changeToFirst: false,
                                  textAlign: TextAlign.center,
                                  columnPadding: const EdgeInsets.all(8.0),
                                  onConfirm: (Picker picker, List value) {
                                    print(picker.getSelectedValues()[0]);
                                    setState(() {
                                      times = picker.getSelectedValues()[0];
                                      classtime = new List<Event>(times);
                                    });
                                  });
                              picker.show(_scaffoldKey.currentState);
                            },
                            child: Center(
                                child: Text(
                              '每周上课次数: ' +
                                  ((times == null || times == 0)
                                      ? '未选择'
                                      : times.toString()),
                              style: medium,
                            )),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          (times == null || times == 0)
                              ? Container()
                              : Container(
                                  height: ScreenUtil().setHeight(380),
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(40),
                                      right: ScreenUtil().setWidth(40)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.yellow),
                                  child: ListView.builder(
                                      itemCount: times,
                                      itemBuilder: (ctx, index) {
                                        return classDetails(index);
                                      })),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),

                          ///考级
                          Center(
                            child: Text("等级/Level", style: medium),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          FlatButton(
                            onPressed: () {
                              Picker picker = new Picker(
                                  adapter: PickerDataAdapter<int>(
                                      pickerdata: levels),
                                  changeToFirst: false,
                                  textAlign: TextAlign.center,
                                  columnPadding: const EdgeInsets.all(8.0),
                                  onConfirm: (Picker picker, List value) {
                                    print(picker.getSelectedValues()[0]);
                                    setState(() {
                                      level = picker.getSelectedValues()[0];
                                    });
                                  });
                              picker.show(_scaffoldKey.currentState);
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: SvgPicture.asset(
                                      'assets/images/trophy.svg',
                                      height: ScreenUtil().setHeight(60),
                                      width: ScreenUtil().setHeight(60),
                                      allowDrawingOutsideViewBox: true,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                        (level == null
                                            ? '未选择'
                                            : "第 " + level.toString() + " 级"),
                                        style: medium))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
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
                              pinLength: 11,
                              controller: myController,
                              textInputAction: TextInputAction.go,
                              enabled: true,
                              autoFocus: false,
                              focusNode: _focusNode,
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
                          SizedBox(
                            height: isSchoolClicked ? 200 : 0,
                          )
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

  Widget classDetails(int index) {
    Event nwevent;
    if (index == null) {
      return Container();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          Text('第' + (index + 1).toString() + '次', style: medium),
          FlatButton(
              onPressed: () {
                DatePicker.showPicker(context,
                    pickerModel: GenderPicker(),
                    showTitleActions: true, onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  print('$date');
                  List<String> str1 = date.toString().split(' ');
                  List<String> time = str1[1].toString().split(':');
                  List<String> details = time[2].toString().split('.');
                  int mins = int.parse(details[0]) * 15;
                  nwevent = new Event(
                      int.parse(time[0]),
                      time[1] +
                          ':' +
                          (mins.toString().length < 2
                              ? '00'
                              : mins.toString()));
                  print(nwevent.toJson().toString());
                  setState(() {
                    classtime[index] = nwevent;
                  });
                }, locale: LocaleType.zh);
              },
              child: Text(
                (classtime[index] == null || classtime.isEmpty)
                    ? "未选择"
                    : classtime[index].toString(),
                style: medium,
              )),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
        ],
      );
    }
  }
}
