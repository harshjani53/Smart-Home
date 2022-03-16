import 'package:flutter/material.dart';

import 'button.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool darkMode;
  final double borderRadius;
  final VoidCallback onPressed;
  final bool centered;
  final Widget leadingWidget;
  final Color buttonColors;
  final Color textColor;

  CustomButton({
    required this.textColor,
    required this.text,
    required this.leadingWidget,
    required this.onPressed,
    required this.buttonColors,
    this.darkMode = false,
    this.borderRadius = defaultBorderRadius,
    this.centered = false,
  })  : assert(text != ""),
        super();

  @override
  Widget build(BuildContext context) {
    return ContentButton(
      buttonColor: darkMode ? Color(0xFF4285F4) : buttonColors,
      borderRadius: borderRadius,
      splashColor: Colors.lightBlueAccent,
      onPressed: onPressed,
      buttonPadding: 0.0,
      centered: centered,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            height: 38.0, // 40dp - 2*1dp border
            width: 38.0, // matches above
            decoration: BoxDecoration(
              color: darkMode ? Colors.white : null,
              borderRadius: BorderRadius.circular(this.borderRadius),
            ),
            child: Center(
              child: leadingWidget,
            ),
          ),
        ),

        SizedBox(width: 14.0 /* 24.0 - 10dp padding */),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
              color: darkMode ? Colors.white : textColor,
            ),
          ),
        ),
      ],
    );
  }
}