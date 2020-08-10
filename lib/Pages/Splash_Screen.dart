import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:studentmanager/Navigators/Navi.dart';
import 'package:studentmanager/Widgets/brandName.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 4000), () => MyNavigator.goToHome(context));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xFF1b1e44),
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: false,
        body: Stack(fit: StackFit.expand, children: <Widget>[
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
        ]));
//    return Scaffold(
//      body:
//    return Scaffold(
//      body: Stack(
//        fit: StackFit.expand,
//        children: <Widget>[
//          Container(
//            decoration: BoxDecoration(color: Colors.white),
//          ),
//          Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Expanded(
//                flex: 3,
//                child: Container(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                     Image.asset(
//                      "assets/logo4.png",
//                      height: 150,
//                      width: 150,
//                    ),
//                      Padding(
//                        padding: EdgeInsets.only(top: 10.0),
//                      ),
//                      Text("爱乐教室",
//                        style: TextStyle(
//                            fontFamily: "Poppins-Bold",
//                            fontSize: 20,
//                            letterSpacing: .6,
//                            fontWeight: FontWeight.bold
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              Expanded(
//                flex: 1,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    SpinKitFadingGrid(
//                      size: 60,
//                      itemBuilder: (BuildContext context, int index) {
//                        List<Color> colors = [Color(0xFFFFCC57), Color(0xFFEF802F),Color(0xFFDB5192),Color(0xFFEF802F),Color(0xFFDB5192),Color(0xFFFFCC57),Color(0xFFDB5192),Color(0xFFFFCC57),Color(0xFFEF802F)];
//                        return DecoratedBox(
//                          decoration: BoxDecoration(
//                              color: colors[index]
//                          ),
//                        );
//                      },
//                    ),
//                  ],
//                ),
//              ),
//              Expanded(
//                  flex: 1,
//                  child: Align(
//                alignment: Alignment.bottomCenter,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text("©生活即艺术 - 爱乐教室",
//                        style: TextStyle(
//                            fontSize: 10.0,
//                            fontFamily: "Poppins-Medium")),
//                  ],
//                ),
//              ))
//            ],
//          )
//        ],
//      ),
//    );
  }
}
