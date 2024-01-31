// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:jobhourjourney/Components/button_component.dart';

Future<AlertDialog?> ShowAlertDialog(
    BuildContext context, String title, String message) async {
  return await showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        content:
            Container(padding: const EdgeInsets.all(12), child: Text(message)),
        actions: [
          CustomButton(
            text: 'OK',
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
