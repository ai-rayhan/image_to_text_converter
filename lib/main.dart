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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _pickedImage;
  String outputText = "";
  List<String> dataList = [];

  Future<void> saveListToSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myList', dataList);
  }

  void addItemToList(String outputtext) {
    setState(() {
      dataList.add(outputtext);
      saveListToSharedPrefs();
    });
  }

  pickedImage(File file) {
    setState(() {
      _pickedImage = file;
    });

    InputImage inputImage = InputImage.fromFile(file);
    //code to recognize image
    processImageForConversion(inputImage);
  }

  processImageForConversion(inputImage) async {
    setState(() {
      outputText = "";
    });

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    for (TextBlock block in recognizedText.blocks) {
      setState(() {
        outputText += block.text + "\n";
      });
    }
    addItemToList(outputText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Image to Text")),
        body: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(children: [
              if (_pickedImage == null)
                Container(
                  height: 300,
                  child: Image.asset('assets/image.png'),
                  width: double.infinity,
                )
              else
                SizedBox(
                  // height: 300,
                  width: double.infinity,
                  child: Image.file(
                    _pickedImage!,
                    fit: BoxFit.fill,
                  ),
                ),
              // Expanded(child: Container()),
              if (_pickedImage != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          FlutterClipboard.copy(outputText).then((value) =>
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('copied'),
                              )));
                        },
                        icon: Icon(Icons.copy))
                  ],
                ),
              // else
                // Container(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  // color: Colors.white70,
                  child: SelectableText(
                    outputText,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      pickImage(ImageSource.gallery, pickedImage);
                    },
                    icon: Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      pickImage(ImageSource.camera, pickedImage);
                    },
                    icon: Icon(Icons.camera_rounded,
                        size: 40, color: Colors.blue),
                  ),
                ],
              ),
            ]),
          ),
        ),
        drawer: AppDrawer());
  }
}
