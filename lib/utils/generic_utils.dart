import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GenericUtils {
  static showError(BuildContext context, {String error}) {
    Alert(
      context: context,
      title: 'Si è verificato un errore!',
      desc: error,
      buttons: [
        DialogButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }
}
