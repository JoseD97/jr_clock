import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier{
  bool _isLoading = false;
  bool _reloadStreamBuilder = false;

  bool get isLoading{
    return this._isLoading;
  }
  set isLoading (bool value){
    this._isLoading = value;
    notifyListeners();
  }


  bool get reloadStreamBuilder{
    return this._reloadStreamBuilder;
  }
  set reloadStreamBuilder (bool value){
    this._reloadStreamBuilder = value;
    notifyListeners();
  }

}