// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/newWidgets/NavDrawer.dart';
import 'package:smart_home/newWidgets/widgetFileforSwitch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    playSound: true
);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _backgroundNotifications(RemoteMessage message) async{
  await Firebase.initializeApp();
}


class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key? key}) : super(key: key);

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List deviceList = List.generate(0, (index){
    return  {'id': index,
    };
  } );
  List <dynamic> texts = [];
  // List <String> updateTexts = [];
  String? selectedValue ;
  final _dropdownFormKey = GlobalKey<FormState>();
  final database = FirebaseDatabase.instance.ref();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool status1 = false;
  String statusText = 'OFF';
  String send = '';
  bool alertState = false;
  static int listIndex = 0;
  static int count = 0;
  StreamSubscription? streamSubscription;
  final User? user = FirebaseAuth.instance.currentUser;
  static var drawName = '';
  TextEditingController textFieldController = TextEditingController();
  List <String> keyUids = List.generate(100, (index){
    return '';
  } );
  String temp = "";
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Electrical Device"),value: "Electrical Device"),
      DropdownMenuItem(child: Text("Sensor Device"),value: "Sensor Device"),
    ];
    return menuItems;
  }

  // void updateDatabaseList(){
  //   texts.add(textFieldController.text.toString());
  //   print(texts);
  //   print(texts[0]);
  //   print(texts.length);
  //   database.child('Users').child(user!.uid).child('DeviceList').push().set(
  //       {
  //         'Device_ID' : count,
  //         'Device_Name' : texts[listIndex],
  //         'Device_Type' : 'Electrical Device',
  //         'Device_Status' : 0,
  //       }
  //   );
  //   listIndex = listIndex + 1;
  //   textFieldController.clear();
  // }
  void listlist()async{
     database.child('Users').child(user!.uid).child('DeviceList').orderByChild('Device_ID')
         .onValue.listen((event) {
           List listTemps = [];
       List listTemp = [];
           try{

           Map<String, dynamic>.from(event.snapshot.value as dynamic).forEach((key, value) {
             print(value['Device_Name']);
                  listTemps.add(List.generate(1, (index){
                    return value['Device_Name'];
                  }));
                  listTemp.add(List.generate(1, (index){
                    return key;
                  }));
       });}
               catch(e){
             print(e);
               }
               finally{
             setState(() {
               deviceList = listTemp;
               texts = listTemps;
               uidManipulation();
               stringMainpulate();
             });
               }
     });

  }

  void stringMainpulate(){
    for(int i = 0 ; i < texts.length; i++){
      texts[i] = texts[i].toString().substring(1, texts[i].toString().length - 1);
    }
  }

  void uidManipulation(){
    for(int i = 0 ; i < deviceList.length; i++){
      deviceList[i] = deviceList[i].toString().substring(1, deviceList[i].toString().length - 1);
    }
  }

  void staticListener(){
    database.child('Users').child(user!.uid).child('identity').onValue.listen((event) {
      getData(event.snapshot.value.toString());
    });
  }

  void getData(String textName){
    drawName = textName;
  }
  // void listener() async{
  //   await database.child('Users').child(user!.uid).child('Number of Devices').onValue.listen((event)  {
  //     final int? readValue = event.snapshot.value as int?;
  //     print(event.snapshot.value);
  //     setState(() {
  //       try {
  //         count = readValue!;
  //       }
  //       catch(e){}
  //       finally{
  //       deviceList = List.generate(count, (index){
  //         return {'id': index};
  //       });
  //     }});
  //   });
  // }


  String title = '';
  String content = '';
  String choice1 = '';
  String choice2 = '';
  String permission = '';
  int counter = 0;
  Future<void> _displayTextInputDialog(String title, String content,String permission, String choice1, String choice2, BuildContext context){
    this.title = title;
    this.content = content;
    this.choice1 = choice1;
    this.choice2 = choice2;
    this.permission = permission;

    final User? user = firebaseAuth.currentUser;
    final deviceReference = database.child('Users').child(user!.uid);

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
            TextField(
              controller: textFieldController,
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 30.0,
            ),
            Column(
              children: [
                Text(
                  permission,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'Open',
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                DropdownButtonFormField(items:dropdownItems,
                    key: _dropdownFormKey,
                    validator: (value) {
                    if(value == null){
                      return 'Device Type Needed';
                    }
                    }
        //             => value == null
        // ? 'Device type needed' : null
                  ,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      print(selectedValue);
                    });
                  },),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text(choice2,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                        ),),
                      onPressed: () {
                        alertState = false;
                        setState(() {
                          counter = counter - 1;
                          count= count-1;
                        });
                        print(count);
                        print(counter);
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
                        if(textFieldController.text == ""){
                          Fluttertoast.showToast(msg:
                          'Enter the name of the device',
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.blueGrey,
                          );
                        }
                        else{
                          if(selectedValue == null){
                            Fluttertoast.showToast(msg:
                            'Select the type of device',
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.blueGrey,
                            );
                          }
                          else{
                        database.child('Register_Device_Request').child(drawName).update(
                          {'Required_Device_Name' :textFieldController.text,
                            'Required_Device_Type' :selectedValue
                          }
                        );
                        alertState = true;
                        Navigator.pop(context);}}},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 3, //elevation of button
                        shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(30)
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )

          ],
        );
      },
    );
  }
  Future<void> _displayDialog(String title, String content, String choice1, String choice2, BuildContext context){
    this.title = title;
    this.content = content;
    this.choice1 = choice1;
    this.choice2 = choice2;

    final User? user = firebaseAuth.currentUser;
    final deviceReference = database.child('Users').child(user!.uid);

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
                setState(() {
                  count = count+1;
                  counter = counter-1;
                });
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
                  deviceReference.update({'Number of Devices': counter});
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
            )

          ],
        );
      },
    );
  }
  void showNotification(String string){
    flutterLocalNotificationsPlugin.show(0, 'Alert!!!', string,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ));

  }
  var firebaseDb = FirebaseDatabase.instance.ref();
  void getValue(dynamic value){
    if(value == 1){
      showNotification('Someone out there');
      Future.delayed(Duration(seconds: 5),);
      firebaseDb.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child('Sensors').
      child('MotionDetector').update({'MotionDetection' : 0});
    }
  }
  void getValue2(dynamic value){
    if(value == 1){
      showNotification('Smoke Detected in your house');
      Future.delayed(Duration(seconds: 5),);
      firebaseDb.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child('Sensors').
      child('SmokeDetector').update({'SmokeDetection' : 0});
    }
  }


  void checkBurn(){
    firebaseDb.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child('Sensors').
    child('MotionDetector').onValue.listen((event) {
      try{
        Map<String,dynamic>.from(event.snapshot.value as dynamic).forEach((key, value) {
          getValue(value);
        });}
      catch(e){}

    });
  }
  void checkSmoke(){
    firebaseDb.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child('Sensors').
    child('SmokeDetector').onValue.listen((event) {
      try{
        Map<String,dynamic>.from(event.snapshot.value as dynamic).forEach((key, value) {
          getValue2(value);
        });}
      catch(e){}

    });
  }

  @override
  void initState() {
    super.initState();
    staticListener();
    listlist();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? remoteNotification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if(remoteNotification!= null && android!= null){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text(remoteNotification.title.toString()),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextButton(onPressed: () {  }, child: Text('ALert!!!'
                      ''),),
                ],
              ),
            ),
          );
        });
        flutterLocalNotificationsPlugin.show(
            remoteNotification.hashCode,
            remoteNotification.title,
            remoteNotification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                )
            )
        );
      }

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('notification');
      RemoteNotification? remoteNotification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if(remoteNotification!= null && android!= null){
        showDialog(context: context, builder:(_){
          return AlertDialog(
            title: Text(remoteNotification.title.toString()),
            content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextButton(onPressed:(){

                    }, child:

                    Text(
                        'Alert!!!'
                    )),
                  ],
                )
            ),
          );
        } );
      }
    });
    do{
      checkBurn();
      checkSmoke();
    }
    while(false);



  }




  @override
  void deactivate() {
    super.deactivate();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {

    // void addDevice() async{
    //   await _displayTextInputDialog('New Device?','Enter device name','Do you want to add this device?','Yes', 'No', context);
    //   if(alertState == true){
    //     setState(() {
    //       deviceList.add(Custom_Switch(count: 0, abc: '',name:''));
    //       updateDatabaseList();
    //       print(count);
    //     });
    //   }
    //   else{alertState = false;}
    // }

void registers() async {
      await _displayTextInputDialog('Register Device?', 'Enter device name', 'Do you want to register this new device?', 'Yes', 'No', context);
}

Widget cardContainer(Image imageStr) {
  Image image = imageStr;
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: Colors.lightBlue[50]
    ,
    child: Container(child: imageStr,
      height: 100.0,
      width: 385.0,),
  );
}


    void handleClick(String value) {
      switch (value) {
        case 'Register a New Device':
          registers();
          //addDevice();
          break;
      }
    }


    return Scaffold(
      key: _key,
      drawer: NavigationDrawer(name: drawName,),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu), onPressed: () {
            _key.currentState!.openDrawer();
        },
        ),
        automaticallyImplyLeading: false,
        title: Text(
        'Smart Home',
      ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Register a New Device'}.map((String choice) {
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
      body:Column(
        children: [
          Container(
            height: 100.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: PageScrollPhysics(),
              child: Row(
                children: [
                  GestureDetector(child: cardContainer(Image.asset('Assets/images/acImage.png' ,width: 30.0,
                    height: 100.0,),),
                  onTap: (){
                    Navigator.of(context).pushNamed('/autoAc');
                  },),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed('/sonar');
                    },
                    child: cardContainer(Image.asset('Assets/images/waterTank.png' ,width: 30.0,
                      height: 100.0,),),
                  ),
                ],
              ),
            ),
          )
          ,
          Padding(
            padding: const EdgeInsets.all(8.0),
              child: ListView.builder(itemCount: deviceList.length,
                  shrinkWrap: true,
                  physics: PageScrollPhysics(),
             itemBuilder: (context,index){
                    return Custom_Switch(count: index, abc: deviceList[index], name: texts[index],);
                  }),

          ),
        ],
      ),);
  }
}

