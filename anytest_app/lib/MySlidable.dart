import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:share_extend/share_extend.dart';

class MySlidable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MySlidable();
  }
}

class _MySlidable extends State<MySlidable> {
  SlidableController slidableController;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final List<_HomeItem> items = List.generate(
    1,
    (i) => new _HomeItem(
          i,
          'Tile n°$i',
          _getSubtitle(i),
          _getAvatarColor(i),
        ),
  );

  @override
  void initState() {
    slidableController = new SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );

    super.initState();
  }

  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  Future _getImagePath(int index) async {
    File image;
    String strMessage;

    switch (index % 3) {
      case 0:
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
      case 1:
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case 2:
        image = null;
        break;
    }

    if (image != null) {
      ShareExtend.share(image.path, "image");
    } else if (index == 2) {
      strMessage = 'check out my website https://example.com';
      ShareExtend.share(strMessage, "text");
    }
  }

  void addList() {
    int index = 0;
    if (items.length <= 0) {
      index = 0;
    } else {
      index = items[items.length - 1].index + 1;
    }

    setState(() {
      items.add(new _HomeItem(
          index, 'Tile n°$index', _getSubtitle(index), _getAvatarColor(index)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('MySlidable'),
      ),
      body: new Center(
        child: new OrientationBuilder(
          builder: (context, orientation) => _buildList(
              context,
              orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _fabColor,
        onPressed: () => addList(),
        child: _rotationAnimation == null
            ? Icon(Icons.add)
            : RotationTransition(
                turns: _rotationAnimation,
                child: Icon(Icons.add),
              ),
      ),
    );
  }

  Widget _buildList(BuildContext context, Axis direction) {
    return new ListView.builder(
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection =
            direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        var item = items[index];
        if (item.index < 8) {
          return _getSlidableWithLists(context, index, slidableDirection);
        } else {
          return _getSlidableWithDelegates(context, index, slidableDirection);
        }
      },
      itemCount: items.length,
    );
  }

  Widget _buildVerticalListItem(BuildContext context, int index) {
    final _HomeItem item = items[index];
    return new Container(
      color: Colors.white,
      child: new ListTile(
        leading: new CircleAvatar(
          backgroundColor: item.color,
          child: new Text('${item.index}'),
          foregroundColor: Colors.white,
        ),
        title: new Text(item.title),
        subtitle: new Text(item.subtitle),
      ),
    );
  }

  Widget _buildhorizontalListItem(BuildContext context, int index) {
    final _HomeItem item = items[index];
    return new Container(
      color: Colors.white,
      width: 160.0,
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Expanded(
            child: new CircleAvatar(
              backgroundColor: item.color,
              child: new Text('${item.index}'),
              foregroundColor: Colors.white,
            ),
          ),
          new Expanded(
            child: Center(
              child: new Text(
                item.subtitle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSlidableWithLists(
      BuildContext context, int index, Axis direction) {
    final _HomeItem item = items[index];
    //final int t = index;
    return new Slidable(
      key: new Key(item.title),
      controller: slidableController,
      direction: direction,
      slideToDismissDelegate: new SlideToDismissDrawerDelegate(
        onDismissed: (actionType) {
          _showSnackBar(
              context,
              actionType == SlideActionType.primary
                  ? 'Dismiss Archive'
                  : 'Dimiss Delete');
          setState(() {
            items.removeAt(index);
          });
        },
      ),
      delegate: _getDelegate(item.index),
      actionExtentRatio: 0.25,
      child: direction == Axis.horizontal
          ? _buildVerticalListItem(context, index)
          : _buildhorizontalListItem(context, index),
      actions: <Widget>[
        new IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => _showSnackBar(context, 'Archive'),
        ),
        new IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () {
            _showSnackBar(context, 'Share');
            _shareType(index);
          },
        ),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _showSnackBar(context, 'Delete');
            items.removeAt(index);
          },
        ),
      ],
    );
  }

  Widget _getSlidableWithDelegates(
      BuildContext context, int index, Axis direction) {
    final _HomeItem item = items[index];

    return new Slidable.builder(
      key: new Key(item.title),
      controller: slidableController,
      direction: direction,
      slideToDismissDelegate: new SlideToDismissDrawerDelegate(
        closeOnCanceled: true,
        onWillDismiss: (item.index != 10)
            ? null
            : (actionType) {
                return showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return new AlertDialog(
                      title: new Text('Delete'),
                      content: new Text('Item will be deleted'),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        new FlatButton(
                          child: new Text('Ok'),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    );
                  },
                );
              },
        onDismissed: (actionType) {
          _showSnackBar(
              context,
              actionType == SlideActionType.primary
                  ? 'Dismiss Archive'
                  : 'Dimiss Delete');
          setState(() {
            items.removeAt(index);
          });
        },
      ),
      delegate: _getDelegate(item.index),
      actionExtentRatio: 0.25,
      child: direction == Axis.horizontal
          ? _buildVerticalListItem(context, index)
          : _buildhorizontalListItem(context, index),
      actionDelegate: new SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, renderingMode) {
            if (index == 0) {
              return new IconSlideAction(
                caption: 'Archive',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.blue.withOpacity(animation.value)
                    : (renderingMode == SlidableRenderingMode.dismiss
                        ? Colors.blue
                        : Colors.green),
                icon: Icons.archive,
                onTap: () async {
                  var state = Slidable.of(context);
                  var dismiss = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return new AlertDialog(
                        title: new Text('Delete'),
                        content: new Text('Item will be deleted'),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          new FlatButton(
                            child: new Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );

                  if (dismiss) {
                    state.dismiss();
                  }
                },
              );
            } else {
              return new IconSlideAction(
                caption: 'Share',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.indigo.withOpacity(animation.value)
                    : Colors.indigo,
                icon: Icons.share,
                onTap: () {
                  _showSnackBar(context, 'Share');
                  _shareType(index);
                },
              );
            }
          }),
      secondaryActionDelegate: new SlideActionBuilderDelegate(
          actionCount: 1,
          builder: (context, index, animation, renderingMode) {
            return new IconSlideAction(
              caption: 'Delete',
              color: renderingMode == SlidableRenderingMode.slide
                  ? Colors.red.withOpacity(animation.value)
                  : Colors.red,
              icon: Icons.delete,
              onTap: () {
                _showSnackBar(context, 'Delete');
                items.removeAt(index);
              },
            );
          }),
    );
  }

  static SlidableDelegate _getDelegate(int index) {
    switch (index % 4) {
      case 0:
        return new SlidableBehindDelegate();
      case 1:
        return new SlidableStrechDelegate();
      case 2:
        return new SlidableScrollDelegate();
      case 3:
        return new SlidableDrawerDelegate();
      default:
        return null;
    }
  }

  static Color _getAvatarColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.indigoAccent;
      default:
        return null;
    }
  }

  static String _getSubtitle(int index) {
    switch (index % 4) {
      case 0:
        return 'SlidableBehindDelegate';
      case 1:
        return 'SlidableStrechDelegate';
      case 2:
        return 'SlidableScrollDelegate';
      case 3:
        return 'SlidableDrawerDelegate';
      default:
        return null;
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
  }

  void _shareType(int index) {
    _getImagePath(index);
  }
}

class _HomeItem {
  const _HomeItem(
    this.index,
    this.title,
    this.subtitle,
    this.color,
  );

  final int index;
  final String title;
  final String subtitle;
  final Color color;
}
