import 'package:flutter/material.dart';

AppBar appBar(BuildContext context) {
  return AppBar(
    title: Row(
      children: [
        SizedBox(
          width: 27,
          height: 27,
          child: Image.asset('./images/icon.png'),
        ),
        const SizedBox(
          width: 12,
        ),
        const Text(
          'JobJourney',
          style: TextStyle(
            fontSize: 18,
            color: Colors.lightBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    centerTitle: false,
    elevation: 5.0,
    backgroundColor: Theme.of(context).colorScheme.primary,
  );
}
