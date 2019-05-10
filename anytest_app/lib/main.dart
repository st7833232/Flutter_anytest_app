import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flustars/flustars.dart';
import 'MyDrawer.dart';
import 'MyDraw.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

final int statusCodeOK = 200;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter GridView',
      home: new Home(),
      theme: new ThemeData(primaryColor: Colors.blue),
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<Post> fetchPost() async {
  final response = await http.get(
    "https://jsonplaceholder.typicode.com/posts/1",
    headers: {HttpHeaders.authorizationHeader: "Basic api token"},
  );

  if (response.statusCode == statusCodeOK) {
    return Post.fromJson(convert.json.decode(response.body));
  } else {
    throw Exception("Fail to load the post, try again later");
  }
}

class Post {
  final int userID;
  final int id;
  final String title;
  final String body;

  Post({
    this.userID,
    this.id,
    this.title,
    this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userID: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

enum Country { Taiwan, USA, Japan }

class _HomeState extends State<Home> {
  static const platform =
      const MethodChannel("com.example.anytest_app/anytest_app");
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Future<Post> post = fetchPost();

  void openBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.alarm),
                title: Text("Alarm"),
                onTap: () {
                  print("Open Alarm");
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text("Map"),
                onTap: () {
                  print("Open Map");
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openDialog() async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Select Something"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Country.Taiwan);
              },
              child: Text("Taiwan"),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Country.USA);
              },
              child: Text("USA"),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Country.Japan);
              },
              child: Text("Japan"),
            ),
          ],
        );
      },
    )) {
      case Country.Taiwan:
        print("Taiwan");
        break;
      case Country.USA:
        print("USA");
        break;
      case Country.Japan:
        print("Japan");
        break;
    }
  }

  void showMessage(String strMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("ButtomTest"),
            content: new Text(strMessage),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("Close"),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("OK"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        showMessage('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        showMessage('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        showMessage('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);
    Orientation orientation = ScreenUtil.getOrientation(context);

    var spacecrafts = [
      "Lake",
      "Enterprise",
      "Hubble",
      "Kepler",
      "Juno",
      "Casini",
      "Columbia",
      "Challenger",
      "Huygens",
      "Galileo",
      "Apollo",
      "Spitzer",
      "WMAP",
      "Swift",
      "Atlantis",
      "Jeff"
    ];

    void _showDialog(String strName) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("ButtomTest"),
              content: new Text(strName),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Close"),
                ),
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("OK"),
                ),
              ],
            );
          });
    }

    _launchTellURL() async {
      const url = "tel://<(+886)0934342932>";

      if (await canLaunch(url)) {
        await launch(url);
      } else
        throw 'Could not launch $url';
    }

    _launchMessageURL() async {
      const url = "sms:<8860934342932>";

      if (await canLaunch(url)) {
        await launch(url);
      } else
        throw 'Could not launch $url';
    }

    _lauchWebURL() async {
      const url =
          "https://www.google.com/search?client=firefox-b&source=hp&ei=vP9HXN-POsT08AX2hqqIAg&q=lake&btnK=Google+%E6%90%9C%E5%B0%8B&oq=lake&gs_l=psy-ab.3..35i39j0i131l2j0j0i131j0j0i131j0l3.1686.2517..2732...0.0..0.347.1041.2j0j2j1......0....1..gws-wiz.....0.vc_WSEI8fVU";

      if (await canLaunch(url)) {
        await launch(url);
      } else
        throw 'Could not launch $url';
    }

    void _testJavaCode() async {
      String val = "";

      try {
        val = await platform.invokeMethod(
          "TestCode",
          <String, dynamic>{
            'name': 'Java Code Test',
          },
        );
      } catch (e) {
        print(e);
      }

      if (val.isNotEmpty) _showDialog(val);
    }

    Widget _randomObj(int index) {
      Widget pObj;

      switch (index) {
        case 0:
          pObj = new FlatButton(
              onPressed: () => _showDialog(spacecrafts[index]),
              child: new Column(
                children: <Widget>[
                  Expanded(
                    child: new Image(
                      image: new AssetImage('assets/images/lake.jpg'),
                    ),
                    flex: 4,
                  ),
                  Expanded(
                    child: new Text(
                      'This is a lake.jpg',
                      style: new TextStyle(
                          fontSize: 24.0, color: Colors.lightBlue),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                      child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new IconButton(
                            icon: new Icon(Icons.message),
                            onPressed: () => _launchMessageURL()),
                      ),
                      Expanded(
                        child: new IconButton(
                            icon: new Icon(Icons.insert_link),
                            onPressed: () => _lauchWebURL()),
                      ),
                      Expanded(
                        child: new IconButton(
                            icon: new Icon(Icons.phone),
                            onPressed: () => _launchTellURL()),
                      ),
                    ],
                  ))
                ],
              ));
          break;
        case 1:
          pObj = new FlatButton(
              onPressed: () => openDialog(),
              child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.pink,
                  radius: 240.0,
                  child: new Text(
                    spacecrafts[index],
                    style:
                        new TextStyle(color: Colors.lightBlue, fontSize: 22.0),
                  )));
          break;
        case 2:
          pObj = new CustomPaint(
            painter: DrawLine(orientation),
          );
          break;
        case 3:
          pObj = new DemoWidget();
          break;
        case 4:
          pObj = new BarBottom();
          break;
        case 5:
          pObj = Center(
            child: RaisedButton(
              onPressed: () => _testJavaCode(),
              child: Text("Test Java Code"),
            ),
          );
          break;
        case 6:
          pObj = Center(
            child: FutureBuilder<Post>(
              future: post,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.title);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.hasError}");
                }

                return CircularProgressIndicator();
              },
            ),
          );
          break;
      }

      return pObj;
    }

    Container _getContainer(int index) {
      Color crTmp = Colors.white;
      switch (index) {
        case 0:
          crTmp = Colors.red;
          break;
        case 1:
          crTmp = Colors.orange;
          break;
        case 2:
          crTmp = Colors.yellow;
          break;
        case 3:
          crTmp = Colors.green;
          break;
        case 4:
          crTmp = Colors.blue;
          break;
        case 5:
          crTmp = Colors.purple;
          break;
        case 6:
          crTmp = Colors.grey;
          break;
      }
      return new Container(
        color: crTmp,
        child: _randomObj(index),
      );
    }

    StaggeredTile _getPosition(int index) {
      int nTmp = 1;
      if (index % 4 == 0)
        nTmp = 3;
      else if (5 == index || 6 == index) nTmp = 3;
      return new StaggeredTile.count(nTmp, index % 4 == 0 ? 3 : 2);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter GridView"),
      ),
      drawer: MyDrawer(),
      body: Center(
          child: new StaggeredGridView.countBuilder(
        crossAxisCount: 3,
        itemCount: 7 /*spacecrafts.length*/,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        itemBuilder: (BuildContext context, int index) => _getContainer(index),
        staggeredTileBuilder: (int index) => _getPosition(index),
      )),
    );
  }
}
