// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/newWidgets/switch.dart';
import 'package:smart_home/main.dart';

class AutoAC extends StatefulWidget {
  const AutoAC({Key? key}) : super(key: key);
  @override
  State<AutoAC> createState() => _AutoACState();
}

class _AutoACState extends State<AutoAC> {

  var firebaseDb = FirebaseDatabase.instance.ref();
  static int dataFound = 0;
  static int acData = 0;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static String isModeOn = "OFF";
  bool alertState = true;
  bool status1 = false;
  String statusText = 'OFF';
  static double temperatureSense = 0;
  static int humiditySense = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  void getData(int value) {
    dataFound = value;
  }
  void dynamicFunction(dynamic keys, dynamic val){
    if(keys.toString() == 'Humidity'){
      print(val);
      humiditySense = val;
      print(humiditySense);
    }
    if(keys.toString() == 'Temperature'){
      temperatureSense = val;
    print(temperatureSense);
    }
  }
  void dataWrite(int dataTosent) async{
    final deviceWrite = firebaseDb.child('Users').child(user!.uid).child('Sensors').child('ACFeature');
    await deviceWrite.update({
      'Feature':dataTosent,
    });
  }
  void acStatus(int status_ac){

    firebaseDb.child('Users').child(user!.uid).child('Sensors').child('ACFeature').
    update({
      'Status' : status_ac,
    });

  }

  void getSensors(){
    firebaseDb.child('Users').child(user!.uid).child('Sensors').child('ACFeature').onValue.listen((event) {
      try{
      Map<String,dynamic>.from(event.snapshot.value as dynamic).forEach((key, value) {
        print(key);
        print(value);
        dynamicFunction(key, value);
      });}
          catch(e){}
    });
  }
  void AcFeature(){
    firebaseDb.child('Users').child(user!.uid).child('Sensors').child('ACFeature').onValue.listen((event) {
      try{
      Map<String,dynamic>.from(event.snapshot.value as dynamic).forEach((key, value) {
        if(key == 'Feature'){
          setState(() {
            try{
              dataFound = value;
              if(dataFound ==0){
                isModeOn = 'OFF';
              }
              else{
                isModeOn = 'ON';
              }
            }
            catch(e){}
          });
        }
        if(key == 'Status'){
          setState(() {
            acData = value;
            if(acData == 0){
              status1 = false;
              statusText = 'OFF';
            }
            else{
              status1 = true;
              statusText = 'ON';
            }
          });
        }
      });}
          catch(e){}
    });
  }
  @override
  void initState() {
    AcFeature();
    getSensors();
    super.initState();
  }

  Future<void> _makeDialog(String title, String content, String choice1, String choice2, BuildContext context) async {
    
    return showDialog(context: context, builder: (context){
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
    });
  }

  Widget customWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      SizedBox(
      height: 20.0,
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text('Manual Switch for AC',
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
    acStatus(1);
    }
    else{
    statusText = 'OFF';
    acStatus(0);
    }
    });
    },
    ),
    Container(
    alignment: Alignment.centerRight,
    child: Text(
    "AC Status: $statusText",
    style: TextStyle(
    fontSize: 20.0,
    fontFamily: 'Open',
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ],
    ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    void showDialog() async{
      try {
        await _makeDialog('Automatic AC.',
            'Do you want to turn OFF Automatic AC feature?',
            'Yes', 'No', context);
      }
      catch(e){}
      finally{
      if(alertState == true){
        dataFound = 0;
        isModeOn = 'OFF';
        dataWrite(dataFound);
      }
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Automatic AC Feature',
          style: TextStyle(
            fontFamily: 'Open',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Do you want to enable Automatic AC feature?',
            style: TextStyle(
              fontSize: 22.0,
              fontFamily: 'Open',
              fontWeight: FontWeight.bold,
            ),),
              ElevatedButton(onPressed: () {
                  setState(() {
                      if(dataFound == 0){
                        dataFound = 1;
                        isModeOn = 'ON';
                        dataWrite(dataFound);
                      }
                      else{
                      showDialog();
                      }
                  });
              }, child: Text('AC Feature is $isModeOn'),
              ),
            Divider(
              thickness: 2,
              color: Colors.lightBlueAccent,
            ),
            SizedBox(height: 20.0,),
            customWidget(),
            SizedBox(height: 50.0,),
            Container(
              color: Colors.indigoAccent,
              child: Padding( 
                padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('Temperature:  $temperatureSense °C ',
                      style: TextStyle(
                    fontFamily: 'Open',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white
                      ),),
                    SizedBox(height: 14.0,),
                    Divider(
                      thickness: 1,
                        color: Colors.white,
                    ),
                    Text('Humidity: $humiditySense %',
                      style: TextStyle(
                          fontFamily: 'Open',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white
                      ),),
                    SizedBox(height: 20.0,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
