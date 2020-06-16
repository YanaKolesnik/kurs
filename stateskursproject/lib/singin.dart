import 'dart:convert';
import 'dart:io';

import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stateskursproject/homepage.dart';

import 'Animation/FadeAnimation.dart';
import 'loading.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String email;
  String password;


  Future<void> _submitCommand() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      var bytes = utf8.encode(email + ":" + password);
      var base64Str = base64Encode(bytes);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        http.get('http://192.168.1.11/API',
            headers: {"Authorization": "Basic $base64Str"})
            .then((response) async {
          var flag = json.decode(response.body)['Claims'];

          if(flag.toString().contains('Type: hasRegistered, Value: true'))
          {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('base', base64Str);
            Navigator.pop(context, true);
          }
          else {
          var snackbar = SnackBar(
          backgroundColor: Colors.black54,
          content: Text('Проверьте логин или пароль!',
          textAlign: TextAlign.center,
          style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          ),),
          );
          scaffoldKey.currentState.showSnackBar(snackbar);
          }
        }).catchError((error) {
          final snackbar = SnackBar(
            backgroundColor: Colors.black54,
            content: Text(error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),),
          );
          scaffoldKey.currentState.showSnackBar(snackbar);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(500.0),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/background9.jpg'),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(2, Text(
                    'Login',
                    style: TextStyle(
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0
                    ),
                  )),
                  SizedBox(
                    height: ScreenUtil().setWidth(40.0),
                  ),
                  FadeAnimation(2, Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(100, 253, 189, 200),
                              blurRadius: 20.0,
                              offset: Offset(0, 10)
                          )
                        ]
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(2, Container(
                            height: 80.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    color: Colors.grey[100]
                                ))
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username"
                              ),
                              validator: (val) =>
                              !EmailValidator.validate(val, true)
                                  ? 'Not a valid email.'
                                  : null,
                              onSaved: (val) => email = val,
                            ),
                          )),
                          Container(
                            height: 80.0,
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password"
                              ),
                              validator: (val) =>
                              val.length < 4
                                  ? 'Password shorter than 6 characters.'
                                  : null,
                              onSaved: (val) => password = val,
                              obscureText: true,
                            ),
                          )
                        ],
                      ),
                    )

                  )),
                  SizedBox(
                    height: ScreenUtil().setHeight(20.0),
                  ),

                  SizedBox(
                    height: ScreenUtil().setWidth(100.0),
                  ),
                  FadeAnimation(2, Center(
                      child: Container(
                        width: ScreenUtil().setHeight(300.0),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(30.0)),
                        height: ScreenUtil().setWidth(130.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color.fromARGB(100, 253, 189, 200),
                          elevation: 6,
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _submitCommand();
                            },
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: ScreenUtil().setSp(66.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: ScreenUtil().setWidth(300.0),
                  ),

                  SizedBox(
                    height: ScreenUtil().setWidth(270.0),
                  ),
                  ConnectionStatusBar(
                    height: 25,
                    width: double.maxFinite,
                    color: Colors.redAccent,
                    lookUpAddress: 'google.com',
                    endOffset: const Offset(0.0, -1.0),
                    beginOffset: const Offset(0.0, 1.0),
                    animationDuration: const Duration(milliseconds: 200),
                    title: const Text(
                      'Please check your internet connection',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _goToHomePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage()),
    );
  }
}