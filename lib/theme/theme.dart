import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface:Colors.grey.shade500,
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade200,
    onPrimary: Colors.grey.shade700,

  
  )
);
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade700, 
    onPrimary: Colors.black
  )
);