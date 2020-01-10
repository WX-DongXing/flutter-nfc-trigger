import 'package:rxdart/rxdart.dart';

class Service {

  BehaviorSubject<bool> status = BehaviorSubject<bool>();

  static get instance => _getInstance();

  static Service _instance;

  static Service _getInstance() {
    if (_instance == null) {
      _instance = Service();
    }
    return _instance;
  }
}