import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowBtns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: windowBtnColors),
        // MaximizeWindowButton(
        //   colors: windowBtnColors,
        // ),
        CloseWindowButton(
          colors: closeBtnColors,
          onPressed: () {
            print('나가시겠습니까??');
            exit(0);
          },
        ),
      ],
    );
  }

  final windowBtnColors = WindowButtonColors(
      iconNormal: Colors.white,
      mouseOver: Color(0xFFA2B4CE),
      // mouseDown: Color(0xff0d47a1),
      iconMouseOver: Colors.white,
      iconMouseDown: Colors.white);

  final closeBtnColors = WindowButtonColors(
      iconNormal: Colors.white,
      mouseOver: Colors.redAccent,
      mouseDown: Color(0xff0d47a1),
      iconMouseOver: Colors.white);
}
