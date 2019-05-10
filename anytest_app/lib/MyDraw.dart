import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class DrawLine extends CustomPainter {
  Orientation orientation;

  DrawLine(this.orientation);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.save();
    Rect tmpRect = Offset.zero & size;

    List<Offset> listPt = <Offset>[];
    listPt.add(Offset(tmpRect.left, tmpRect.top));
    listPt.add(Offset(100, 100));
    listPt.add(Offset(120, 100));
    listPt.add(Offset(100, 150));
    listPt.add(Offset(125, 130));
    listPt.add(Offset(tmpRect.right, 200));
    listPt.add(Offset(tmpRect.right, tmpRect.bottom - 20));

    final linePaint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 1.0;

    for (int i = 1; i < listPt.length; i++) {
      canvas.drawLine(listPt[i - 1], listPt[i], linePaint);
    }

    TextSpan span = new TextSpan(
      style: new TextStyle(color: Colors.green, fontSize: 24.0),
      text: "DrawLine",
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();

    double dbLeft = (tmpRect.width - tp.width) / 2;

    tp.paint(canvas, new Offset(dbLeft, tmpRect.bottom - tp.height));

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class DemoPainter extends CustomPainter {
  final double _arcStart;
  final double _arcSweep;

  DemoPainter(this._arcStart, this._arcSweep);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    double side = math.min(size.width, size.height);
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    Rect tmpCircleRect = Offset.zero & Size(side, side);
    Rect tmpRect = Offset.zero & size;

    tmpCircleRect = tmpCircleRect.deflate(4.0);
    double dbShift = (tmpRect.height - tmpCircleRect.height) / 2;
    tmpCircleRect = tmpCircleRect.shift(Offset(0, dbShift));
    canvas.drawArc(tmpCircleRect, _arcStart, _arcSweep, false, paint);

    TextSpan span = new TextSpan(
      style: new TextStyle(color: Colors.red, fontSize: 15.0),
      text: "DrawAnimation",
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();

    double dbLeft = (tmpRect.width - tp.width) / 2;
    tp.paint(canvas, new Offset(dbLeft, tmpRect.bottom - tp.height));

    canvas.restore();
  }

  @override
  bool shouldRepaint(DemoPainter other) {
    return _arcStart != other._arcStart || _arcSweep != other._arcSweep;
  }
}

class DemoWidget extends StatefulWidget {
  @override
  _DemoWidgetState createState() => _DemoWidgetState();
}

class _DemoWidgetState extends State<DemoWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: DemoPainter(
              Tween(begin: math.pi * 1.5, end: math.pi * 3.5)
                  .chain(CurveTween(curve: Interval(0.5, 1.0)))
                  .evaluate(_controller),
              math.sin(Tween(begin: 0.0, end: math.pi).evaluate(_controller)) *
                  math.pi,
            ),
          );
        });
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'CAR', icon: Icons.directions_car),
  const Choice(title: 'BICYCLE', icon: Icons.directions_bike),
  const Choice(title: 'MOTOBIKE', icon: Icons.motorcycle),
  const Choice(title: 'BOAT', icon: Icons.directions_boat),
  const Choice(title: 'BUS', icon: Icons.directions_bus),
  const Choice(title: 'TRAIN', icon: Icons.directions_railway),
  const Choice(title: 'WALK', icon: Icons.directions_walk),
];

class BarBottom extends StatefulWidget {
  @override
  _AppBarBottomSampleState createState() => new _AppBarBottomSampleState();
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;

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
                  child: new Text("OK"),
                ),
              ],
            );
          });
    }

    return new FlatButton(
      onPressed: () => _showDialog(choice.title),
      child: new Card(
        color: Colors.white,
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Icon(choice.icon, size: 128.0, color: textStyle.color),
              new Text(choice.title, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}

const timeout = const Duration(seconds: 3);

class _AppBarBottomSampleState extends State<BarBottom>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Timer _timer;
  Widget pObj;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: choices.length, vsync: this);
    _timer = Timer.periodic(timeout, _handleTimeout);
  }

  @override
  void dispose() {
    _timer.cancel();
    _tabController.dispose();
    super.dispose();
  }

  _handleTimeout(Timer timer) {
    int _index = _tabController.index;
    _index++;
    _tabController.animateTo(
      _index % (choices.length), //跳转到的位置
      duration: Duration(milliseconds: 16), //跳转的间隔时间
      curve: Curves.fastOutSlowIn, //跳转动画
    );
    _tabController.animateTo(_index % (choices.length));
  }

  Widget createTabView() {
    pObj = new TabBarView(
      controller: _tabController,
      children: choices.map((Choice choice) {
        return new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new ChoiceCard(choice: choice),
        );
      }).toList(),
    );
    return pObj;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      children: <Widget>[
        Expanded(
          child: createTabView(),
          flex: 20,
        ),
        Expanded(
          child: new PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: new Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: new Container(
                height: 48.0,
                alignment: Alignment.center,
                child: new TabPageSelector(controller: _tabController),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
