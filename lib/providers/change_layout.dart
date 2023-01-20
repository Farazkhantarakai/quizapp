import 'package:flutter/cupertino.dart';

class ChangeLayout extends ChangeNotifier {
  bool isLoading = false;

  get getLoading => isLoading;

  void changeLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
