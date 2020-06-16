import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:stateskursproject/Animation/FadeAnimation.dart';

import 'dbHelper.dart';


class New extends Model{

  static String table = 'NewArticles';

  int id;
  String Point;
  String ImageLink;
  String Header;
  String Text;

  New({this.Point, this.ImageLink, this.Header, this.Text});

  factory New.fromMap(Map<String, dynamic> json){
    return New(
        Point: json['Point'],
        ImageLink: json['ImageLink'],
        Header: json['Header'],
        Text: json['Text']
    );
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'Point' : Point,
      'ImageLink' : ImageLink,
      'Header' : Header,
      'Text' : Text,
    };
    return map;
  }
}

class NewArticle extends StatefulWidget {
  String base64;
  NewArticle(String base64){
    this.base64 = base64;
  }
  @override
  _NewArticleState createState() => _NewArticleState(base64: base64);
}

class _NewArticleState extends State<NewArticle> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _NewArticleState({this.base64});

  String base64;
  bool body = false;

  String imageLink, header, text;

  String dropdownValue = 'Биология';
  int point;
  bool connect = false;

  void _submitCommand() async {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() {
        body = true;
      });
      form.save();
      await _check();
      if (connect == true) {
        var d = {
          "point": dropdownValue,
          "imageLink": imageLink,
          "header": header,
          "text": text
        };
        var toJson = json.encode(d);
        http.post('http://192.168.1.11/API/NewArticle',
            headers: {
              "Authorization": "Basic $base64",
              "Content-Type": "application/json"
            },
            body: toJson)
            .timeout(Duration(seconds: 15))
            .then((response) async {
          if (response.statusCode == HttpStatus.ok) {
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
        New newArticle = New(Point: dropdownValue,
            ImageLink: imageLink,
            Header: header,
            Text: text);
        await DB.init();
        if (newArticle != null)
          await DB.insert(New.table, newArticle);

        setState(() {
          body = false;
        });
        var snackbar = SnackBar(
          backgroundColor: Colors.black54,
          content: Text('Сохранено',
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

  void _check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      connect = true;
    }
    if (connectivityResult == ConnectivityResult.wifi) {
      connect = true;
    }
    setState(() {});
  }

  Widget bodySwitcher() {
    if (body == false)
      return ListView(
        children: <Widget>[
          Container(
            child: Center(
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>[
                  'Биология',
                  'География',
                  'История',
                  'Математика',
                  'Физика',
                  'Актеры',
                  'Изобретатели',
                  'Писатели',
                  'Рыбы',
                  'Птицы',
                  'Насекомые',
                  'Звери',
                  'Динозавры',
                  'Космос',
                  'Игры',
                  'Технологии'
                ]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          Form(
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
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.grey
                      ),
                      hintText: "Ссылка на изображение",
                    ),
                    validator: (val) =>
                    val.length < 1
                        ? 'Пустое поле'
                        : null,
                    onSaved: (val) => imageLink = val,
                  ),
                )),
                FadeAnimation(2, Container(
                  height: 80.0,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                          color: Colors.grey[100]
                      ))
                  ),
                  child: TextFormField(
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        hintText: "Заголовок"
                    ),
                    validator: (val) =>
                    val.length < 1
                        ? 'Пустое поле'
                        : null,
                    onSaved: (val) => header = val,
                  ),
                )),
                FadeAnimation(2, Container(
                  height: 80.0,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                          color: Colors.grey[100]
                      ))
                  ),
                  child: TextFormField(
                    style: TextStyle(color: Colors.blue),
                    minLines: 6,
                    maxLines: 15,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        hintText: "Текст"
                    ),
                    validator: (val) =>
                    val.length < 1
                        ? 'Пустое поле'
                        : null,
                    onSaved: (val) => text = val,
                  ),
                ),
                ),
                FadeAnimation(2, Center(
                  child: Container(
                    width: ScreenUtil().setHeight(500.0),
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
                            'Опубликовать',
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
  void initState() {
    super.initState();
    _check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
              'Новая статья'
          ),
        ),
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        body: bodySwitcher()
    );
  }
}
