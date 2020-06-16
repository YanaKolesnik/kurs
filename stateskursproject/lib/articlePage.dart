import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ArticlePage extends StatefulWidget {

String urlP;
double rating;

ArticlePage(this.urlP, this.rating);

  @override
  _ArticlePageState createState() => _ArticlePageState(urlP, rating);
}

class _ArticlePageState extends State<ArticlePage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _ArticlePageState(String urlP, double rating) {
    this.urlP = urlP;
    this.rating = rating;
  }

  String title = '';

  String urlP;
  double rating;
  double newRating;

  String imageLink;
  String text = '';
  int id;
  bool ignore = false;

  Future _getData() async {
    http.get(urlP)
        .then((response) async {
      id = json.decode(response.body)['ID'];
      title = json.decode(response.body)['Name'];
      imageLink = json.decode(response.body)['Link_Image'];
      print(imageLink);
      text = json.decode(response.body)['Link_Text'];
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

  void _sendRating() async{
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var d = {
        "ID": id,
        "Name_article": title,
        "Rating": newRating,
        "Count": 0
      };
      var toJson = json.encode(d);
      http.put(urlP,
          headers: {
            "Authorization": "Basic $base64",
            "Content-Type": "application/json"
          },
          body: toJson)
          .timeout(Duration(seconds: 15))
          .then((response) async {
        if (response.statusCode == HttpStatus.ok) {
          ignore = true;
          setState(() { });
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
      var snackbar = SnackBar(
        backgroundColor: Colors.black54,
        content: Text('Проверьте подключение',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
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
        body: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(220.0), ScreenUtil().setWidth(30.0),
                    ScreenUtil().setWidth(220.0), ScreenUtil().setWidth(30.0)),
                height: ScreenUtil().setHeight(470.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: imageLink != null ? Image.network(
                  imageLink.toString(),
                  fit: BoxFit.fitHeight,
                ) : Container()
            ),
            Container(
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Center(
              child: Text(
                'Оцените статью:',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17.0
                ),
              ),
            ),
            Center(
              child: RatingBar(
                ignoreGestures: ignore,
                initialRating: rating == null ? 0.0 : rating.toDouble(),
                itemCount: 5,
                // ignore: missing_return
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                  }
                },
                onRatingUpdate: (i) {
                  newRating = i;
                },
              ),
            ),

            Center(
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
                      if(ignore == false)
                      _sendRating();
                    },
                    child: Center(
                      child: Text(
                        'Отправить',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(66.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}