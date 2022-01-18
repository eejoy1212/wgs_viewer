import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/main.dart';

class ApplyBtn extends StatelessWidget {
  ApplyBtn({Key? key}) : super(key: key);
  var lastTimeClicked = 0;
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IgnorePointer(
          ignoring: FilePickerCtrl.to.oesFD.isEmpty &&
              FilePickerCtrl.to.ableApply.isFalse,
          child: InkWell(
            onDoubleTap: () => null,
            onTap: () {
              debugPrint('tap');
              ChartCtrl.to.updateLeftData();
              TimeSelectCtrl.to.ableTimeSelect.value = true;

              // if (ChartCtrl.to.isTypeError.isTrue) {
              //   showDialog(
              //     context: navigatorKey.currentContext!,
              //     builder: (context) => AlertDialog(
              //       title: Column(
              //         children: const [
              //           Text('All Files Delete'),
              //           Divider(
              //             color: Colors.blueGrey,
              //             indent: 6,
              //             endIndent: 6,
              //           ),
              //         ],
              //       ),
              //       content: const Text('파일 형식이 다릅니다.'),
              //       actions: <Widget>[
              //         TextButton(
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //           child: const Text('Yes'),
              //         ),
              //         TextButton(
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //           child: const Text('No'),
              //         ),
              //       ],
              //     ),
              //   );
              // }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: FilePickerCtrl.to.oesFD.isEmpty &&
                        FilePickerCtrl.to.ableApply.isFalse
                    ? Colors.grey
                    : isHover == true
                        ? Colors.blue
                        : Color(0xff5AEDCA),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              width: 60,
              child: Center(child: Text('Apply')),
            ),
          )

          ///////////////

          );
    });
  }
}
