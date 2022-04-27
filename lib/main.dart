// ignore_for_file: camel_case_types, prefer_const_constructors

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/logic/NetworkCheck.dart';
import 'package:smart_home/logic/SonarFeature.dart';
import 'package:smart_home/screens/Contact_Us.dart';
import 'logic/ACFeature.dart';
import 'screens/DeviceScreen.dart';
import 'package:smart_home/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _backgroundNotifications(RemoteMessage message) async{
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundNotifications);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.
      createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // var firebaseDb = FirebaseDatabase.instance.ref();
  // void getValue(dynamic value){
  //   if(value == 1){
  //     showNotification('Someone out there');
  //     Future.delayed(Duration(seconds: 5),);
  //     firebaseDb.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child('Sensors').
  //     child('MotionDetector').update({'MotionDetection' : 0});
  //   }
  // }
  // void getValue2(dynamic value){
  //   if(value == 1){
  //     showNotification('Smoke Detected in your house');
  //     Future.delayed(Duration(seconds: 5),);
  //     firebaseDb.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child('Sensors').
  //     child('SmokeDetector').update({'SmokeDetection' : 0});
  //   }
  // }
  //
  //
  // void checkBurn(){
  //   firebaseDb.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child('Sensors').
  //   child('MotionDetector').onValue.listen((event) {
  //     try{
  //       Map<String,dynamic>.from(event.snapshot.value as dynamic).forEach((key, value) {
  //         getValue(value);
  //       });}
  //     catch(e){}
  //
  //   });
  // }
  // void checkSmoke(){
  //   firebaseDb.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child('Sensors').
  //   child('SmokeDetector').onValue.listen((event) {
  //     try{
  //       Map<String,dynamic>.from(event.snapshot.value as dynamic).forEach((key, value) {
  //         getValue2(value);
  //       });}
  //     catch(e){}
  //
  //   });
  // }
  
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? remoteNotification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if(remoteNotification!= null && android!= null){
        // showDialog(context: context, builder: (_){
        //   return AlertDialog(
        //     title: Text(remoteNotification.title.toString()),
        //     content: SingleChildScrollView(
        //       child: Column(
        //         children: [
        //           TextButton(onPressed: () {  }, child: Text('ALert!!!'
        //               ''),),
        //         ],
        //       ),
        //     ),
        //   );
        // });
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
         // showDialog(context: context, builder:(_){
         //   return AlertDialog(
         //     title: Text(remoteNotification.title.toString()),
         //     content: SingleChildScrollView(
         //       child: Column(
         //         children: [
         //           TextButton(onPressed:(){
         //
         //           }, child:
         //
         //           Text(
         //             'Alert!!!'
         //           )),
         //         ],
         //       )
         //     ),
         //   );
         // } );
        }
    });
   // checkBurn();
    //checkSmoke();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.lightBlueAccent,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlueAccent),
      ),
      routes: {
        '/DeviceScreen' : (BuildContext context) => DeviceScreen(),
        '/ContactUs' : (BuildContext context) => ContactUs(),
        '/MainScreen' : (BuildContext context) => mainScreen(),
        '/autoAc' : (BuildContext context) => AutoAC(),
        '/sonar' : (BuildContext) => AutoSonar()
      },
      home: Scaffold(
appBar: AppBar(
  title: Text('Smart Home'),
),
        body: StreamProvider<NetworkStatus>(
          initialData: NetworkStatus.Offline,
            create: (context) =>
            NetworkStatusService().networkStatusController.stream,
            child: NetworkAwareWidget(
              onlineChild: splashScreen(),
              offlineChild: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 100.0,),
                      Text('No Internet Available', style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'Open',
                        fontWeight: FontWeight.bold,
                      ),)
                    ],
                  ),
                ),
              ),

            ),
        ),
        // home: splashScreen(),
      ),
    );
  }
}

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),()=> {
      FirebaseAuth.instance.currentUser == null ? {Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              mainScreen()
          )
      )} : {Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              DeviceScreen(),

          )
      )}

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 1.0,),
          Container(child: Image.asset('Assets/images/main_screen2.png')),

          Text('Smart Home',
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  decoration: TextDecoration.none,
                  backgroundColor: Colors.white,
                  fontFamily: 'Open',
                  fontSize: 36.0),),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}


















