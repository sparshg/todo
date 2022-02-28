import 'package:flutter/material.dart';

class Styles {
  static const _rounded = 28.0;
  static final grey = Colors.grey.shade800;
  static final black = Colors.grey.shade900;

  static const topListBorder = BorderRadius.vertical(
    top: Radius.circular(_rounded),
  );
  static const bottomListBorder = BorderRadius.vertical(
    bottom: Radius.circular(_rounded),
  );
  static const roundedListBorder = BorderRadius.all(Radius.circular(_rounded));

  static final themeData = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: black,
    colorScheme: ColorScheme.dark(primary: Colors.teal.shade400),
    fontFamily: 'Poppins',
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  );
}
