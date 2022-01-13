import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';

class RightApplyBtn extends StatelessWidget {
  const RightApplyBtn({Key? key, required this.idx}) : super(key: key);
  final int idx;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IgnorePointer(
          ignoring: FilePickerCtrl.to.oesFD.isEmpty ||
              FileSelectDropDownCtrl.to.applySignal0.isFalse,
          // FileSelectDropDownCtrl.to.selected[idx].fileName == '',
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: FilePickerCtrl.to.oesFD.isEmpty ||
                        FileSelectDropDownCtrl.to.applySignal0.isFalse
                    // FileSelectDropDownCtrl.to.selected[idx].fileName == ''
                    ? Colors.grey
                    : Color(0xff5AEDCA),
              ),
              onPressed: () async {
                //오른쪽 함수 부르는거
                TimeSelectCtrl.to.timeSelected.value = true;
                await RightChartCtrl.to.updateRightData(idx);
                // RangeSliderCtrl.to.minMaxFunc();
              },
              child: const Text(
                'Apply',
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold),
              )));
    });
  }
}
