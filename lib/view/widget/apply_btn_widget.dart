import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/main.dart';

class ApplyBtn extends StatelessWidget {
  const ApplyBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IgnorePointer(
          ignoring: FilePickerCtrl.to.oesFD.isEmpty &&
              FilePickerCtrl.to.ableApply.isFalse,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: FilePickerCtrl.to.oesFD.isEmpty &&
                        FilePickerCtrl.to.ableApply.isFalse
                    ? Colors.grey
                    : Color(0xff5AEDCA),
              ),
              onPressed: () {
                ChartCtrl.to.updateLeftData();
                TimeSelectCtrl.to.ableTimeSelect.value = true;

                if (ChartCtrl.to.isTypeError.isTrue) {
                  showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) => AlertDialog(
                      title: Column(
                        children: const [
                          Text('All Files Delete'),
                          Divider(
                            color: Colors.blueGrey,
                            indent: 6,
                            endIndent: 6,
                          ),
                        ],
                      ),
                      content: const Text('파일 형식이 다릅니다.'),
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
              },
              child: const Text(
                'Apply',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              )));
    });
  }
}
