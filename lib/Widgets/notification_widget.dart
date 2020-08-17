import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Uilts/fontsStyle.dart';
import 'brandName.dart';

class NotificationWidget extends StatefulWidget {
  String title;
  String content;
  @override
  _notificationWidget createState() =>
      new _notificationWidget(this.title, this.content);

  NotificationWidget(this.title, this.content);
}

class _notificationWidget extends State<NotificationWidget> {
  String title;
  String content;
  _notificationWidget(this.title, this.content);

  static const TextStyle linkStyle = const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
      fontFamily: "Poppins-Bold",
      fontSize: 10);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: Container(
        decoration: BoxDecoration(
          color: Color(0xFFff6e6e),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
            child: Text(title, style: medium),
          ),
        ),
      ),
      content: new Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        body: new Container(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              new Expanded(
                child: SingleChildScrollView(
                  child: _buildAboutText(),
                ),
                flex: 4,
              ),
              new Expanded(
                child: new RichText(
                    text: new TextSpan(
                        style: const TextStyle(color: Colors.black87),
                        children: <TextSpan>[
                      const TextSpan(
                          text: '* 使用该应用则代表您同意该用户协议及隐私政策\n',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: "Poppins-Bold",
                          )),
                      const TextSpan(
                          text: '* 该应用的开发、维护版权归属于',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: "Poppins-Bold",
                          )),
                      new TextSpan(
                        text: '©MonsterLady Studio\n',
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            const url = 'https://monsterlady.github.io';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                      ),
                      const TextSpan(
                          text: '* 该应用根据',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: "Poppins-Bold",
                          )),
                      new TextSpan(
                          text: '《中华人民共和国网络安全法》',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  'http://www.cac.gov.cn/2016-11/07/c_1119867116_2.htm';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }),
                      const TextSpan(
                          text:
                              '等国家相关法律、法规、规章的要求，结合推荐性国家标准制定并建立个人信息保护制度，通过采取技术措施和其他必要措施来保护您的个人信息安全。',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: "Poppins-Bold",
                          ))
                    ])),
                flex: 1,
              ),
              new Expanded(
                child: brandName(),
                flex: 1,
              ),
            ],
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
      ],
    );
  }

  Widget _buildAboutText() {
    return new RichText(
        text: new TextSpan(
      text: content,
      style: medium,
    ));
  }
}
