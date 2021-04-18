import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget notificationString(BuildContext context, String message, {Icon icon}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: ListTile(
    leading: icon == null
        ? Icon(
            Icons.info,
            color: Colors.blueAccent,
          )
        : icon,
    title: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
  )));
}
