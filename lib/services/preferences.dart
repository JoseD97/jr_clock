import 'package:shared_preferences/shared_preferences.dart';


class Preferences{
  static late SharedPreferences _prefs;

  static String _email = '';
  static String _fotoId = '';

  static Future initPreferences() async{
    _prefs = await SharedPreferences.getInstance();
  }

  // Email
  static String get email{
    return _prefs.getString('email') ?? _email;
  }
  static set email(String email){
    _email = email;
    _prefs.setString('email', _email);
    fotoId = email; //Set the foto id with the first part of the email to be unique
  }


  // FotoId
  static String get fotoId{
    return _prefs.getString('fotoId') ?? _fotoId;
  }
  static set fotoId(String email){
    final id = email.split('@');
    _fotoId = id[0].trim();
    _prefs.setString('fotoId', _fotoId);

  }


}