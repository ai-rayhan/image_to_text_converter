import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScannedScreen extends StatefulWidget {
  const ScannedScreen({super.key});

  @override
  State<ScannedScreen> createState() => _ScannedScreenState();
}

class _ScannedScreenState extends State<ScannedScreen> {
  List<String> dataList = [];

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

  Future<void> saveListToSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myList', dataList);
  }

  void deleteItem(int index) {
    setState(() {
      dataList.removeAt(index);
      saveListToSharedPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanned Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              FlutterClipboard.copy(dataList[index]).then(
                                  (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('copied'),
                                      )));
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          title: const Text("Alert"),
                                          content: Text(
                                              "Are you sure delete this? "),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text("No"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  deleteItem(index);
                                                });
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text("Yes"),
                                            )
                                          ],
                                        ));
                              }),
                        ],
                      ),
                      Text("${index + 1})\n${dataList[index]}")
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
