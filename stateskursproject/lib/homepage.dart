import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stateskursproject/adminpage.dart';

import 'package:stateskursproject/animalpage.dart';
import 'package:stateskursproject/articleMenu.dart';
import 'package:stateskursproject/peoplepage.dart';
import 'package:stateskursproject/sciencepage.dart';
import 'package:stateskursproject/singin.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String base64;

  void _shared() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    base64 = (prefs.getString('base') ?? null);
    if(base64!= null && base64 != "")
      setState(() {
        isAdmin = true;
      });
  }

  @override
  void initState() {
    _shared();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true,
            badge: true,
            alert: true,
            provisional: true
        )
    );

    super.initState();
  }

  bool isAdmin = false;

  Widget _appBarChanger(){
    if(isAdmin == false){
      return IconButton(
        icon: Icon(Icons.vpn_key),
        onPressed: () async {
          final returnedResult = await Navigator.push(context, MaterialPageRoute(
              builder: (context) => Login()));
          if(returnedResult == true)
            setState(() {
              isAdmin = true;
            });
        },
      );
    } else{
      return IconButton(
        icon: Icon(Icons.create),
        onPressed: () async {
          final returnedResult = await Navigator.push(context, MaterialPageRoute(
              builder: (context) => AdminPage(base64)));
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Разделы',
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        actions: <Widget>[
          _appBarChanger(),
        ],
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
      ),
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setWidth(30.0),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(75.0)),
            child: Row(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(450.0),
                  width: ScreenUtil().setWidth(450.0),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 28, 28, 28),
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: InkWell(
                    onTap: () {
                      _goToSciencePage();
                    },
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 50.0),
                        ),
                        Image(
                          image: AssetImage('assets/science.png'),
                          height: 50.0,
                          width: 50.0,
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                child: Center(
                                  child: Text(
                                    "Наука",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                )
                            )
                          ],
                        )
                      ],
                    ),

                  ),
                ),
                SizedBox(
                    width: 10.0
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(450.0),
                      width: ScreenUtil().setWidth(450.0),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 28, 28, 28),
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: InkWell(
                        onTap: () {
                          _goToAnimalPage();
                        },
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 50.0),
                            ),
                            Image(
                              image: AssetImage('assets/animal.png'),
                              height: 50.0,
                              width: 50.0,
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                    child: Center(
                                      child: Text(
                                        "Животные",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    )

                                )
                              ],
                            )
                          ],
                        ),

                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(30.0),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(75.0)),
            child: Row(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(450.0),
                  width: ScreenUtil().setWidth(450.0),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 28, 28, 28),
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: InkWell(
                    onTap: () {
                      _goToPeoplePage();
                    },
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 50.0),
                        ),
                        Image(
                          image: AssetImage('assets/people.png'),
                          height: 50.0,
                          width: 50.0,
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                child: Center(
                                  child: Text(
                                    "Люди",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                )

                            )
                          ],
                        )
                      ],
                    ),

                  ),
                ),
                SizedBox(
                    width: 10.0
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(450.0),
                      width: ScreenUtil().setWidth(450.0),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 28, 28, 28),
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: InkWell(
                        onTap: () {
                          _goToArticleMenu('Динозавры',
                              'http://192.168.1.11/API/Dinoes'); //('', 'http"//localhost8080/Dinoes/');
                        },
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 50.0),
                            ),
                            Image(
                              image: AssetImage('assets/dino.png'),
                              height: 50.0,
                              width: 50.0,
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                    child: Center(
                                      child: Text(
                                        "Динозавры",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    )

                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(30.0),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(75.0)),
            child: Row(
              children: <Widget>[
                Container(
                    height: ScreenUtil().setHeight(450.0),
                    width: ScreenUtil().setWidth(450.0),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 28, 28, 28),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: InkWell(
                      onTap: () {
                        _goToArticleMenu('Космос', '');
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 50.0),
                          ),
                          Image(
                            image: AssetImage('assets/space.png'),
                            height: 50.0,
                            width: 50.0,
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  child: Center(
                                    child: Text(
                                      "Космос",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  )

                              )
                            ],
                          )
                        ],
                      ),
                    )
                ),
                SizedBox(
                    width: 10.0
                ),
                Column(
                  children: <Widget>[
                    Container(
                        height: ScreenUtil().setHeight(450.0),
                        width: ScreenUtil().setWidth(450.0),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 28, 28, 28),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: InkWell(
                          onTap: () {
                            _goToArticleMenu('Игры', '');
                          },
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 50.0),
                              ),
                              Image(
                                image: AssetImage('assets/games.png'),
                                height: 50.0,
                                width: 50.0,
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      child: Center(
                                        child: Text(
                                          "Игры",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      )

                                  )
                                ],
                              )
                            ],
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(30.0),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(75.0)),
            child: Row(
              children: <Widget>[
                Container(
                    height: ScreenUtil().setHeight(450.0),
                    width: ScreenUtil().setWidth(450.0),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 28, 28, 28),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: InkWell(
                      onTap: () {
                        _goToArticleMenu('Технологии', '');
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 50.0),
                          ),
                          Image(
                            image: AssetImage('assets/tech.png'),
                            height: 50.0,
                            width: 50.0,
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  child: Center(
                                    child: Text(
                                      "Технологии",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  )

                              )
                            ],
                          )
                        ],
                      ),
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _goToAnimalPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AnimalPage()),
    );
  }

  void _goToPeoplePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PeoplePage()),
    );
  }

  void _goToSciencePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SciencePage()),
    );
  }

  void _goToArticleMenu(String title, String urlP) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ArticleMenu(title, urlP)),
    );
  }

}




