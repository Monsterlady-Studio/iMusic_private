import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studentmanager/Uilts/fontsStyle.dart';

class brandName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Image.asset(
            "assets/images/logo4.png",
            width: ScreenUtil().setWidth(110),
            height: ScreenUtil().setHeight(100),
          ),
          Text(
            "爱乐教室",
            style: small,
          ),
        ]);
  }
}
