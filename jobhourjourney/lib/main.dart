import 'package:flutter/material.dart';
import 'package:jobhourjourney/Screens/home_page.dart';
import 'package:jobhourjourney/Themes/dark_mode.dart';
import 'package:jobhourjourney/Themes/light_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  const Homepage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
