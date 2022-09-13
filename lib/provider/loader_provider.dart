import 'package:flutter/cupertino.dart';

class LoaderProvider with ChangeNotifier{
  bool _isApiCallProgress = false;
  bool get isApiCallProgress => _isApiCallProgress;

  setLoafingStatus(bool status) {
    _isApiCallProgress = status;
    notifyListeners();
  }
}