import 'package:flutter/material.dart';
import 'package:zxc/colors/app_colors.dart';
import '/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: AppColors.mainBlue,
        canvasColor: AppColors.mainCanvas,
      ),
      home: HomeScreen(),
    );
  }
}
