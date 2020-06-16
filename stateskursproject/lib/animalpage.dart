import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'articleMenu.dart';

class AnimalPage extends StatefulWidget {
  @override
  _AnimalPageState createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Животные',
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
                        _goToArticleMenu('Рыбы', '');
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 50.0),
                          ),
                          Image(
                            image: AssetImage('assets/fish.png'),
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
                                      "Рыбы",
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
                            _goToArticleMenu('Птицы', '');
                          },
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 50.0),
                              ),
                              Image(
                                image: AssetImage('assets/birds.png'),
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
                                          "Птицы",
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
                        _goToArticleMenu('Насекомые', '');
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 50.0),
                          ),
                          Image(
                            image: AssetImage('assets/insect.png'),
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
                                      "Насекомые",
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
                            _goToArticleMenu('Звери', '');
                          },
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 50.0),
                              ),
                              Image(
                                image: AssetImage('assets/wild.png'),
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
                                          "Звери",
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
        ],
      ),
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
