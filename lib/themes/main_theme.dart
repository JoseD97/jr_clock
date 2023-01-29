import 'package:flutter/material.dart';

const color = Colors.black87; //TODO COMO HACER PARA TENER UN COLOR GLOBAL
final mainTheme = ThemeData.light().copyWith(

    primaryColor: color,

    appBarTheme: const AppBarTheme(
      color: color,
      elevation: 0,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: color,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: color,
    ),

    iconTheme: IconThemeData(
    color: color,
    ),
  /*
    bottomAppBarTheme: const BottomAppBarTheme(
      color: color,
    )
   */
);