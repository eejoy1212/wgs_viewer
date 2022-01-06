import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';

class ApplyBtn extends StatelessWidget {
  const ApplyBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IgnorePointer(
          ignoring: FilePickerCtrl.to.selectedFileUrls.isEmpty,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: FilePickerCtrl.to.selectedFileUrls.isEmpty
                    ? Colors.grey
                    : Color(0xff5AEDCA),
              ),
              onPressed: () async {
                ChartCtrl.to.leftDataMode.value = true;
                await ChartCtrl.to.updateLeftData();
                TimeSelectCtrl.to.ableTimeSelect.value = true;
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
