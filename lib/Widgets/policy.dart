import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studentmanager/Widgets/brandName.dart';
import 'package:url_launcher/url_launcher.dart';

class policy extends StatefulWidget {
  @override
  _policy createState() => new _policy();
}

class _policy extends State<policy> {
  static const TextStyle linkStyle = const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
      fontFamily: "Poppins-Bold",
      fontSize: 10);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text(
        '用户协议',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "Poppins-Bold",
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
                flex: 7,
              ),
              new Expanded(
                child: new RichText(
                    text: new TextSpan(
                        style: const TextStyle(color: Colors.black87),
                        children: <TextSpan>[
                      const TextSpan(
                          text: '* 使用该应用则代表您同意该用户协议\n',
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
                flex: 2,
              ),
              new Expanded(
                child: brandName(),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
//      content: new  SingleChildScrollView(
//        child: Padding(
//            padding: EdgeInsets.only(left: 0, right: 0, top: 0),
//            child: new Column(
//              mainAxisSize: MainAxisSize.max,
//              //mainAxisAlignment: MainAxisAlignment.center,
//              //crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                _buildAboutText(),
//                Align(
//                  alignment: Alignment.bottomCenter,
//                  child: brandName(),
//                ),
//              ],
//            ),
//        ),
//      ),
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
      text: '关于此应用:\n'
          '  通过使用本应用,我们希望每位学员能够更好的掌握自己的学习进度以及提高爱乐教室与每位学员的沟通质量.\n\n'
          '课程代码：\n'
          '  课程代码对应每一位在爱乐教室学习的学生的课程信息和个人资料的唯一查询词. 通过输入课程代码, 使用者本人和老师有权查看、修改及管理个人信息, 您有义务妥善保存您的课程代码.\n\n'
          '隐私性：\n'
          ' 该应用面向爱乐教室学生和老师, 您有义务维护您的使用权.\n\n'
          '如何获得:\n'
          '  当完成课时注册之后, 爱乐教室将以短信形式告知您. \n\n'
          '忘记/丢失了课程代码:\n'
          '  请在合适的时间通过主页下方的联系方式通知您的老师.\n\n'
          '如何注销: \n'
          '  当完成/退出爱乐教室的学业之后,该代码以及存储的信息将会自动删除.\n\n',
      style: const TextStyle(
        color: Colors.black87,
        fontFamily: "Poppins-Bold",
      ),
    ));
  }
}
