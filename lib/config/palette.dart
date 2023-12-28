import 'package:flutter/material.dart';

// Color palette for the unthemed pages
class Palette{
  static Color primaryColor = Colors.white;
  static Color accentColor =  const Color(0xff4fc3f7);
  static Color secondaryColor = Colors.black;

  static Color gradientStartColor = accentColor;
  static Color gradientEndColor = const Color(0xff6aa8fd);
  static Color errorGradientStartColor = const Color(0xffd50000);
  static Color errorGradientEndColor = const Color(0xff9b0000);


  static Color primaryTextColorLight = Colors.white;
  static Color secondaryTextColorLight = Colors.white70;
  static Color hintTextColorLight = Colors.white70;


  static Color selfMessageBackgroundColor = const Color(0xff4fc3f7);
  static Color otherMessageBackgroundColor = const Color.fromARGB(255, 160, 163, 165);

  static Color selfMessageColor = Colors.white;
  static Color otherMessageColor = const Color(0xff3f3f3f);

  static Color greyColor = Colors.grey;
}