// ignore_for_file: camel_case_types, prefer_const_constructors

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/logic/NetworkCheck.dart';
import 'package:smart_home/screens/Contact_Us.dart';
import 'screens/DeviceScreen.dart';
import 'package:smart_home/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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


















// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(
//     home: mainApp(),));}
//
// class mainApp extends StatelessWidget {
//   const mainApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset('Assets/images/main_screen2.png'),
//             Text('Some Text',
//             textAlign: TextAlign.left,
//             style: TextStyle(
//               color: Colors.blue,
//               backgroundColor: Colors.white
//             ),),
//            Container(
// alignment: Alignment.bottomRight,
//              color: Colors.white,
//              child: CustomButton(
//                textColor: Color(0xFFFFFFFF),
//                buttonColors: Color(0xFF40C4FF),
//
//                text: 'Get Started',
//                leadingWidget: Icon(
//                  Icons.arrow_forward_rounded,
//                  color: Colors.white,
//                ),
//                onPressed: ()=>{
//                  Navigator.push(context, MaterialPageRoute(builder: (context) => mainScreen()))
//                },
//                 borderRadius: 20.0,
//              ),
//            )
//           ],
//         ),
//       ),);
//   }
// }
//
