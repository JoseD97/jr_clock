import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jr_clock/services/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';

class ClockInFirestore{

  static int _cont = 1;

  static int get cont{
    return _cont;
  }

  // Graba la entrada al trabajo
  static Future enterWork(BuildContext context) async {
    final now = DateTime.now();
    final day = now.day;
    final month = now.month;
    final time = DateFormat('kk:mm').format(now).toString();


    print(Preferences.lastDayWorked);
    print(day);
    if (Preferences.lastDayWorked != day){ // Resetea el contador cada nuevo dia
      _cont = 1;
      Preferences.isWorking = false;
    }
    final doc = '${now.month}-${now.day}-$_cont';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Preferences.isWorking = !Preferences.isWorking; // Change his/her work's state
    // Create the new collection for the new user
    final clockIn = FirebaseFirestore.instance.collection(Preferences.email).doc(doc);
    final json = <String, dynamic>{
      "day": day,
      "month": month,
      "hourIn": time,
      "hourOut": '-',
      "locationIn": authProvider.loginLocation,
      "locationOut": '-',
      'isWorking': Preferences.isWorking,
    };
    //Create document and write
    await clockIn.set(json);
  }

  // Graba la salida del trabajo
  static Future leaveWork(BuildContext context) async{
    final now = DateTime.now();
    final day = now.day;
    final doc = '${now.month}-${now.day}-$_cont';
    final time = DateFormat('kk:mm').format(now).toString();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Preferences.isWorking = !Preferences.isWorking; // Change his/her work's state

    // Create the new collection for the new user
    final clockIn = FirebaseFirestore.instance.collection(Preferences.email).doc(doc);
    final json = <String, dynamic>{
      "hourOut": time,
      "locationOut": authProvider.loginLocation,
      'isWorking': Preferences.isWorking,
    };
    // Update the document
    await clockIn.update(json);
    print('grabado firebase');
    _cont++;
    Preferences.lastDayWorked = day;
  }
}