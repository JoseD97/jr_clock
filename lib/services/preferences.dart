import 'package:shared_preferences/shared_preferences.dart';


class Preferences{
  static late SharedPreferences _prefs;

  static String _email = '';
  static String _fotoId = '';
  static bool _isWorking = false;
  static int _lastDayWorked = 0;

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
    fotoId = email; //Sets de foto id with the email to be unique
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

  // Last day worked
  static int get lastDayWorked{
    return _prefs.getInt('lastDayWorked') ?? _lastDayWorked;
  }
  static set lastDayWorked(int lastDayWorked){
    _lastDayWorked = lastDayWorked;
    _prefs.setInt('lastDayWorked', _lastDayWorked);
  }


  // Is working
  static bool get isWorking{
    return _prefs.getBool('isWorking') ?? _isWorking;
  }
  static set isWorking(bool isWorking){
    _isWorking = isWorking;
    _prefs.setBool('isWorking', _isWorking);
  }

}