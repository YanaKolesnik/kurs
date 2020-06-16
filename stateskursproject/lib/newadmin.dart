import 'dart:convert';
import 'dart:io';

import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/screenutil.dart';
import 'package:loading_animations/loading_animations.dart';

import 'Animation/FadeAnimation.dart';

class NewAdmin extends StatefulWidget {
  @override
  _NewAdminState createState() => _NewAdminState();
}

class _NewAdminState extends State<NewAdmin> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String email;
  String password;
  bool body = false;

  Future<void> _submitCommand() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      setState(() {
        body = true;
      });

      var bytes = utf8.encode(email + ":" + password);
      var base64Str = base64Encode(bytes);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var d = {"base64": base64Str};
        var toJson = json.encode(d);
        http.post('http://192.168.1.11/API/NewAdmin',
            headers: {
              "Authorization": "Basic $base64Str",
              "Content-Type": "application/json"
            },
            body: toJson)
            .timeout(Duration(seconds: 15))
            .then((response) async {
          if (response.statusCode == 204) {
            setState(() {
              body = false;
            });
            final snackbar = SnackBar(
              backgroundColor: Colors.black54,
              content: Text('Success',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),),
            );
            scaffoldKey.currentState.showSnackBar(snackbar);
          } else {
            setState(() {
              body = false;
            });
            final snackbar = SnackBar(
              backgroundColor: Colors.black54,
              content: Text(response.body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),),
            );
            scaffoldKey.currentState.showSnackBar(snackbar);
          }
        });
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
    }
  }

  Widget bodySwitcher() {
    if (body == false)
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ConnectionStatusBar(
                  height: 25,
                  width: double.maxFinite,
                  color: Colors.redAccent,
                  lookUpAddress: 'google.com',
                  endOffset: const Offset(0.0, 0.0),
                  beginOffset: const Offset(0.0, -1.0),
                  animationDuration: const Duration(milliseconds: 200),
                  title: const Text(
                    'Please check your internet connection',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                FadeAnimation(2, Text(
                  'Регистрация',
                  style: TextStyle(
                      color: Colors.white,
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
                                  hintText: "Имя"
                              ),
                              validator: (val) =>
                              !EmailValidator.validate(val, true)
                                  ? 'Неправильный email.'
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
                                  hintText: "Пароль"
                              ),
                              validator: (val) =>
                              val.length < 4
                                  ? 'Пароль должен быть не менее 4 символов'
                                  : null,
                              onSaved: (val) => password = val,
                            ),
                          ),
                        ],
                      ),
                    )
                )),
                FadeAnimation(2, Center(
                  child: Container(
                    width: ScreenUtil().setHeight(400.0),
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
                            'Зарегистрировать',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: ScreenUtil().setSp(40.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ),
              ],
            ),
          )
        ],
      );
    else
      return Center(
        child: Container(
          height: ScreenUtil().setWidth(350.0),
          child: LoadingBouncingGrid.circle(
            borderColor: Colors.black,
            borderSize: ScreenUtil().setHeight(18.0),
            size: ScreenUtil().setHeight(200.0),
            backgroundColor: Colors.deepPurple,
          ),
        ),
      );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
                'Новый администратор'
            ),
          ),
          backgroundColor: Color.fromARGB(255, 20, 20, 20),
          body: bodySwitcher()
        )
    );
  }
}