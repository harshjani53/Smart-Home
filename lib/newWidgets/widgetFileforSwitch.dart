// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/newWidgets/switch.dart';
import 'package:smart_home/screens/DeviceScreen.dart';

class Custom_Switch extends StatefulWidget {

  const Custom_Switch({required this.count, Key? key}) : super(key: key);
  final int count;

  @override
  _Custom_SwitchState createState() => _Custom_SwitchState();
}

class _Custom_SwitchState extends State<Custom_Switch> {
  bool status1 = false;
  String statusText = 'OFF';
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
            Text('Device-$deviceId',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Open',
                fontWeight: FontWeight.bold,
              ),),
    //         ElevatedButton(onPressed: (){
    //
    //           setState(() {
    //           });
    //         },
    // style: ElevatedButton.styleFrom(
    //   elevation: 0,
    // fixedSize: const Size(10, 10),
    // shape: const CircleBorder(),primary: Colors.white,
    // ),
    //             child: Icon(
    //               Icons.highlight_remove_outlined,
    //               color: Colors.indigoAccent,
    //             ),),
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
                  }
                  else{
                    statusText = 'OFF';
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