import 'package:flutter/material.dart';
import 'package:nfc_trigger/mode.dart';
import 'package:nfc_trigger/service.dart';
import 'package:nfc_trigger/widgets/read.dart';
import 'package:nfc_trigger/widgets/write.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  bool _status;
  Mode _mode;
  AnimationController _controller;
  Animation _scale;

  @override
  void initState() {
    super.initState();
    _status = false;
    _mode = Mode.read;
    _controller = AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this
    );
    _scale = Tween<double>(begin: 1, end: 1.25).animate(_controller);

    _controller.addStatusListener((animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        _controller.reverse();
      } else if (animationStatus == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  void _switchStatus() {
    setState(() {
      _status = !_status;
      Service.instance.status.add(_status);
      _status ? _controller.forward() : _controller.stop();
    });
  }

  void _switchMode(Mode mode) {
    setState(() {
      _mode = mode;
      _status = false;
      Service.instance.status.add(_status);
      _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC - ${_mode == Mode.read ? '读取' : '写入'}'),
      ),
      body: _mode == Mode.read ? Read() : Write(),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchStatus,
        tooltip: 'NFC',
        child: AnimatedBuilder(
          animation: _controller,
          child: Icon(Icons.nfc),
          builder: (BuildContext context, Widget child) {
            return Transform.scale(
              scale: _scale.value,
              child: child
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 64.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.vibration,
                  color: _mode == Mode.read ? Colors.blue : Colors.blueGrey,
                ),
                onPressed: () => _switchMode(Mode.read),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings_cell,
                  color: _mode == Mode.write ? Colors.blue : Colors.black38,
                ),
                onPressed: () => _switchMode(Mode.write),
              )
            ],
          ),
        ),
      )
    );
  }
}
