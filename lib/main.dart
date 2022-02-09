import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {

  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.indigo,
                centerTitle: false,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                foregroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white)),
            textTheme: TextTheme(
              bodyText2: TextStyle(color: Colors.black),
                caption: TextStyle(color: Colors.grey.shade800)

            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            )),
        darkTheme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            dividerColor: Colors.grey.shade500,
            textTheme: TextTheme(

              bodyText2: TextStyle(color: Colors.grey)
            ),

            listTileTheme: ListTileThemeData(
              iconColor: Colors.grey.shade500,
              textColor: Colors.grey.shade500,
            ),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.blueGrey.shade900,
                foregroundColor: Colors.grey.shade400,
                centerTitle: false,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                iconTheme: IconThemeData(color: Colors.grey.shade200)),
           ),
        themeMode: _themeMode,
        home: HomePage());
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
