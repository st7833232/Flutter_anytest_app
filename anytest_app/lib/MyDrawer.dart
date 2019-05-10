import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'MyWebView.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'MyNotification.dart';
import 'MyTabView.dart';
import 'MySlidable.dart';
import 'MyExpansionPanelListView.dart';
import 'MyiOSView.dart';
import 'ParseJsonView.dart';
import 'MyFileTest.dart';

class MyDrawer extends Drawer {
  _launchSystex() async {
    const url = "https://goo.gl/maps/g7yJD1VAjaR2";

    if (await canLaunch(url)) {
      await launch(url);
    } else
      throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          MyHeader(),
          ListTile(
            title: Text('WebView'),
            leading: new CircleAvatar(
              child: new Icon(Icons.web),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new Home()),
              );
            },
          ),
          ListTile(
            title: Text('出發到精誠'),
            leading: new CircleAvatar(
              child: new Icon(Icons.map),
            ),
            onTap: () {
              Navigator.pop(context);
              _launchSystex();
            },
          ),
          ListTile(
            title: Text('推播通知'),
            leading: new CircleAvatar(
              child: new Icon(Icons.cast),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MyNotification()),
              );
            },
          ),
          ListTile(
            title: Text("TabView"),
            leading: CircleAvatar(
              child: Icon(Icons.table_chart),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new MyTabView()),
              );
            },
          ),
          ListTile(
            title: Text("清單"),
            leading: CircleAvatar(
              child: Icon(Icons.list),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new MySlidable()),
              );
            },
          ),
          ListTile(
            title: Text("目錄"),
            leading: CircleAvatar(
              child: Icon(Icons.view_headline),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MyExpanelListView()),
              );
            },
          ),
          ListTile(
            title: Text("iOS"),
            leading: CircleAvatar(
              child: Icon(Icons.apps),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new MyiOSView()),
              );
            },
          ),
          ListTile(
            title: Text("ParseJsonView"),
            leading: CircleAvatar(
              child: Icon(Icons.image),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ParseJsonView()),
              );
            },
          ),
          ListTile(
            title: Text("讀寫文件"),
            leading: CircleAvatar(
              child: Icon(Icons.insert_drive_file),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MyFileIO()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyHeader extends StatefulWidget {
  _MyHeader createState() => new _MyHeader();
}

class _MyHeader extends State<MyHeader> {
  static String strImagePath = '';
  static File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _image = image;
        strImagePath = image.path;
      }

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget userHeader = UserAccountsDrawerHeader(
        accountName: new Text('Tom'),
        accountEmail: new Text('tom@xxx.com'),
        currentAccountPicture: new FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            getImage();
          },
          child: new CircleAvatar(
            backgroundImage: _image == null
                ? AssetImage('assets/images/lake.jpg')
                : AssetImage(strImagePath),
            radius: 35.0,
          ),
        ));
    // TODO: implement build
    return userHeader;
  }
}
