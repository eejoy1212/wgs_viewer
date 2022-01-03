import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FileSelectDropDownCtrl extends GetxController {
  static FileSelectDropDownCtrl get to => Get.find();
  RxBool firstSignal = false.obs;
  RxBool secondSignal = false.obs;
  List<String?> firstList = List.empty();
  List<List<dynamic>> rightData = RxList.empty();

  void firstTimeFunc(List<String?> firstList) async {
/*
1.첫번째 드롭다운에서 파일 선택하면 열림(ㅇ)
2.시간대 선택
*/
//선택했다는 신호

    firstSignal.value = true;
    debugPrint('sig? : ${firstSignal.value}');
    debugPrint('첫번째 드롭박스에서 선택 된 파일 리스트 : $firstList');
    if (firstList.isNotEmpty) {
      firstSignal.value = true;
    }

//파일이 담긴 리스트
    final firstInput = File(firstList[0]!).openRead();
    var d = const FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
//파일말고 파일 내용이 담긴 리스트(행,열로 떼어 옴.)
    final firstFields = await firstInput
        .transform(utf8.decoder)
        .transform(CsvToListConverter(csvSettingsDetector: d))
        .toList();
//파일 열렸고, 내용을 rightData에 담아 차트로 보내기
    rightData = firstFields;
  }
}
