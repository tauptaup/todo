import 'package:flutter/material.dart';

import 'app_colors.dart';

class MyThemes {
  static final lighTheme = ThemeData(
    primarySwatch: AppColors.mainBlue,
    canvasColor: AppColors.mainCanvas,
  );
  static final darkTheme = ThemeData(
    canvasColor: Color(0xFFE5E5E5),
    accentColor: Color(0xFF252528),
    primaryColor: Color(0xFF161618),
  );
}
