import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stateskursproject/homepage.dart';
import 'package:stateskursproject/localartickes.dart';
import 'package:stateskursproject/newadmin.dart';

import 'newarticle.dart';

class AdminPage extends StatefulWidget {
  String base64;
  AdminPage(String base64){
    this.base64 = base64;
  }
  @override
  _AdminPageState createState() => _AdminPageState(base64: base64);
}

class _AdminPageState extends State<AdminPage> {

  String base64;
  _AdminPageState({this.base64});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Администраторская часть'
        ),
      ),
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(100.0),
          ),
          Container(
              height: ScreenUtil().setHeight(200.0),
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color.fromARGB(255, 28, 28, 28)
              ),
              child: InkWell(
                onTap: ()async {
                  final returnedResult = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NewAdmin()));
                },
                child: Center(
                  child: Text(
                    'Добавить нового администратора',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white
                    ),
                  ),
                ),
              )

          ),
          Container(
              height: ScreenUtil().setHeight(200.0),
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color.fromARGB(255, 28, 28, 28)
              ),
              child: InkWell(
                onTap: ()async {
                  final returnedResult = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => NewArticle(base64)));
                },
                child: Center(
                  child: Text(
                    'Добавить новую статью',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white
                    ),
                  ),
                ),
              )
          ),
          Container(
              height: ScreenUtil().setHeight(200.0),
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color.fromARGB(255, 28, 28, 28)
              ),
              child: InkWell(
                onTap: ()async {
                  final returnedResult = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LocalArticles(base64)));
                },
                child: Center(
                  child: Text(
                    'Локальные статьи',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white
                    ),
                  ),
                ),
              )
          ),
          SizedBox(
            height: ScreenUtil().setHeight(100.0),
          ),
          Container(
              height: ScreenUtil().setHeight(200.0),
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color.fromARGB(255, 28, 28, 28)
              ),
              child: InkWell(
                onTap: ()async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('base', '');
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => HomePage()));
                },
                child: Center(
                  child: Text(
                    'Выйти из аккаунта',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
