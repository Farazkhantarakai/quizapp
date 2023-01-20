import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class CheckInternetConnectivity {
  final Connectivity _connectivity = Connectivity();

  static final CheckInternetConnectivity _internetConnectivity =
      CheckInternetConnectivity().instance();
//this is returning a single instance now
  instance() {
    return _internetConnectivity;
  }
}
