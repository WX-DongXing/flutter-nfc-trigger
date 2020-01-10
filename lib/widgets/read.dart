import 'package:flutter/material.dart';
import 'package:nfc_trigger/service.dart';

class Read extends StatefulWidget {
  @override
  _ReadState createState() => _ReadState();
}

class _ReadState extends State<Read> {
  bool _status = false;
  bool _listenable = true;
  var stream;

  @override
  void initState() {
    super.initState();
    Service.instance.status
      .takeWhile((listenable) => listenable = _listenable)
      .listen((status) {
      _status = status;
    });
  }

  @override
  void dispose() {
    _listenable = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Text( _status ? 'read' : 'not read'),
    );
  }
}