import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/model/oes_file_data_model.dart';

class FileSelectDropDownCtrl extends GetxController {
  static FileSelectDropDownCtrl get to => Get.find();
  RxBool firstSignal = false.obs;
  RxBool secondSignal = false.obs;
  List<String?> firstList = List.empty();
  List<String?> secondList = List.empty();
  List<List<dynamic>> rightData = RxList.empty();
  RxList<dynamic> timeList2 = RxList.empty();
  RxList<DateTime> dateTime = RxList.empty();
  List<List<dynamic>> firstFields = RxList.empty();
  List<List<dynamic>> secondFields = RxList.empty();
  List<OESFileData> selected = List.filled(2, OESFileData.init());
  RxInt idx = 0.obs;

//   Future<bool> fff({required OESFileData f}) async {
//     //debugPrint('fff ${f.fileData}');
//     return true;

// //파일 열렸고, 내용을 firstFields 담아 차트로 보내기
//   }

  Future<void> firstTimeFunc({required List<OESFileData?> firstList}) async {
    firstSignal.value = true;
    debugPrint('sig? : ${firstSignal.value}');
    debugPrint('첫번째 드롭박스에서 선택 된 파일 리스트 : $firstList');
    if (firstList.isNotEmpty) {
      firstSignal.value = true;
    }

//파일이 담긴 리스트
    firstList
        .forEach((el) => FilePickerCtrl.to.dropdownFileName.add(el?.filePath));
    final firstInput = File(FilePickerCtrl.to.dropdownFileName[0]!).openRead();
    var d = const FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
//파일말고 파일 내용이 담긴 리스트(행,열로 떼어 옴.)
    firstFields = await firstInput
        .transform(utf8.decoder)
        .transform(CsvToListConverter(csvSettingsDetector: d))
        .toList();
//파일 열렸고, 내용을 firstFields 담아 차트로 보내기
  }

  Future<void> secondTimeFunc({required List<OESFileData?> secondList}) async {
    secondSignal.value = true;
    if (secondList.isNotEmpty) {
      secondSignal.value = true;
    }
//
//파일이 담긴 리스트
    secondList
        .forEach((el) => FilePickerCtrl.to.dropdownFileName.add(el?.filePath));
    final secondInput = File(FilePickerCtrl.to.dropdownFileName[0]!).openRead();
    var d = const FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
//파일말고 파일 내용이 담긴 리스트(행,열로 떼어 옴.)
    secondFields = await secondInput
        .transform(utf8.decoder)
        .transform(CsvToListConverter(csvSettingsDetector: d))
        .toList();
//파일 열렸고, 내용을 rightData에 담아 차트로 보내기

    debugPrint('secondFields :$secondFields');
  }
}
