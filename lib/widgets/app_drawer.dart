
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
         const DrawerHeader(child:Center(
                child: Text(
                  "IMG TO TXT",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                      // color: Colors.blueGrey
                     ),
                ),
              ) ,),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.document_scanner),
            title: const Text('Scanned Text'),
            onTap: () {
              Navigator.of(context).pushNamed('scTxt');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text('Rate Us'),
            onTap: () {
           
                StoreRedirect.redirect(
                  androidAppId:
                      "com.niksoftware.snapseed", //iOSAppId: "585027354"
                );
            
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('About Us'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed('web');
            },
          ),
        ],
      ),
    );
  }
}
