import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';
import '../widgets/app_drawer.dart';

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

  @override
  void initState() {
    super.initState();
    loadListFromSharedPrefs();
  }

  Future<void> loadListFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedList = prefs.getStringList('myList');
    if (storedList != null) {
      setState(() {
        dataList = storedList;
      });
    }
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
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 40),
                    height: 300,
                    width: 300,
                    child: Image.asset(
                      'assets/img1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    pickImage(ImageSource.camera, pickedImage);
                  },
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
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        pickImage(ImageSource.gallery, pickedImage);
                      },
                      child: Icon(
                        Icons.image,
                        size: 30,
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        pickImage(ImageSource.camera, pickedImage);
                      },
                      child: Icon(
                        Icons.camera_rounded,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        drawer: AppDrawer());
  }
}
