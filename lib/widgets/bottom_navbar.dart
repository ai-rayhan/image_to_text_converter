import 'package:flutter/material.dart';
import 'package:image_to_text_converter/main.dart';

import '../screens/scanned_screen.dart';
import '../screens/settings_screen.dart';




class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({Key? key}) : super(key: key);
  static const routeName='nav_var';

  @override
  State<MyBottomNavBar> createState() => MyBottomNavBarState();
}

class MyBottomNavBarState extends State<MyBottomNavBar> {
  static int bottomNavigationTabIndex = 0;
  static void selectPage(BuildContext context, int index) {
    MyBottomNavBarState? stateObject =
        context.findAncestorStateOfType<MyBottomNavBarState>();
    stateObject?.setState(() {
      bottomNavigationTabIndex = index;
    });
    print("called nav");
  }

  static void refresh(BuildContext context) {
    MyBottomNavBarState? stateObject =
        context.findAncestorStateOfType<MyBottomNavBarState>();
    stateObject?.setState(() {
      bottomNavigationTabIndex = 0;
      bottomNavigationTabIndex = 1;
    });
  }

  static  List<Widget> widgetOptions = <Widget>[
    // CustomNavigationDrawer(),
    HomeScreen(),
     ScannedScreen(),
     SettingScreen(),

  ];

  //Implementing Bottom Navigation Bar

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: widgetOptions.elementAt(bottomNavigationTabIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.home,
                ),
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.document_scanner),
                icon: Icon(Icons.document_scanner_outlined),
                label: "Scanned",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.settings),
                icon: Icon(Icons.settings_outlined),
                label: "Settings",
              ),
            ],
            currentIndex: bottomNavigationTabIndex,
            onTap: (int index) {
              setState(() {
                bottomNavigationTabIndex = index;
              });
            }),
            
      ),
    );
  }
}
