import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jr_clock/services/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';

class ClockInFirestore{

  // static int _cont = 1;  // TODO PARA LLEVAR LA CUENTA DE VARIOS REGISTROS -> STREAM BUILDER CON LISTVIEW DE CARTAS CUADRADAS QUE MUESTRAN
  //                        // TODO LOS DIFERENTES FICHAJES EN UN MISMO DIA -> ESTO ME SIRVE PARA EL HISTORIAL
  //
  // static int get cont{
  //   return _cont;
  // }

  // Create new document for each day
  static Future createDocument() async{
    final now = DateTime.now();
    final doc = '${now.month}-${now.day}';
    final day = now.day;
    final month = now.month;

    //_cont = 1; // reset contador

    final clockIn = FirebaseFirestore.instance.collection(Preferences.email).doc(doc);
    final json = <String, dynamic>{
      "day": day,
      "month": month,
      "hourIn": '-',
      "locationIn": '-',
      "locationOut": '-',
      'isWorking': '',
    };
    //Create document and write
    await clockIn.set(json);
    print('grabado firebase');
  }


  // Enter work
  static Future enterWork(BuildContext context) async{
    final now = DateTime.now();
    final doc = '${now.month}-${now.day}';
    final time = DateFormat('kk:mm').format(now).toString();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Preferences.isWorking = !Preferences.isWorking; // Change his/her work's state
    // Create the new collection for the new user
    final clockIn = FirebaseFirestore.instance.collection(Preferences.email).doc(doc);
    final json = <String, dynamic>{
      //"hourIn${_cont}": time, hola
      "hourIn": time,
      "houtOut": '',
      "locationIn": authProvider.loginLocation,
      'isWorking': Preferences.isWorking,
    };
    //Create document and write
    await clockIn.update(json);
    //_cont++;
  }

  // Leave work
  static Future leaveWork(BuildContext context) async{
    final now = DateTime.now();
    final doc = '${now.month}-${now.day}';
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
  }
}