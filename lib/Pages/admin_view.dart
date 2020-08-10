import 'dart:async';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nima/nima_actor.dart';
import 'package:search_page/search_page.dart';
import 'package:studentmanager/Pages/menu_page.dart';
import 'package:studentmanager/Uilts/api.dart';
import 'package:studentmanager/Uilts/data.dart';
import 'package:studentmanager/Uilts/fontsStyle.dart';
import 'package:studentmanager/Widgets/customIcons.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => new _AdminScreenState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _AdminScreenState extends State<AdminScreen> {
  var counts;
  var currentPage;
  var studentlist;
  List<LCObject> assignedList;
  List<LCObject> unassignedList;
  String _animationName = 'default';
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  bool editable = false;

  Widget _mainPage() {
    PageController controller = PageController(
      initialPage: counts - 1,
    );
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    return FlutterEasyLoading(
        child: LiquidPullToRefresh(
      onRefresh: () async {
        initData();
        controller.jumpToPage(counts - 1);
      },
      // refresh callback
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 30.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  isDrawerOpen
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
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Color(0xFF1b1e44),
                      size: 30.0,
                    ),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SearchPage<LCObject>(
                          items: studentlist,
                          searchLabel: '搜索学生',
                          barTheme: ThemeData(
                            primaryColor: Colors.white,
                          ),
                          suggestion: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: ScreenUtil().setHeight(80),
                                ),
                                Container(
                                  height: ScreenUtil().setHeight(400),
                                  width: ScreenUtil().setWidth(400),
                                  child: NimaActor("assets/animation/bihu.nma",
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                      animation: "Idle",
                                      mixSeconds: 0.5),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(20),
                                ),
                                Text('通过学生名字或课程代码来搜索', style: medium)
                              ],
                            ),
                          ),
                          failure: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: ScreenUtil().setHeight(80),
                                ),
                                Container(
                                  height: ScreenUtil().setHeight(400),
                                  width: ScreenUtil().setWidth(400),
                                  child: NimaActor(
                                      "assets/animation/newton.nma",
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                      animation: "Idle",
                                      mixSeconds: 0.5),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(20),
                                ),
                                Text(
                                  '没有找到哦!',
                                  style: error,
                                )
                              ],
                            ),
                          ),
                          filter: (person) => [person['name'], person['code']],
                          builder: (person) => Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(60),
                                bottom: ScreenUtil().setHeight(40)),
                            child: _searchItemView(person, true),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("学生列表",
                      style: TextStyle(
                        color: Color(0xFF1b1e44),
                        fontSize: 46.0,
                        fontFamily: "Poppins-Bold",
                        letterSpacing: 1.0,
                      )),
                  IconButton(
                    icon: Icon(
                      customIcons.option,
                      size: 12.0,
                      color: Color(0xFF1b1e44),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => _gridView(assignedList, true),
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFff6e6e),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 6.0),
                        child: Text("已分配",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold")),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(assignedList.length.toString() + " 个", style: small2)
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setHeight(970),
                  child: PageView.builder(
                    physics: new BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: assignedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: ScreenUtil().setHeight(50),
                        color: Colors.transparent,
                        child: _cardView(assignedList[index], index, true),
                      );
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("待安排",
                      style: TextStyle(
                        color: Color(0xFF1b1e44),
                        fontSize: 46.0,
                        fontFamily: "Poppins-Bold",
                        letterSpacing: 1.0,
                      )),
                  IconButton(
                    icon: Icon(
                      customIcons.option,
                      size: 12.0,
                      color: Color(0xFF1b1e44),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => _gridView(unassignedList, false),
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 6.0),
                        child: Text("未分配",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold")),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(unassignedList.length.toString() + " 个", style: small2)
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(500),
              child: PageView.builder(
                physics: new BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: unassignedList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: ScreenUtil().setHeight(50),
                    color: Colors.transparent,
                    child: _cardView(unassignedList[index], index, false),
                  );
                },
              ),
            ),
