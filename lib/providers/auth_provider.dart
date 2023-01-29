import 'package:flutter/material.dart';

// Provider for the authenticacion with firebase
class AuthProvider extends ChangeNotifier{

  String name = '';
  String email = '';
  String password = '';
  String loginLocation = '';
  double loginLong = 0;
  double loginLat = 0;
  bool _isObscured = true;
  bool _isLoading = false;
  String _dropDownItem = 'Rol';

  bool get isObscured{
    return this._isObscured;
  }
  set isObscured (bool value){
    this._isObscured = value;
    notifyListeners();
  }


  bool get isLoading{
    return this._isLoading;
  }
  set isLoading (bool value){
    this._isLoading = value;
    notifyListeners();
  }


  String get dropDownItem{
    return this._dropDownItem;
  }
  set dropDownItem (String value){
    this._dropDownItem = value;
    notifyListeners();
  }



}