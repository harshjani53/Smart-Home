// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/screens/DeviceScreen.dart';


enum otpStates {
  Phone_Number_State,
  OTP_Verify_State,
}
// CollectionReference _collectionReference =
// FirebaseFirestore.instance.collection('users');

class NumberLogin extends StatefulWidget {
  @override
  _NumberLoginState createState() => _NumberLoginState();
}

class _NumberLoginState extends State<NumberLogin> {
  otpStates currentState = otpStates.Phone_Number_State;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String verifyId = "";

  bool spin = false;

  void signInWithPhoneNumber(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      spin = true;
    });
    try {
      final authorize =
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      final User? authorizeUser = authorize.user;
      DatabaseReference databaseReference = firebaseDatabase.ref();
      var data = {
        'identity': _phoneController.text,
        'provider': 'Phone Number'
      };
      databaseReference.child('Users').child(authorizeUser!.uid).update(data);
      setState(() {
        spin = false;
      });
      if (authorize.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DeviceScreen()));
      }
    } on Exception catch (e) {
      setState(() {
        spin = false;
      });
      print(e);
      final snackBar = SnackBar(
        content: Text('Something went wrong!!'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Smart Home',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Open',
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
      ),
      body: spin
          ? Center(
        child: CircularProgressIndicator(),
      )
          : currentState == otpStates.Phone_Number_State
          ? OTPScreenWidget(
          _phoneController,
          'Enter your Phone Number with Country Code',
          'Phone Number',
          Icons.phone,
          'Send OTP', () async {
        setState(() {
          spin = true;
        });

        await _firebaseAuth.verifyPhoneNumber(
            phoneNumber: _phoneController.text,
            verificationCompleted: (phoneAuthCredential) async {
              setState(() {
                spin = false;
              });
            },
            verificationFailed: (verificationFailed) async {
              setState(() {
                spin = false;
              });
              final snackBar = SnackBar(
                content: Text('Something went wrong!!'),
                duration: Duration(seconds: 3),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            codeSent: (verifyId, resendingToken) async {
              setState(() {
                spin = false;
                currentState = otpStates.OTP_Verify_State;
                this.verifyId = verifyId;
              });
            },
            codeAutoRetrievalTimeout: (verifyId) async {
              setState(() {
                spin = false;
                currentState = otpStates.OTP_Verify_State;
                this.verifyId = verifyId;
              });
            },
            timeout: Duration(seconds: 60));
      })
          : OTPScreenWidget(
          _otpController,
          'OTP has sent to your Phone Number',
          'Enter OTP',
          Icons.vpn_key,
          'Verify OTP', () async {
        PhoneAuthCredential phoneAuthCredential =
        PhoneAuthProvider.credential(
            verificationId: verifyId,
            smsCode: _otpController.text);

        signInWithPhoneNumber(phoneAuthCredential);
      }),
    );
  }
}

class OTPScreenWidget extends StatelessWidget {
  final TextEditingController controller;
  final String headString;
  final String hintString;
  final IconData leadIcon;
  final String btnText;
  final Function press;

  OTPScreenWidget(this.controller, this.headString, this.hintString,
      this.leadIcon, this.btnText, this.press);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Text(
                headString,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Open',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextFormField(
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: hintString,
                  prefixIcon: Icon(leadIcon),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            ElevatedButton(
              onPressed: () => press(),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Colors.lightBlueAccent),
              ),
              child: Text(
                btnText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}