import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

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
  RxInt idx = 0.obs;

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
    firstFields = await firstInput
        .transform(utf8.decoder)
        .transform(CsvToListConverter(csvSettingsDetector: d))
        .toList();
//파일 열렸고, 내용을 firstFields 담아 차트로 보내기
    debugPrint('오른 드롭다운 파일 1?? : $firstFields');
  }

  void SecondTimeFunc(List<String?> secondList) async {
/*
1.첫번째 드롭다운에서 파일 선택하면 열림(ㅇ)
2.시간대 선택
*/
//선택했다는 신호

    secondSignal.value = true;
    debugPrint('sig? : ${secondSignal.value}');
    debugPrint('첫번째 드롭박스에서 선택 된 파일 리스트 : $secondList');
    if (secondList.isNotEmpty) {
      secondSignal.value = true;
    }

//파일이 담긴 리스트
    final secondInput = File(secondList[0]!).openRead();
    var d = const FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
//파일말고 파일 내용이 담긴 리스트(행,열로 떼어 옴.)
    final secondFields = await secondInput
        .transform(utf8.decoder)
        .transform(CsvToListConverter(csvSettingsDetector: d))
        .toList();
//파일 열렸고, 내용을 rightData에 담아 차트로 보내기
    rightData = secondFields;
    //시간 리스트 뽑아오기, 인덱스는 왼쪽에서 열린 첫번째파일 기준
    for (var t = 7; t < 14; t++) {
      idx.value = t - 7;
      String time = FilePickerCtrl.to.forfields[t][0];
      String toConvert = '2022-01-01 12:' + time;
      final dateParse = DateTime.parse(toConvert);
      dateTime.add(dateParse);
      timeList2.add((DateTime(
                  dateTime[idx.value].year,
                  dateTime[idx.value].month,
                  dateTime[idx.value].day,
                  dateTime[idx.value].hour,
                  dateTime[idx.value].minute,
                  dateTime[idx.value].second,
                  dateTime[idx.value].millisecond)
              .difference(
                DateTime(
                    dateTime[0].year,
                    dateTime[0].month,
                    dateTime[0].day,
                    dateTime[0].hour,
                    dateTime[0].minute,
                    dateTime[0].second,
                    dateTime[0].millisecond),
              )
              .inMilliseconds
              .toDouble()) /
          1000);

      debugPrint('시간리스트 두번째거 : $timeList2');
    }
  }
}
