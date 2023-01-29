import 'package:flutter/material.dart';

class AuthClockIn extends ChangeNotifier{
  bool _isLoading = false;


  bool get isLoading{
    return this._isLoading;
  }

  set isLoading (bool value){
    this._isLoading = value;
    notifyListeners();
  }
}