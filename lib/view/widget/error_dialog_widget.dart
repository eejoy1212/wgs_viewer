import 'package:flutter/material.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/main.dart';

errorDialog() {
  if (FilePickerCtrl.to.isError.value == 1) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Column(
          children: const [
            Text('Error'),
            Divider(
              color: Colors.blueGrey,
              indent: 6,
              endIndent: 6,
            ),
          ],
        ),
        content: const Text(
            'File format is different. \nFailed to separate the time axis.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
  if (FilePickerCtrl.to.isError.value == 2) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Column(
          children: const [
            Text('Error'),
            Divider(
              color: Colors.blueGrey,
              indent: 6,
              endIndent: 6,
            ),
          ],
        ),
        content: const Text(
            'The maximum number of files that can be selected is five.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
  if (FilePickerCtrl.to.isError.value == 3) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Column(
          children: const [
            Text('Error'),
            Divider(
              color: Colors.blueGrey,
              indent: 6,
              endIndent: 6,
            ),
          ],
        ),
        content: const Text('Select WaveLength'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
  return null;
}
