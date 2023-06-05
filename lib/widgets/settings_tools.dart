import 'package:flutter/material.dart';


class Settings_tools extends StatelessWidget {
  Settings_tools(
      {this.icon, required this.txt, this.width, this.ticon, this.ontap});
  String txt;
  var icon;
  var width;
  var ticon;
  var ontap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListTile(
          tileColor: Colors.transparent,
          title: Text(
            txt,
            style: TextStyle(fontSize: 18),
          ),
          leading: Icon(
            icon, size: 30,
            // color: kGwhte,
          ),
          trailing: const Icon(
            Icons.arrow_right, size: 40,
            // color: kGwhte,
          ),
          // tileColor: kPrimaryLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

          onTap: ontap,
        ),
      ),
    );
  }
}
