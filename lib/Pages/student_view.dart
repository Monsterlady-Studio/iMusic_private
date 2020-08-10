import 'dart:convert';

import 'package:fade/fade.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studentmanager/Model/record.dart';
import 'package:studentmanager/Navigators/Navi.dart';
import 'package:studentmanager/Pages/menu_page.dart';
import 'package:studentmanager/Uilts/api.dart';
import 'package:studentmanager/Uilts/data.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => new _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  bool isActive = true;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    final String serializedString = ModalRoute.of(context).settings.arguments;
    var object = RestApi().getObject(serializedString);
    List<Record> recordlist = new List<Record>();
    if (object['history'] != null && object['history'].toString().isNotEmpty) {
      for (var each in json.decode(object['history'])) {
        recordlist.add(Record.fromJson(each));
      }
    }
    return WillPopScope(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              DrawerScreen(false, serializedString),
              AnimatedContainer(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(15.0)),
                transform: Matrix4.translationValues(xOffset, yOffset, 0)
                  ..scale(scaleFactor)
                  ..rotateY(isDrawerOpen ? -0.5 : 0),
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        BorderRadius.circular(isDrawerOpen ? 40.0 : 0)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 12, top: 45),
                          child: isDrawerOpen
                              ? IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    size: ScreenUtil().setSp(70),
                                    color: Colors.purple,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      xOffset = 0;
                                      yOffset = 0;
                                      scaleFactor = 1;
                                      isDrawerOpen = false;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      xOffset = 230;
                                      yOffset = 150;
                                      scaleFactor = 0.6;
                                      isDrawerOpen = true;
                                    });
                                  }),
                        ),
                        Fade(
                            duration: Duration(milliseconds: 1100),
                            child: Padding(
                              padding: EdgeInsets.only(right: 12, top: 45),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                ),
                                onPressed: () {
                                  if (isActive) {
                                    print('编辑');
                                    //TODO
                                    MyNavigator.gotoEditStudent(
                                        context, serializedString);
                                  } else {
                                    print('非编辑状态');
                                  }
                                },
                              ),
                            ),
                            visible: isActive)
                      ],
                    ),
                    Expanded(
                      child: FlipCard(
                          key: cardKey,
                          flipOnTouch: false,
                          direction: FlipDirection.HORIZONTAL,
                          speed: 1000,
                          front: Container(
                              child: Stack(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(70),
                                        right: ScreenUtil().setWidth(70),
                                        top: ScreenUtil().setHeight(80),
                                        bottom: ScreenUtil().setWidth(70)),
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: timesheetColors[
                                          (object['StudentID'] + 1) %
                                              timesheetColors.length],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  top: ScreenUtil()
                                                      .setHeight(80),
                                                  right: ScreenUtil()
                                                      .setHeight(20)),
                                              child: Text(
                                                '个人资料',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32.0,
                                                  fontFamily: "Poppins-Bold",
                                                  letterSpacing: 1.0,
                                                ),
                                              )),
                                        ),
                                        Container(
                                          height: ScreenUtil().setHeight(150),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: Row(
                                              children: <Widget>[
                                                new Flexible(
                                                  child: Row(
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                        'assets/images/classroom.svg',
                                                        height: ScreenUtil()
                                                            .setHeight(60),
                                                        width: ScreenUtil()
                                                            .setHeight(60),
                                                        allowDrawingOutsideViewBox:
                                                            true,
                                                      ),
                                                      SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(15),
                                                      ),
                                                      Text(
                                                          object['name']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              fontFamily:
                                                                  "Poppins-Bold")),
                                                    ],
                                                  ),
                                                  flex: 2,
                                                ),
                                                new Flexible(
                                                  child: GestureDetector(
                                                      onLongPress: () {
                                                        Fluttertoast.showToast(
                                                            msg: "已复制",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.white,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 16.0);
                                                      },
                                                      onTap: () {},
                                                      child: Row(
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            'assets/images/language.svg',
                                                            height: ScreenUtil()
                                                                .setHeight(60),
                                                            width: ScreenUtil()
                                                                .setHeight(60),
                                                            allowDrawingOutsideViewBox:
                                                                true,
                                                          ),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setWidth(15),
                                                          ),
                                                          Text(object['code'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              40),
                                                                  fontFamily:
                                                                      "Poppins-Bold")),
                                                        ],
                                                      )),
                                                  flex: 1,
                                                )
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: Row(
                                              children: <Widget>[
                                                new Flexible(
                                                  child: Row(
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                        'assets/images/trophy.svg',
                                                        height: ScreenUtil()
                                                            .setHeight(60),
                                                        width: ScreenUtil()
                                                            .setHeight(60),
                                                        allowDrawingOutsideViewBox:
                                                            true,
                                                      ),
                                                      SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(15),
                                                      ),
                                                      Text(
                                                          object['level']
                                                                  .toString() +
                                                              " 级",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              fontFamily:
                                                                  "Poppins-Bold")),
                                                    ],
                                                  ),
                                                  flex: 1,
                                                ),
                                                new Flexible(
                                                  child: Row(
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                        'assets/images/flask.svg',
                                                        height: ScreenUtil()
                                                            .setHeight(60),
                                                        width: ScreenUtil()
                                                            .setHeight(60),
                                                        allowDrawingOutsideViewBox:
                                                            true,
                                                      ),
                                                      SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(15),
                                                      ),
                                                      Text(object['birthday'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              fontFamily:
                                                                  "Poppins-Bold")),
                                                    ],
                                                  ),
                                                  flex: 1,
                                                )
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: Row(
                                              children: <Widget>[
                                                new Flexible(
                                                  child: Row(
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                        'assets/images/book.svg',
                                                        height: ScreenUtil()
                                                            .setHeight(60),
                                                        width: ScreenUtil()
                                                            .setHeight(60),
                                                        allowDrawingOutsideViewBox:
                                                            true,
                                                      ),
                                                      SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(15),
                                                      ),
                                                      Text(
                                                          "剩余 " +
                                                              object['totalclass']
                                                                  .toString() +
                                                              " 节",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              fontFamily:
                                                                  "Poppins-Bold")),
                                                    ],
                                                  ),
                                                  flex: 2,
                                                ),
                                                new Flexible(
                                                  child: Row(
                                                    children: <Widget>[
                                                      object['gender']
                                                          ? SvgPicture.asset(
                                                              "assets/images/male.svg",
                                                              height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          64),
                                                              width: ScreenUtil()
                                                                  .setHeight(
                                                                      64),
                                                              allowDrawingOutsideViewBox:
                                                                  false,
                                                            )
                                                          : SvgPicture.asset(
                                                              "assets/images/female.svg",
                                                              height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          64),
                                                              width: ScreenUtil()
                                                                  .setHeight(
                                                                      64),
                                                              allowDrawingOutsideViewBox:
                                                                  false,
                                                            ),
                                                      SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(15),
                                                      ),
                                                      Text(
                                                          object['gender']
                                                              ? "男"
                                                              : "女",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              fontFamily:
                                                                  "Poppins-Bold")),
                                                    ],
                                                  ),
                                                  flex: 1,
                                                )
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: Row(
                                              children: <Widget>[
                                                new Flexible(
                                                  child: Text("学校: ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(40),
                                                          fontFamily:
                                                              "Poppins-Bold")),
                                                  flex: 1,
                                                ),
                                                new Flexible(
                                                  child: Text(object['school'],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(40),
                                                          fontFamily:
                                                              "Poppins-Bold")),
                                                  flex: 3,
                                                )
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10.0,
                                        ),
