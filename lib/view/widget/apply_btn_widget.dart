import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/chart_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

class ApplyBtn extends StatelessWidget {
  const ApplyBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IgnorePointer(
          ignoring: FilePickerCtrl.to.selectedFileName.isEmpty,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: FilePickerCtrl.to.selectedFileName.isEmpty
                    ? Colors.grey
                    : Color(0xff5AEDCA),
              ),
              onPressed: () async {
                ChartCtrl.to.leftDataMode.value = true;
                await ChartCtrl.to.updateLeftData();
                RangeSliderCtrl.to.minMaxFunc();
              },
              child: const Text(
                'Apply',
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold),
              )));
    });
  }
}
