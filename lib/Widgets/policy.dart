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
        '用户协议 & 隐私政策',
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
          '  当完成/退出爱乐教室的学业之后,该代码以及存储的信息将会自动删除.\n\n'
      '隐私协议: \n\n'
          '本应用尊重并保护所有使用服务用户的个人隐私权。为了给您提供更准确、更有个性化的服务，本应用会按照本隐私权政策的规定使用和披露您的个人信息。但本应用将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，除本隐私政策相关有规定外在未得到您允许 的情况下，本应用不会将这些信息向第三放提供在未征得您事先许可的情况下，本应用不会将这些信息对外披露或向第三方提供。本应用会不时更新本隐私权政策。 您在同意本应用服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于本应用服务使用协议不可分割的一部分.\n\n'
          '本应用不会向任何无关第三方提供、出售、出租、分享或交易您的个人信息，除非事先得到您的许可，或该第三方和本应用（含本应用关联公司）单独或共同为您提供服务，且在该服务结束后，其将被禁止访问包括其以前能够访问的所有这些资料.\n\n'
          '如您出现违反中国有关法律、法规或者本应用服务协议或相关规则的情况，需要向第三方披露\n\n'
          '本应用收集的有关您的信息和资料将保存在本应用及（或）其关联公司的服务器上，这些信息和资料可能传送至您所在国家、地区或本应用收集信息和资料所在地的境外并在境外被访问、存储和展示.\n\n'
          '本应用帐号均有安全保护功能，请妥善保管您的用户名及密码信息。本应用将通过对用户密码进行加密等安全措施确保您的信息不丢失，不被滥用和变造。尽管有前述安全措施，但同时也请您注意在信息网络上不存在“完善的安全措施”\n\n'
          '如果决定更改隐私政策，我们会在本政策中、本公司网站中以及我们认为适当的位置发布这些更改，以便您了解我们如何收集、使用您的个人信息，哪些人可以访问这些信息，以及在什么情况下我们会透露这些信息\n\n'
          '在进行适当的身份验证后，家长或法定监护人可以查看我们收集的关于儿童的信息，要求删除或拒绝允许进一步收集或使用这些信息。请记住，删除这些信息的请求可能会限制儿童访问所有或部分服务\n\n'
          '您了解并同意我方有权随时检查您所上传或发布的内容，如果发现您上传的内容不符合前述规定，我方有权删除或重新编辑或修改您所上传或发布的内容，且有权在不事先通知您的情况下停用您的账号。您亦了解、同意并保证，您所上传或发布的内容符合前述规定，是您的义务，而非我方，我方无任何对您上传或发布的内容进行主动检查、编辑或修改的义务.\n\n'
          '我方不对用户上传或发布的内容的合法性、正当性、完整性或品质作出任何保证，用户需自行承担因使用或依赖由软件所传送的内容或资源所产生的风险，我方在任何情况下对此种风险可能或实际带来的损失或损害都不负任何责任.\n\n'
          '因技术故障等不可抗事件影响到服务的正常运行的，我方及合作方承诺在第一时间内与相关单位配合，及时处理进行修复，但用户因此而遭受的一切损失，我方及合作方不承担责任.\n\n'
          '我方为保障业务发展和调整的自主权，有权随时自行修改或中断软件服务而无需通知用户\n\n'
          '我方将会尽其商业上的合理努力以保护用户的设备资源及通讯的隐私性和完整性，但是，用户承认和同意我方不能就此事提供任何保证\n\n'
          '我方可以根据用户的使用状态和行为，为了改进软件的功能、用户体验和服务，开发或调整软件功能\n\n',
      style: const TextStyle(
        color: Colors.black87,
        fontFamily: "Poppins-Bold",
      ),
    ));
  }
}
