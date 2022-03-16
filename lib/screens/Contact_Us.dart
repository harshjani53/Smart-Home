
// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ContactUs extends StatefulWidget {
  ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  final _formKey = GlobalKey<FormState>();
  String mode = "E";
  bool isMode = true;
  TextEditingController name = TextEditingController() ;
  TextEditingController mailOrPhone = TextEditingController() ;
  TextEditingController subject = TextEditingController() ;
  TextEditingController description = TextEditingController() ;
  String getName = '';
  String getContact = '';
  String getSubject = '';
  String getDesc = '';
  String req = 'This field is required.';
  final database = FirebaseDatabase.instance.ref();
  FirebaseAuth fb = FirebaseAuth.instance;

  void getData(){
    setState(() {
      getName = name.text;
      getContact = mailOrPhone.text;
      getSubject = subject.text;
      getDesc = description.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactUSReference = database.child('Queries/');
    final User? user = fb.currentUser;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(automaticallyImplyLeading: true,
            title: Text(
              'Smart Home',
            ),),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white12
                      ),
                      icon: Icon(Icons.person),
                      hintText: 'Enter your name',
                      labelText: 'Name:',
                    ),
                    keyboardType: TextInputType.name,
                    maxLines: null,
                    controller: name,
                    validator: (value){
                      if(value!.isEmpty || value.length < 3){
                        return req;
                      }
                    },
                  ),

                 ListTile(
                   title: Text("E-Mail"),
                   leading: Radio(
                     value: 'E',
                     groupValue: mode,
                     onChanged: (value) {
                       setState(() {
                         mode = value.toString();
                          isMode = true;
                       });
                     },
                     toggleable: true,
                     activeColor: Colors.indigoAccent,
                   ),
                 ),
                 ListTile(
                   title: Text("Phone Number"),
                   leading: Radio(
                     value: 'P',
                     groupValue: mode,
                     onChanged: (value) {
                       setState(() {
                         mode = value.toString();
                         isMode = false;
                       });
                     },
                     toggleable: true,
                     activeColor: Colors.indigoAccent,
                   ),
                 ),
                  isMode ? TextFormField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white12
                      ),
                      icon: Icon(Icons.mail_outline),
                      hintText: 'Enter your Email',
                      labelText: 'E-Mail:',
                    ),
                    controller: mailOrPhone,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: null,
                    validator: (value){
                      if(value!.isNotEmpty){
                        return null;
                      }
                      else{
                        return req;
                      }
                    },
                  ) :
                  TextFormField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white12
                      ),
                      icon: Icon(Icons.phone_android_outlined),
                      hintText: 'Enter your Phone Number',
                      labelText: 'Phone Number:',
                    ),
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    controller: mailOrPhone,
                    validator: (value){
                      if(value!.isNotEmpty){
                        return null;
                      }
                      else{
                        return req;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white12
                      ),
                      icon: Icon(Icons.info_outline),
                      hintText: 'Enter your Query',
                      labelText: 'Subject:',
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    controller: subject,
                    validator: (value){
                      if(value!.isEmpty || value.length < 5){
                        return req;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white12
                      ),
                      icon: Icon(Icons.description),
                      hintText: 'Enter description about your query',
                      labelText: 'Description:',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: description,
                    validator: (value){
                      if(value!.isEmpty || value.length < 10){
                        return req;
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Center(
                      child: ElevatedButton(
                        child: Text('Submit',
                        style: TextStyle(
                          color: Colors.indigoAccent
                        ),),
                        onPressed: () async{
                          if(_formKey.currentState!.validate()){
                                getData();
                                var data = {
                                  'Name': getName,
                                  'User- ID': user!.uid,
                                  'Contact': getContact,
                                  'Query': getSubject,
                                  'Description': getDesc
                                };
                                try{
                                  await contactUSReference.update(data);
                                  Fluttertoast.showToast(msg:
                                  'We will connect you within 2 business days',
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.blueGrey,
                                  );
                                  Navigator.of(context).pushNamed('/DeviceScreen');
                                }
                                catch(e){
                                  print(e);
                          }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(//to set border radius to button
                              borderRadius: BorderRadius.circular(30),)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
          )
      ),
    );
  }
}
