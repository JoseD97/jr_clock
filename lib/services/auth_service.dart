import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


//Registro en firebase
class AuthService extends ChangeNotifier{

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = '';

  final storage = new FlutterSecureStorage(); // grabar en la memoria segura del telefono

  //Si retorna algo es un error, sino todo bien
  Future<String?> createUser(String email, String password) async{
    // para enviar un post hay que enviarlo como un mapa y luego lo serilizamos
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp',{
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData)); // realizamos la peticion http y nos devolvera una respuesta
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if(decodedResp.containsKey('idToken')){ // si hay error durante el registro no devuelve el idtoken
      await storage.write(key: 'token', value: decodedResp['idToken']);

      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }


  Future<String?> login(String email, String password) async{

    // para enviar un post hay que enviarlo como un mapa y luego lo serilizamos
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword',{
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData)); // realizamos la peticion http, codificamos nuestra data en json y nos devolvera una respuesta
    final Map<String, dynamic> decodedResp = json.decode(resp.body); // la restpuesta la decodificamos y nos resulta un mapa
    if(decodedResp.containsKey('idToken')){ // si hay error durante el registro no devuelve el idtoken
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }


  Future logOut() async{
    await storage.delete(key: 'token');
    return null;
  }
}




