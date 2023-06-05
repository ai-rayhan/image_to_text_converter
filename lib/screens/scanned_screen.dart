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
        title: Text('List Example'),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dataList[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteItem(index),
            ),
          );
        },
      ),
    );
  }
}
