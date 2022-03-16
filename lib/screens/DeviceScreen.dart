// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/newWidgets/widgetFileforSwitch.dart';
import 'package:smart_home/screens/main_screen.dart';
import 'package:http/http.dart' as http ;

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key? key}) : super(key: key);

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final List deviceList = List.generate(0, (index){
    return  {'id': index};
  } );
  var url = "https://smart-home-6ed75-default-rtdb.firebaseio.com/" "Sensor.json";
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool status1 = false;
  String statusText = 'OFF';
  String send = '';
  bool alertState = false;
  static int count = 0;

  TextEditingController textFieldController = TextEditingController();

  String title = '';
  String content = '';
  String choice1 = '';
  String choice2 = '';

  Future<void> _displayTextInputDialog(String title, String content, String choice1, String choice2, BuildContext context){
    this.title = title;
    this.content = content;
    this.choice1 = choice1;
    this.choice2 = choice2;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              child: Text(choice2,
              style: TextStyle(
                color: Colors.lightBlueAccent,
              ),),
              onPressed: () {
                alertState = false;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 3, //elevation of button
                shape: RoundedRectangleBorder( //to set border radius to button
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
            ElevatedButton(
              child: Text(choice1,
              style: TextStyle(
                color: Colors.lightBlueAccent,
              ),),
              onPressed: () {
                alertState = true;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 3, //elevation of button
                shape: RoundedRectangleBorder( //to set border radius to button
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void addDevice() async{
    await _displayTextInputDialog('New Device?','Do you want to add a new device?','Yes', 'No', context);
    if(alertState == true){
    setState(() {
      deviceList.add(Custom_Switch(count: 0,));
    });}
    else{alertState = false;}
  }
  // void dataWrite() async{
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: json.encode({"data": 1}),
  //     );
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  void handleClick(String value) {
    switch (value) {
      case 'Add Device':
        addDevice();
        break;
      case 'Contact Us':
        Navigator.of(context).pushNamed('/ContactUs');
        break;
      case 'Logout':
        firebaseAuth.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => mainScreen(),
          ),
        );
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
        'Smart Home',
      ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Add Device','Contact Us','Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(color: Colors.black, fontFamily: 'Open'),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
          child: ListView.builder(itemCount: deviceList.length
        , itemBuilder: (context,index){
                return Dismissible(key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (_) async{
                      await _displayTextInputDialog('Remove Device?', 'Do you want to remove existing device?', 'Yes', 'No', context);
                      if(alertState == true){
                        setState(() {
                          deviceList.removeAt(index);
                        });}
                      else{
                        alertState = false;
                      }
                    },
                    child: Custom_Switch(count: index,));
              }),

      ),);
  }
}