//            Row(
//              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.only(left: 18.0),
//                  child: ClipRRect(
//                    borderRadius: BorderRadius.circular(20.0),
//                    child: Image.asset("assets/images/image_02.jpg",
//                        width: 296.0, height: 222.0),
//                  ),
//                )
//              ],
//            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
      showChildOpacityTransition: false,
      springAnimationDurationInMilliseconds: 500,
      color: Color(0xFF1b1e44),
      backgroundColor: Colors.white,
    ));
  }

  Widget _gridView(List<LCObject> list, bool b) {
    return new AlertDialog(
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          b ? '已分配' : '未安排',
          textAlign: TextAlign.center,
          style: medium,
        ),
        content: Material(
          child: Scaffold(
            body: new StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) =>
                  new GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(
                        '/add',
                        arguments: list[index].toString(),
                      )
                      .then((val) => val ? initData() : null);
                },
                child: new Container(
                    color: timesheetColors[
                        list[index]['StudentID'] % timesheetColors.length],
                    child: new Center(
                      child: new Text(list[index]['name'], style: small),
                    )),
              ),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          ),
        ),
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
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Text(
                      "关闭",
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
        ]);
  }

  Widget _cardView(LCObject lcObject, var i, bool b) {
    return ShakeAnimatedWidget(
      enabled: editable,
      duration: Duration(milliseconds: 250),
      shakeAngle: Rotation.deg(z: 0.5),
      curve: Curves.linear,
      child: Padding(
        padding: EdgeInsets.only(left: 30.0, right: 30.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: timesheetColors[
                    lcObject['StudentID'] % timesheetColors.length],
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
            child: AspectRatio(
              aspectRatio: cardAspectRatio,
              child: Column(
                //fit: StackFit.expand,
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(
                                '/add',
                                arguments: lcObject.toString(),
                              )
                              .then((val) => val ? initData() : null);
                          //MyNavigator.goToEdit(context, lcObject.toString());
                        },
                        onLongPress: () {
                          setState(() {
                            editable = !editable;
                          });
                        },
                        child: Image.asset(
                            lcObject['gender']
                                ? boysimages[
                                    lcObject['StudentID'] % boysimages.length]
                                : girlsimages[
                                    lcObject['StudentID'] % girlsimages.length],
                            fit: BoxFit.fill),
                      ),
                      flex: 1),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                children: <Widget>[
                                  new Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/images/classroom.svg',
                                          height: ScreenUtil().setHeight(60),
                                          width: ScreenUtil().setHeight(60),
                                          allowDrawingOutsideViewBox: true,
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(15),
                                        ),
                                        Text(lcObject['name'].toString(),
                                            style: small),
                                      ],
                                    ),
                                    flex: 2,
                                  ),
                                  new Flexible(
                                    child: GestureDetector(
                                        onLongPress: () {
                                          Fluttertoast.showToast(
                                              msg: "已复制",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                        },
                                        onTap: () {},
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/images/language.svg',
                                              height:
                                                  ScreenUtil().setHeight(60),
                                              width: ScreenUtil().setHeight(60),
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(15),
                                            ),
                                            Text(lcObject['code'],
                                                style: small),
                                          ],
                                        )),
                                    flex: 1,
                                  )
                                ],
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          b
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      new Flexible(
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/images/trophy.svg',
                                              height:
                                                  ScreenUtil().setHeight(60),
                                              width: ScreenUtil().setHeight(60),
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(15),
                                            ),
                                            Text(
                                                lcObject['level'].toString() +
                                                    " 级",
                                                style: small),
                                          ],
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/images/flask.svg',
                                              height:
                                                  ScreenUtil().setHeight(60),
                                              width: ScreenUtil().setHeight(60),
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(15),
                                            ),
                                            Text(lcObject['birthday'],
                                                style: small),
                                          ],
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ))
                              : Container(),
                          b
                              ? SizedBox(
                                  height: 10.0,
                                )
                              : Container(),
                          b
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      new Flexible(
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/images/book.svg',
                                              height:
                                                  ScreenUtil().setHeight(60),
                                              width: ScreenUtil().setHeight(60),
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(15),
                                            ),
                                            Text(
                                                "剩余 " +
                                                    lcObject['totalclass']
                                                        .toString() +
                                                    " 节",
                                                style: small),
                                          ],
                                        ),
                                        flex: 2,
                                      ),
                                      new Flexible(
                                        child: Row(
                                          children: <Widget>[
                                            lcObject['gender']
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
                                                  ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(15),
                                            ),
                                            Text(lcObject['gender'] ? "男" : "女",
                                                style: small),
                                          ],
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ))
                              : Container(),
                          Center(
                            child: SizedBox(
                              width: ScreenUtil().setWidth(250),
                              height: ScreenUtil().setHeight(120),
                              child: GestureDetector(
                                onTap: () => _onButtonTap(lcObject, editable),
                                child: new FlareActor(
                                    editable
                                        ? "assets/animation/delete.flr"
                                        : 'assets/animation/yes.flr',
                                    animation:
                                        editable ? "Error" : _animationName,
                                    fit: BoxFit.cover,
                                    callback: (animationName) {
                                  //Navigate to new page here
                                  //hint: the animationName parameter tells you the name
                                  //      of the animation that finished playing
                                  if (animationName == 'success') {
                                    setState(() {
                                      _animationName = 'default';
                                    });
                                  }
                                }),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchItemView(LCObject lcObject, bool b) {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          decoration: BoxDecoration(
              color: timesheetColors[
                  lcObject['StudentID'] % timesheetColors.length],
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(3.0, 6.0),
                    blurRadius: 10.0)
              ]),
          child: AspectRatio(
            aspectRatio: cardAspectRatio,
            child: Column(
              //fit: StackFit.expand,
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(
                              '/add',
                              arguments: lcObject.toString(),
                            )
                            .then((val) => val ? initData() : null);
                        //MyNavigator.goToEdit(context, lcObject.toString());
                      },
                      onLongPress: () {
                        setState(() {
                          editable = !editable;
                        });
                      },
                      child: Image.asset(
                          lcObject['gender']
                              ? boysimages[
                                  lcObject['StudentID'] % boysimages.length]
                              : girlsimages[
                                  lcObject['StudentID'] % girlsimages.length],
                          fit: BoxFit.fill),
                    ),
                    flex: 1),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: <Widget>[
                                new Flexible(
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/images/classroom.svg',
                                        height: ScreenUtil().setHeight(60),
                                        width: ScreenUtil().setHeight(60),
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(15),
                                      ),
                                      Text(lcObject['name'].toString(),
                                          style: small),
                                    ],
                                  ),
                                  flex: 2,
                                ),
                                new Flexible(
                                  child: GestureDetector(
                                      onLongPress: () {
                                        Fluttertoast.showToast(
                                            msg: "已复制",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                      },
                                      onTap: () {},
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            'assets/images/language.svg',
                                            height: ScreenUtil().setHeight(60),
                                            width: ScreenUtil().setHeight(60),
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(15),
                                          ),
                                          Text(lcObject['code'], style: small),
                                        ],
                                      )),
                                  flex: 1,
                                )
                              ],
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        b
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    new Flexible(
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            'assets/images/trophy.svg',
                                            height: ScreenUtil().setHeight(60),
                                            width: ScreenUtil().setHeight(60),
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(15),
                                          ),
                                          Text(
                                              lcObject['level'].toString() +
                                                  " 级",
                                              style: small),
                                        ],
                                      ),
                                      flex: 1,
                                    ),
                                    new Flexible(
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            'assets/images/flask.svg',
                                            height: ScreenUtil().setHeight(60),
                                            width: ScreenUtil().setHeight(60),
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(15),
                                          ),
                                          Text(lcObject['birthday'],
                                              style: small),
                                        ],
                                      ),
                                      flex: 1,
                                    )
                                  ],
                                ))
                            : Container(),
                        b
                            ? SizedBox(
                                height: 10.0,
                              )
                            : Container(),
                        b
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    new Flexible(
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            'assets/images/book.svg',
                                            height: ScreenUtil().setHeight(60),
                                            width: ScreenUtil().setHeight(60),
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(15),
                                          ),
                                          Text(
                                              "剩余 " +
                                                  lcObject['totalclass']
                                                      .toString() +
                                                  " 节",
                                              style: small),
                                        ],
                                      ),
                                      flex: 2,
                                    ),
                                    new Flexible(
                                      child: Row(
                                        children: <Widget>[
                                          lcObject['gender']
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
                                                ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(15),
                                          ),
                                          Text(lcObject['gender'] ? "男" : "女",
                                              style: small),
                                        ],
                                      ),
                                      flex: 1,
                                    )
                                  ],
                                ))
                            : Container(),
                        SizedBox(
                          height: ScreenUtil().setHeight(15),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
    initJpush();
    initData();
  }

  Future<void> initData() async {
    RestApi().getCount().then((value) => {
          setState(() {
            counts = value;
            currentPage = counts - 1.0;
          })
        });
    RestApi().getStudentList().then((value) => {
          setState(() {
            studentlist = value;
            assignedList = new List<LCObject>();
            unassignedList = new List<LCObject>();
            for (var each in studentlist) {
              if (each['events'] != null && each['events'].toString() != '[]') {
                assignedList.add(each);
              } else {
                unassignedList.add(each);
              }
            }
          })
        });
  }

  Future<void> _onButtonTap(LCObject lcObject, bool editable) async {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        title: new Text(editable ? ' 删除' : '签到', style: medium),
        content: new Text(editable
            ? '您要删除' + lcObject['name'] + '吗?'
            : '您要给' + lcObject['name'] + '签到吗?'),
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
                  onTap: () async {
                    if (editable) {
                      Navigator.of(context).pop(false);
                      await lcObject.delete().then((value) => initData());
                    }
                    Navigator.of(context).pop(false);
                    await RestApi()
                        .attendClass(lcObject, context)
                        .then((value) => {
                              if (value)
                                {
                                  EasyLoading.dismiss(),
                                  setState(() {
                                    if (_animationName == 'default') {
                                      _animationName = 'success';
                                    }
                                  })
                                }
                            });
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
  }

  @override
  Widget build(BuildContext context) {
    final String serializedString = ModalRoute.of(context).settings.arguments;
    if (counts == null || studentlist == null) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                        child: new FlareActor(
                      "assets/animation/wait.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      animation: "animation",
                    )),
                  ])
            ],
          ),
        ),
      );
    }

    PageController controller = PageController(
      initialPage: counts - 1,
    );
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return WillPopScope(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              DrawerScreen(true, serializedString),
              AnimatedContainer(
                padding: EdgeInsets.only(top: 15.0),
                transform: Matrix4.translationValues(xOffset, yOffset, 0)
                  ..scale(scaleFactor)
                  ..rotateY(isDrawerOpen ? -0.5 : 0),
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        BorderRadius.circular(isDrawerOpen ? 40.0 : 0)),
                child: _mainPage(),
              )
            ],
          ),
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() {
    return null;
  }

  void initJpush() {
    JPush jpush = new JPush();
    jpush.setTags(["student"]).then((value) => print(value));
    jpush.getAllTags().then((value) => print(value));
  }
}
