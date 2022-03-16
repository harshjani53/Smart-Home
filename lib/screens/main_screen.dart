// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:smart_home/newWidgets/widgetFileforButton.dart';
import 'package:smart_home/logic/otpSignIn.dart';
import 'package:smart_home/logic/googleSignIn.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({Key? key}) : super(key: key);

  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: Image.asset('Assets/images/main_screen2.png'),
              ),
            ), const SizedBox(
              height: 20.0,
            ),
            Container(
              child: const Text(
                'Smart Home',
                style: TextStyle(
                    color: Colors.lightBlueAccent,
                    decoration: TextDecoration.none,
                    backgroundColor: Colors.white,
                    fontFamily: 'Open',
                    fontWeight: FontWeight.bold,
                    fontSize: 36.0),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              color: Colors.white,
              child: CustomButton(
                text: 'Sign in with Google',
                leadingWidget: const Image(
                  image: AssetImage(
                    "Assets/Icon/google-logo.png",
                  ),
                  height: 22.0,
                  width: 22.0,
                ),
                borderRadius: 20.0,
                onPressed: () {
                  accountSignIn(context);
                },
                darkMode: false, buttonColors: const Color(0xFFFFFFFF),
                textColor: const Color(0xFF000000),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              child: CustomButton(
                buttonColors: const Color(0xFFFFFFFF),
                textColor: const Color(0xFF000000),
                text: 'Sign in with Phone Number',
                leadingWidget: const Icon(
                  Icons.phone,
                  color: Colors.lightBlueAccent,
                ),
                borderRadius: 20.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NumberLogin()),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}