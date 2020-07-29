import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonName;
  final Function onButtonClick;

  LargeButton({this.buttonColor, this.buttonName, this.onButtonClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 7.0,
        horizontal: 40.0,
      ),
      child: SizedBox(
        height: 50.0,
        child: RaisedButton(
          onPressed: onButtonClick,
          child: Text(
            buttonName,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          color: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
