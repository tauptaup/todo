import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/screens/home_screen.dart';
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
      themeMode: ThemeMode.system,
      theme: MyThemes.lighTheme,
      // darkTheme: MyThemes.darkTheme,
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
