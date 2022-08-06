import 'package:flutter/material.dart';
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
        primarySwatch: MaterialColor(0xFF007AFF, {
          50: Color(0xFF007AFF),
          100: Color(0xFF007AFF),
          200: Color(0xFF007AFF),
          300: Color(0xFF007AFF),
          400: Color(0xFF007AFF),
          500: Color(0xFF007AFF),
          600: Color(0xFF007AFF),
          700: Color(0xFF007AFF),
        }),
        canvasColor: Color(0xFFF7F6F2),
      ),
      home: HomeScreen(),
    );
  }
}
