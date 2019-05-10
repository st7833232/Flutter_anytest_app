import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyiOSView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyiOSView();
  }
}

class _MyiOSView extends State<MyiOSView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text("Menu"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),
            title: Text("Account"),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.black,
            middle: Text(
              "iOS Style View",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          child: SafeArea(
            child: Center(
              child: CupertinoButton(
                child: Text(
                  "Click me",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => print("Hit"),
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
