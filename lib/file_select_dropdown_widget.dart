import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

class FileSelectDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> isEmptyList = ['파일을 불러주세요'];

    return Obx(() => DropdownSearch.multiSelection(
          mode: Mode.MENU,
          // showSelectedItems: true,
          showSearchBox: true,
          items: FilePickerCtrl.to.selectedFileName.isEmpty
              ? isEmptyList
              : FilePickerCtrl.to.selectedFileUrls,
          onChanged: FileSelectDropDownCtrl.to.firstTimeFunc,
        ));
  }
}

class FileSelectDropDownCtrl extends GetxController {
  static FileSelectDropDownCtrl get to => Get.find();
  RxBool firstSignal = false.obs;
  RxBool secondSignal = false.obs;
  List<String?> firstList = List.empty();

  void firstTimeFunc(List<String?> firstList) async {
/*
1.첫번째 드롭다운에서 파일 선택하면 열림(ㅇ)
2.시간대 선택
*/
//선택했다는 신호

    firstSignal.value = true;
    debugPrint('sig? : ${firstSignal.value}');
    debugPrint('onChanged string :$firstList');

    final firstInput = File(firstList[0]!).openRead();
    var d = const FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
    final firstFields = await firstInput
        .transform(utf8.decoder)
        .transform(CsvToListConverter(csvSettingsDetector: d))
        .toList();
    //파일 열렸고, 이제 이거 차트로 내보내기.
  }
}