//                                        Container(
//                                          height: ScreenUtil().setHeight(100),
//                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: InkWell(
                                            child: Container(
                                              width: ScreenUtil().setWidth(200),
                                              height:
                                                  ScreenUtil().setHeight(100),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF17ead9),
                                                      Color(0xFF6078ea)
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    cardKey.currentState
                                                        .toggleCard();
                                                    setState(() {
                                                      isActive = !isActive;
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "翻转",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "Poppins-Bold",
                                                          fontSize: 18,
                                                          letterSpacing: 1.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(20),
                                      left: ScreenUtil().setHeight(20)),
                                  height: ScreenUtil().setHeight(300),
                                  width: ScreenUtil().setWidth(300),
                                  decoration: BoxDecoration(
                                      color: timesheetColors[
                                          object['StudentID'] %
                                              timesheetColors.length],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.asset(object['gender']
                                      ? boysimages[(object['StudentID'] %
                                          boysimages.length)]
                                      : girlsimages[object['StudentID'] %
                                          girlsimages.length]),
                                ),
                              ),
                            ],
                          )),
                          back: Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(70),
                                right: ScreenUtil().setWidth(70),
                                top: ScreenUtil().setHeight(80),
                                bottom: ScreenUtil().setWidth(70)),
                            height: double.maxFinite,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Color(0xFF7AA095),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(30),
                                  right: ScreenUtil().setWidth(30),
                                  top: ScreenUtil().setWidth(30)),
                              child: Column(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      '签到历史',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 46.0,
                                        fontFamily: "Poppins-Bold",
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setSp(100)),
                                        itemCount: recordlist.length,
                                        itemBuilder: (ctx, index) {
                                          return Container(
                                              margin: EdgeInsets.only(
                                                  left:
                                                      ScreenUtil().setWidth(20),
                                                  right:
                                                      ScreenUtil().setWidth(20),
                                                  top: ScreenUtil()
                                                      .setHeight(20),
                                                  bottom: ScreenUtil()
                                                      .setWidth(20)),
                                              child: Center(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(
                                                      decoration: BoxDecoration(
                                                        color: timesheetColors[
                                                            (index) %
                                                                timesheetColors
                                                                    .length],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      22.0,
                                                                  vertical:
                                                                      6.0),
                                                          child: Text(
                                                              "剩余" +
                                                                  recordlist[index]
                                                                          .toJson()[
                                                                      'rest'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              24),
                                                                  fontFamily:
                                                                      "Poppins-Bold")),
                                                        ),
                                                      ),
                                                    )),
                                                    SizedBox(
                                                      width: ScreenUtil()
                                                          .setWidth(20),
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: timesheetColors[
                                                                (index) %
                                                                    timesheetColors
                                                                        .length],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          22.0,
                                                                      vertical:
                                                                          6.0),
                                                              child: Text(
                                                                  "签到于" +
                                                                      recordlist[index]
                                                                              .toJson()[
                                                                          'time'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              24),
                                                                      fontFamily:
                                                                          "Poppins-Bold")),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ));
                                        }),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(20),
                                  ),
                                  Center(
                                    child: InkWell(
                                      child: Container(
                                        width: ScreenUtil().setWidth(200),
                                        height: ScreenUtil().setHeight(100),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Color(0xFF17ead9),
                                              Color(0xFF6078ea)
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
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
                                              cardKey.currentState.toggleCard();
                                              setState(() {
                                                isActive = !isActive;
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                "翻转",
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
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(20),
                                  ),

//                                  Center(child: RaisedButton(onPressed: () {
//                                    cardKey.currentState.toggleCard();
//                                    setState(() {
//                                      isActive = !isActive;
//                                    });
//                                  }))
                                  //RaisedButton(onPressed: () {})
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() {
    return null;
  }
}
