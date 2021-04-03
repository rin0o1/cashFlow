import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Dialogs {
  static Future<void> confermationDialog(BuildContext context, String title,
      String text, VoidCallback callback) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text("CANC"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                callback();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> colopiclerDialog(BuildContext context, Color pickerColor,
      Color currentColor, ValueChanged<Color> changeColor) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Got it'),
                onPressed: () {
                  currentColor = pickerColor;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
