import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFileIO extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyFileIO();
  }
}

class _MyFileIO extends State<MyFileIO> {
  int _counter = -1;

  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int count = -1;
      count = prefs.getInt("counter") + 1;
      _counter = count;
    });
    await prefs.setInt('counter', _counter);
  }

  void _initialCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int count = prefs.getInt("counter");
      if (null == count)
        count = -1;
      _counter = count;
    });
    await prefs.setInt('counter', _counter);
  }

  void _clearCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = -1;
    });
    await prefs.setInt('counter', _counter);
  }

  void _deleteCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = -1;
    });
    await prefs.remove('counter');
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialCounter();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("MyFileIOTest"),
      ),
      body: Center(
        widthFactor: 200.0,
        child: Column(
          children: <Widget>[
            Text('$_counter'),
            RaisedButton(
              onPressed: _incrementCounter,
              child: Text("Add counter"),
            ),
            RaisedButton(
              onPressed: _clearCounter,
              child: Text("Clear counter"),
            ),
            RaisedButton(
              onPressed: _deleteCounter,
              child: Text("Delete data"),
            ),
          ],
        ),
      ),
    );
  }
}
