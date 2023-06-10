import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_to_text_converter/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/scanned_screen.dart';
import 'utils.dart';
import 'widgets/bottom_navbar.dart';
import 'widgets/webview_cls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkTheme = false;
  checkMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? a = await pref.getBool('darktheme');
    if (a == true) {
      setState(() {
        darkTheme = true;
      });
    } else {
      setState(() {
        darkTheme = false;
      });
    }
  }

  @override
  void initState() {
    checkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: darkTheme
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.blue,
            ),
      home: MyBottomNavBar(),
      routes: {
        'web': (context) => const Webview_class(),
        'scTxt': (context) => const ScannedScreen(),
      },
    );
  }
}

