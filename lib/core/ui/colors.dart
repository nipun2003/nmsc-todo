


import 'package:flutter/material.dart';

class AppColor {

  static const _primaryColor = 0xFF9E77ED;
  
    static const MaterialColor primaryColor = MaterialColor(_primaryColor, <int,Color>{
      50: Color(0xFFFCFAFF),
      100: Color(0xFFF9F5FF),
      200: Color(0xFFE9D7FE),
      300: Color(0xFFD6BBFB),
      400: Color(0xFFB692F6),
      500: Color(_primaryColor),
      600: Color(0xFF7F56D9),
      700: Color(0xFF6941C6),
      800: Color(0xFF53389E),
      900: Color(0xFF42307D),
    });

}