import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import 'dbHelper.dart';
import 'homepage.dart';

class  SignIn extends StatefulWidget {
  String base64Str;

  SignIn(String base64Str) {
    this.base64Str = base64Str;
  }

  @override
  _SignInState createState() => new _SignInState(base64Str);
}

class _SignInState extends State< SignIn> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String userData;

  Color color = Colors.blue;

  String progress;

  _SignInState(String base64str) {
    this.userData = base64str;
  }

  void _checkLogin() {
    setState(() {
      progress = 'Data checking...';
    });

    http.get('http://192.168.1.11/api',
        headers: {"Authorization": "Basic $userData"})
        .timeout(Duration(seconds: 15))
        .then((response) async {
      if (response.statusCode == 200) {

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('base', userData);
            _goToHomePage();
      }else if (response.statusCode == 401) {
        Navigator.pop(context, 'Wrong login or password.');
      }else {
        final snackbar = SnackBar(
          backgroundColor: Colors.black54,
          content: Text(response.body,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
        Duration(seconds: 3);
        Navigator.pop(context, 'Server is not available.');
      }

    }).catchError((error) {
      final snackbar = SnackBar(
        backgroundColor: Colors.black54,
        content: Text(error,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    });
  }


  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    return Scaffold(
      key: scaffoldKey,
      body:
      Center(
        child: Container(
          height: ScreenUtil().setWidth(350.0),
          child:
          Column(
            children: <Widget>[
              LoadingBouncingGrid.circle(
                borderColor: color,
                borderSize: ScreenUtil().setHeight(18.0),
                size: ScreenUtil().setHeight(200.0),
                backgroundColor: Colors.deepPurple,
              ),
              SizedBox(
                height: ScreenUtil().setWidth(22.0),
              ),
              Text(progress,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.blueGrey,
                  fontSize: ScreenUtil().setSp(66.0),
                ),
              ),
            ],
          ),
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