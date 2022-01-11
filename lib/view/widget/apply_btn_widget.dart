import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';

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
              onPressed: () async {
                await ChartCtrl.to.updateLeftData();
                TimeSelectCtrl.to.ableTimeSelect.value = true;
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
