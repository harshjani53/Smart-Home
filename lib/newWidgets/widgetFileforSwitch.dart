// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/newWidgets/switch.dart';
import 'package:smart_home/screens/DeviceScreen.dart';

class Custom_Switch extends StatefulWidget {
  Custom_Switch({required this.count, required this.abc, required this.name,});
  final int count;
  final dynamic abc;
  final dynamic name;

  @override
  _Custom_SwitchState createState() => _Custom_SwitchState();
}

class _Custom_SwitchState extends State<Custom_Switch> {
  bool status1 = false;
  static bool setData = false;
  String statusText = 'OFF';
  final database = FirebaseDatabase.instance.ref();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    tempFunction();
    super.initState();
  }

  void dataWrite(int write, dynamic str){
    database.child('Users').child(user!.uid).child('DeviceList').child(str).
    update(
      {'Device_Status': write}
    );
  }
  getFunc(int datas){
    if(datas == 0){
      if(mounted){
      setState(() {
        setData = false;
        statusText = 'OFF';
        status1 = false;
      });
    }}
    if(datas == 1){
      if(mounted){
      setState(() {
        setData = true;
        statusText = 'ON';
        status1 = true;
      });
    }}
  }
  void tempFunction(){
    database.child('Users').child(user!.uid).child('DeviceList').child(widget.abc).child('Device_Status').onValue.listen((event) {
      getFunc(event.snapshot.value as int);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    int deviceId = widget.count + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Device: ' +widget.name.toString(),
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Open',
                fontWeight: FontWeight.bold,
              ),),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ONandOFF(
              value: status1,
              onToggle: (val) {
                setState(() {
                  status1 = val;
                  if(status1 == true){
                    statusText = 'ON';
                    setData = true;
                    print(widget.abc);
                    dataWrite(1, widget.abc);
                  }
                  else{
                    statusText = 'OFF';
                    setData = false;
                    print(widget.abc);
                    dataWrite(0, widget.abc);
                  }
                });
              },
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                "Device Status: $statusText",
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Open',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 2,
          color: Colors.lightBlueAccent,
        ),
      ],
    );
  }
}