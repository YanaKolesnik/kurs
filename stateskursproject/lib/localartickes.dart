import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stateskursproject/newarticle.dart';
import 'package:http/http.dart' as http;

import 'dbHelper.dart';

class LocalArticles extends StatefulWidget {
  String base64;
  LocalArticles(String base64){
    this.base64 = base64;
  }
  @override
  _LocalArticlesState createState() => _LocalArticlesState(base64: base64);
}

class _LocalArticlesState extends State<LocalArticles> {

  _LocalArticlesState({this.base64});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String base64, result = 'Подождите...';

  var list;

  void _repeat(int i) async {
      var d = {
        "point": list.elementAt(i)['Point'].toString(),
        "imageLink": list.elementAt(i)['ImageLink'].toString(),
        "header": list.elementAt(i)['Header'].toString(),
        "text": list.elementAt(i)['Text'].toString()
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
          DB.delete(
              list.elementAt(i)['Point'].toString(),
              list.elementAt(i)['Header'].toString()
          );
          _fromDB();
            final snackbar = SnackBar(
              backgroundColor: Colors.black54,
              content: Text('Опубликовано',
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
    setState(() {});
  }

  void _fromDB() async {
    await DB.init();
    list = await DB.query(New.table);
    result = 'Список пуст';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fromDB();
  }

  Widget _body() {
    if (list == null || list.length == 0)
      return Center(
        child: Container(
          child: Text(result,
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.deepPurple,
                fontWeight: FontWeight.w100
            ),
          ),
        ),
      );
    else
      return ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Slidable(
              actionPane: SlidableBehindActionPane(),
              closeOnScroll: true,
              actionExtentRatio: 0.30,
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Опубликовать',
                  color: Colors.greenAccent,
                  icon: Icons.cached,
                  onTap: () {
                    _repeat(index);
                  },
                ),
              ],
              secondaryActions:
              <Widget>[
                IconSlideAction(
                  caption: 'Удалить',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    DB.delete(
                        list.elementAt(index)['Point'].toString(),
                        list.elementAt(index)['Header'].toString()
                    );
                    _fromDB();
                  },
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                width: 5000.0,
                child: Material(
                  shadowColor: Colors.deepPurple,
                  color: Colors.black54,
                  elevation: 6,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(6.6),
                            bottom: ScreenUtil().setHeight(36.6)),
                        child: Text(
                          list.elementAt(index)['Point']
                              .toString(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(50.0),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(36.6)),
                        child: Text(
                          list.elementAt(index)['Header']
                              .toString(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(50.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: _body()
    );
  }
}
