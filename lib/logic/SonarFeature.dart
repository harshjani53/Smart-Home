// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/newWidgets/switch.dart';
class AutoSonar extends StatefulWidget {
  const AutoSonar({Key? key}) : super(key: key);

  @override
  State<AutoSonar> createState() => _AutoSonarState();
}

class _AutoSonarState extends State<AutoSonar> {

  var firebaseDb = FirebaseDatabase.instance.ref();
  static bool alertState = true;
  bool status1 = false;
  static String isModeOn = "OFF";
  String statusText = 'OFF';
  static int dataFound = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  static double distanceSense = 0;
  static double distanceSense2 = 0;
  static String distanceText = ' ';
  static int disData = 0;

  void dynamicFunction(dynamic keyData,dynamic data){
    if(keyData.toString() == 'Distance'){
      distanceSense = data;
    }
    if(distanceSense >= 0 && distanceSense <= 10){
      distanceText = ' Tank is Full';
    }
    else if(distanceSense > 10 && distanceSense <30){
      distanceText = 'Tank is Almost Full';
    }
    else if(distanceSense >= 30 && distanceSense <= 60){
      distanceText = 'Tank is Half Empty';
    }
    else if(distanceSense >60 && distanceSense < 90){
      distanceText = 'Tank is Almost Empty';
    }
    else if(distanceSense >= 90){
      distanceSense = 99;
      distanceText = 'Tank is Empty';
    }
    distanceSense2 = 100 - distanceSense;
  }


  void dataWrite(int data){
    firebaseDb.child('Users').child(user!.uid).child('Sensors').child('distanceSensor')
        .update({
      'Status' : data
    });
  }
  void featureWrite(int data){
    firebaseDb.child('Users').child(user!.uid).child('Sensors').child('distanceSensor')
        .update({
      'Feature' : data
    });
  }
  void getSensors(){
    firebaseDb.child('Users').child(user!.uid).child('Sensors').child('distanceSensor')
        .onValue.listen((event) {
          try{
      Map<String,dynamic>.from(event.snapshot.value as dynamic).forEach((key, value) {
       dynamicFunction(key,value);
      });}
              catch(e){}

    });
  }
  void listenDistanceValues(){
    firebaseDb.child('Users').child(user!.uid).child('Sensors').child('distanceSensor')
        .onValue.listen((event) {
          try{
          Map<String, dynamic>.from(event.snapshot.value as dynamic).forEach((key, value) {
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
                disData = value;
                if(disData == 0){
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
            Text('Manual Switch for Motor',
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
                    dataWrite(1);
                  }
                  else{
                    statusText = 'OFF';
                    dataWrite(0);
                  }
                });
              },
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                "Motor Status: $statusText",
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
  void initState() {
    listenDistanceValues();
    getSensors();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    void showDialog() async{
      try {
        await _makeDialog('Automatic Water Motor.',
            'Do you want to turn OFF Automatic Motor feature?',
            'Yes', 'No', context);
      }
      catch(e){}
      finally{
        if(alertState == true){
          dataFound = 0;
          isModeOn = 'OFF';
         featureWrite(dataFound);
        }
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Automatic Motor Feature',
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
            Text('Do you want to enable Automatic Motor feature?',
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
                 featureWrite(dataFound);
                }
                else{
                  showDialog();
                }
              });
            }, child: Text('Motor Feature is $isModeOn'),
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

                    AbsorbPointer(
                      absorbing: true,
                      child: Slider(
                        value: distanceSense2,
                        onChanged: (value) {
                          setState(() {
                            print(distanceSense2);
                            distanceSense2 = value;
                          });
                        },
                        min: 0,
                        max: 100,
                        activeColor: Colors.white,
                        label: distanceSense2.toString(),
                        divisions: 10,
                      ),
                    ),
                    //
                    Divider(
                      thickness: 2,
                      color: Colors.lightBlueAccent,
                    ),
                    SizedBox(height: 10.0,),
                    Text('Tank Status: $distanceText ',
                      style: TextStyle(
                          fontFamily: 'Open',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white
                      ),),
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
