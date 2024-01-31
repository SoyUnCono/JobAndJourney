import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        background: Colors.grey.shade50,
        primary: Colors.white,
        secondary: Colors.blueAccent,
        tertiary: Colors.lightBlue,
        inversePrimary: Colors.grey.shade800),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.grey[800],
          displayColor: Colors.black,
          fontFamily: 'Poppins',
        ),
    dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(color: Colors.black),
        contentTextStyle: TextStyle(color: Colors.black)));
