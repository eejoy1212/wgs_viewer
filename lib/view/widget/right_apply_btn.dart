import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';

class RightApplyBtn extends StatelessWidget {
  const RightApplyBtn({Key? key}) : super(key: key);

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
              onPressed: () {
                if (FileSelectDropDownCtrl.to.rightData.isNotEmpty) {
                  RightChartCtrl.to.updateRightData();
                }

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
