import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogService {
  static Future<String> createAlertDialog(BuildContext context, String dialogText, String buttonText) {
    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
          title: Text(dialogText),
          content: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: customController
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(customController.text.toString());
              },
              elevation: 5.0,
              child: Text(buttonText),
            )
          ]
      );
    });
  }
}


