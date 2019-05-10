import 'package:flutter/material.dart';

class MyItem {
  MyItem({this.isExpanded: false, this.header, this.body});

  bool isExpanded;
  final String header;
  final String body;
}

class MyExpanelListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyExpanelListView();
  }
}

class _MyExpanelListView extends State<MyExpanelListView> {
  List<MyItem> _item = <MyItem>[
    MyItem(header: "Header 0", body: "Body 0"),
    MyItem(header: "Header 1", body: "Body 1"),
    MyItem(header: "Header 2", body: "Body 2"),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("MyExpanelListView"),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _item[index].isExpanded = !_item[index].isExpanded;
              });
            },
            children: _item.map((MyItem item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Text(item.header);
                },
                isExpanded: item.isExpanded,
                body: Container(
                  child: Text(
                    item.body,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
