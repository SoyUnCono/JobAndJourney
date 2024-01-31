import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF282c34),
    primary: Color(0xFF0B141A),
    secondary: Colors.blueAccent,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: const Color(0xFF6a6d74),
    fontFamily: 'Poppins',
    displayColor: Colors.white,
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF0B141A),  
    shadowColor: Color(0xFF060C10),  
  ),
);

