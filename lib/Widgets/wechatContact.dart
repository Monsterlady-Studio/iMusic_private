import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class wechatContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Image.asset(
          'assets/images/wechatQR.jpg',
          //scale: 0.6,
        ),
      ),
    );
  }
}
