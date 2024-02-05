import 'package:flutter/material.dart';

const Color otherColors = Colors.black;
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  hintColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.white,
  dividerColor: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
  ),
);