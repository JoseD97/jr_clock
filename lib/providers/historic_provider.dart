import 'package:flutter/material.dart';

class HistoricProvider extends ChangeNotifier{
  bool _isSearching = false;
  bool _showData = false;

  int month = 1;
  int year = 2023;

  bool get isSearching{
    return this._isSearching;
  }
  set isSearching (bool value){
    this._isSearching = value;
    notifyListeners();
  }


  bool get showData{
    return this._showData;
  }
  set showData (bool value){
    this._showData = value;
    notifyListeners();
  }
}