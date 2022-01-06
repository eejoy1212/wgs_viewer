import 'dart:io';

import 'package:csv/csv_settings_autodetection.dart';
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
                //파일 열 개 까지 불러오기

                debugPrint(
                    '파일 몇 개 선택?? :${FilePickerCtrl.to.selectedFileUrls.length}');
                // for (var f = 0; f <
                // FilePickerCtrl.to.
                // fileUrls.length; f++) {
                //   final input2 = await File(
                //     FilePickerCtrl.to.
                //     fileUrls[f]!).openRead();

                //   var d = const FirstOccurrenceSettingsDetector(
                //       eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);

                //  FilePickerCtrl.to.
                //   fields = await input2
                //       .transform(utf8.decoder)
                //       .transform(CsvToListConverter(csvSettingsDetector: d))
                //       .toList();
                //   forfields = fields;
                //   debugPrint('인풋 for문 몇번? : $f');
                // }
                // debugPrint(
                //     '파일 열개까지 불러와야함: 리스트 길이 ${fileUrls.length} 이고 리스트항목은 $fileUrls');
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
