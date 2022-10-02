import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, bool inputData) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Color(0xFF46486c)),
        overlayColor: MaterialStateProperty.all(Color(0x407070a0))),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(
      inputData
          ? "The test's name is already existed.\nPlease write a new one."
          : "Please write the test's name.",
      style: TextStyle(fontSize: 15),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
