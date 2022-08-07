import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/screens/home_screen.dart';
import 'colors/app_colors.dart';
import 'colors/themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: Color(0xFFF7F6F2),
        accentColor: Colors.white,
        canvasColor: AppColors.mainCanvas,
        cardColor: Color(0xFF8E8E93),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainCanvas,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w500,
              ),
            ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(),
        canvasColor: Color(0xFF161618),
        primaryColor: const Color(0xFF161618),
        hintColor: Colors.white,
        cardColor: Color(0xFF8E8E93),
        accentColor: const Color(0xFF252528),
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyMedium: const TextStyle(color: Colors.white),
              titleMedium: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w500,
              ),
            ),
      ),
      home: HomeScreen(),
    );
  }

  void qwe() async {
    var request =
        http.Request('GET', Uri.parse('https://beta.mrdekk.ru/todobackend'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
