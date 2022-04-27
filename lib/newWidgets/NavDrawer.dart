// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {

  final String name;

  NavigationDrawer({required this.name});

  FirebaseAuth fb = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage('https://itacademy-static.microsoft.com/content/images/microsoft-img.png'),
            radius: 40.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 10.0
                ),
              ),
            ],
          )
        ],
      ),
            decoration: BoxDecoration(
                color: Colors.blue,
               ),
          ),
          ListTile(
            leading: Icon(Icons.devices),
            title: Text('Devices'),
            onTap: () => {
    Navigator.of(context).pushNamed('/DeviceScreen'),
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text('Contact Us'),
            onTap: () => {
    Navigator.of(context).pushNamed('/ContactUs'),
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: ()  {
              fb.signOut();
              Navigator.of(context).pushNamed('/MainScreen');
            },
          ),
        ],
      ),
    );
  }
}
