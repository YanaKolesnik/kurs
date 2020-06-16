import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'articlePage.dart';
import 'dbHelper.dart';

class ArticleMenu extends StatefulWidget {

  String title;
  String urlP;

  ArticleMenu(this.title, this.urlP);

  @override
  _ArticleMenuState createState() => _ArticleMenuState(title, urlP);
}

class _ArticleMenuState extends State<ArticleMenu> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String dropdownValue = 'Сначала старые';
  String title;
  String urlP;
  var list;
  bool reverse = false;

  _ArticleMenuState(String title, String urlP) {
    this.title = title;
    this.urlP = urlP;
  }

  Future _getData() async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      http.get(urlP)
          .then((response) async {
        print(response.body);
          list = json.decode(response.body);
            setState(() {});
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
    else{

//      читаем базу---------------------------------------------------------------------------------------------------------

    }

  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
      ),
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      body: Column(
        children: <Widget>[
          Container(
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
                  if(newValue == 'Сначала старые')
                    reverse = false;
                  else reverse = true;
                  setState(() { });
                });
              },
              items: <String>['Сначала старые', 'Сначала новые']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            reverse: reverse,
            itemCount: list == null ? 0 : list.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green,
                    elevation: 6,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ArticlePage(
                                      urlP + '/' + (list[index]['ID']).toString(), list[index]['Rating'])),
                        );
                      },
                      child: Center(
                        child: Text(
                          list[index]['Name_article'],
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
              );
            },
          ),
        ],
      ),
    );
  }
}
