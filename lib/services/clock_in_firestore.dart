import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:jr_clock/services/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';

class ClockInFirestore{

  static int _count = 1;

  static int get count{
    return _count;
  }

  static Future<String> getIDLastDocument() async{
    // Cojo los datos del ultimo fichaje para comprobar el contador y el dia
    final lastDoc = FirebaseFirestore.instance.collection(Preferences.email);
    lastDoc.orderBy("timeStamp", descending: true).limit(1);
    return await lastDoc.get().then(
            (documentSnapshots) async { //TODO COMPROBAR SI EXISTE DOCUMENTOS -> CASO EN EL QUE SEA UN USUARIO NUEVO
          final lastDoc = documentSnapshots.docs[documentSnapshots.size - 1];
          if(lastDoc.exists){
            Map<String, dynamic> data = lastDoc.data()!;
            print('tras getnamelast');
            print('lastDoc' + lastDoc.id);
            print('/tras getnamelast');
            return await lastDoc.id;
          }
          else {
            print('tras getnamelast');
            print('no existe');
            print('/tras getnamelast');
            return await '';
          }
        },
        onError: (e) {
          print("Error completing: $e");
          return 'error';
        }
    );
  }

  static Future<Map<String, dynamic>> getDataLastDocument() async{
    // Cojo los datos del ultimo fichaje para comprobar el contador y el dia
    final lastDoc = FirebaseFirestore.instance.collection(Preferences.email);
    lastDoc.orderBy("timeStamp", descending: true).limit(1);
    return await lastDoc.get().then(
          (documentSnapshots) { //TODO COMPROBAR SI EXISTE DOCUMENTOS -> CASO EN EL QUE SEA UN USUARIO NUEVO
            final lastDoc = documentSnapshots.docs[documentSnapshots.size - 1];
            if(lastDoc.exists){
              Map<String, dynamic> data = lastDoc.data()!;
              print('tras getdatalast');
              print('lastDoc' + lastDoc.id);
              print('existe');
              print('countttttttttt ' + data['countPerDay'].toString());
              print('iswoerking ' + data['isWorking'].toString());
              print('day ' + data['day'].toString());
              print('month ' + data['month'].toString());
              print('year ' + data['year'].toString());
              print('/tras getdatalast');
              return data;
            }
            else {
              print('tras getdatalast');
              print('no existe');
              print('/tras getdatalast');
              return {
              'countPerDay' : 1,
              'isWorking' : false
              };
            }
      },
      onError: (e) {
        print("Error completing: $e");
        return 'error';
      }
    );
  }

  // Graba la entrada al trabajo
  static Future enterWork(BuildContext context) async {
    final now = DateTime.now();
    final day = now.day;
    final month = now.month;
    final year = now.year;
    final time = DateFormat('kk:mm').format(now).toString();

    final data = await getDataLastDocument();
    if(data != 'error'){

      // Resetea el contador cada nuevo dia
      if (data['day'] != day){ //()last dfay worked
        _count = 1;
        //Preferences.isWorking = false;
      }
      // Si el fichaje es en el mismo dia, sumo uno al contandor de fichajes diarios
      else{
        _count = data['countPerDay'] + 1;
      }

      final doc = '$year-$month-$day-$_count';

      print('tras entrar');
      print('doc ' + doc);
      print('count ' + _count.toString());
      print('lastday ' + data[day].toString());
      print('/tras entrar');

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      //Preferences.isWorking = !Preferences.isWorking; // Change his/her work's state
      // Create the new collection for the new user
      final clockIn = FirebaseFirestore.instance.collection(Preferences.email).doc(doc);
      final json = <String, dynamic>{
        "day": day,
        "month": month,
        "year":year,
        "hourIn": time,
        "hourOut": '-',
        "locationIn": authProvider.loginLocation,
        "locationOut": '-',
        'isWorking': true,
        'countPerDay': _count,
        'timeStamp': now,
      };
      //Create document and write
      await clockIn.set(json);

    }
  }




  // Graba la salida del trabajo
  static Future leaveWork(BuildContext context) async{
    final now = DateTime.now();
    final data = await getDataLastDocument();
    _count = data['countPerDay'];
    final doc = '${now.year}-${now.month}-${now.day}-$_count';
    final time = DateFormat('kk:mm').format(now).toString();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //Preferences.isWorking = !Preferences.isWorking; // Change his/her work's state

    // Create the new collection for the new user
    final clockIn = FirebaseFirestore.instance.collection(Preferences.email).doc(doc);

    print('tras salir');
    print('doc ' + doc);
    print('count ' + _count.toString());
    print('/tras salir');

    final json = <String, dynamic>{
      "hourOut": time,
      "locationOut": authProvider.loginLocation,
      'isWorking': false,
    };
    // Update the document
    await clockIn.update(json);
    print('grabado firebase');
    //_count++;
    //Preferences.lastDayWorked = day;
  }

  static Future<String?> getImageUrl() async {
    final fotoId = await Preferences.fotoId;
    final ref = FirebaseStorage.instance.ref().child('$fotoId.jpg');
    final url = await ref.getDownloadURL();
    return url;
  }

}