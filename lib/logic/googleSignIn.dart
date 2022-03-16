import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_home/screens/DeviceScreen.dart';


FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
// CollectionReference _collectionReferenceUser =
// FirebaseFirestore.instance.collection('users');

Future<void> accountSignIn(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final UserCredential result =
      await firebaseAuth.signInWithCredential(credential);
      final User? authUser = result.user;
      DatabaseReference _databaseReference = firebaseDatabase.ref(authUser!.uid);

      var data = {
        'provider': 'Google Account',
        'email': googleSignInAccount.email
      };
      _databaseReference.update(data);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => DeviceScreen(),
            ),
          );
      // _collectionReferenceUser.doc(authUser!.uid).get().then((doc) {
      //   if (doc.exists) {
      //     doc.reference.update(data);
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(
      //         builder: (context) => DeviceScreen(),
      //       ),
      //     );
      //   } else {
      //     _collectionReferenceUser.doc(authUser.uid).set(data);
      //
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(
      //         builder: (context) => DeviceScreen(),
      //       ),
      //     );
      //   }
      // });
    }
  } on Exception {
    print(Exception);
  }
}