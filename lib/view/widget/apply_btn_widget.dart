import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
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
// if (CheckboxCtrl.to.isChecked.isTrue
                // ) {
// for (var i = 0; i < 10; i++) {
                //  final input =await File()
                // FilePickerCtrl.to.selectedFileUrls
// }
//
// }
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
                // RangeSliderCtrl.to.minMaxFunc();

                // int idx = CheckboxCtrl.to.ckb
                //     .indexWhere((element) => element.isChecked.isTrue);
                //    debugPrint('idx : $idx');
//File Select 버튼 눌렀을 때, 리스트로 Url을 가지고 있다가,  apply btn눌렀을 때, 체크박스가 트루면 파일 오픈(.openRead())
                // if (CheckboxCtrl.to.isChecked.isTrue) {
                //   for (var i = 0;
                //       i < FilePickerCtrl.to.selectedFileUrls.length;
                //       i++) {
                //     final input =
                //         await File(FilePickerCtrl.to.selectedFileUrls[i]!)
                //             .openRead();
                //     var d = const FirstOccurrenceSettingsDetector(
                //         eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
                //     var fields = await input
                //         .transform(utf8.decoder)
                //         .transform(CsvToListConverter(csvSettingsDetector: d))
                //         .toList();
                //     List<List<List<dynamic>>> fieldsList = [];
                //     fieldsList[i].add(fields);
                //     debugPrint('for몇번? : ${i}');
                //   }
                // } else {}

                // .removeWhere((element) => element.isChecked.isTrue);
              },
              child: const Text(
                'Apply',
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold),
              )));
    });
  }
}
