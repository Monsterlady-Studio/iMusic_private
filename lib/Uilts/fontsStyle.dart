import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

TextStyle large = TextStyle(
  color: Color(0xFF1b1e44),
  fontSize: 46.0,
  fontFamily: "Poppins-Bold",
  letterSpacing: 1.0,
);

TextStyle medium = TextStyle(
    fontFamily: "Poppins-Bold",
    color: Color(0xFF1b1e44),
    fontSize: ScreenUtil().setSp(46),
    letterSpacing: .6,
    fontWeight: FontWeight.bold);

TextStyle small = TextStyle(
    fontFamily: "Poppins-Bold",
    color: Color(0xFF1b1e44),
    fontSize: ScreenUtil().setSp(32),
    letterSpacing: .6,
    fontWeight: FontWeight.bold);

TextStyle small2 = TextStyle(
    fontFamily: "Poppins-Bold",
    color: Colors.blueAccent,
    fontSize: ScreenUtil().setSp(32),
    letterSpacing: .6,
    fontWeight: FontWeight.bold);

TextStyle error = TextStyle(
    fontFamily: "Poppins-Bold",
    color: Colors.red,
    fontSize: ScreenUtil().setSp(46),
    letterSpacing: .6,
    fontWeight: FontWeight.bold);
