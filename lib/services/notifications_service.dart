import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>(); // Sirve para mantener la referencia del material app
    // en cualquier lado de la app tengo acceso al scaffold ya que es estatico y nos permite mostrar los snackbar en cualquier loguar

  static showSnackbar(String message){
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white, fontSize: 20)),
      );

    messengerKey.currentState!.showSnackBar(snackBar);
  }

}