import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';

class FilePickerCtrl extends GetxController {
  static FilePickerCtrl get to => Get.find();
  RxList<String> selectedFileName = RxList.empty(); //<String>[].obs;
  List<String?> selectedFileUrls = RxList.empty();
  var selectedFileUrl = ''.obs;
  RxInt selectedFileNum = 0.obs;
  RxString selectedFileContent = ''.obs;
  RxList filenameData = RxList.empty();
  RxList filenamelist = RxList.empty();
  RxString fileMaxAlertMsg = ''.obs;
  List yAxisData = RxList.empty();
  List xAxisData = RxList.empty();
  List<List<dynamic>> f1 = RxList.empty();
  List<List<dynamic>> f2 = RxList.empty();
  List<List<dynamic>> forfields = RxList.empty();
  RxList<dynamic> firstLine = RxList.empty();
  RxList<dynamic> testLine = RxList.empty();
  Rx<RangeValues> rv = const RangeValues(0, 0).obs;
  double vStart = 0.0;
  double vEnd = 0.0;
  RxBool enableRangeSelect = false.obs;
  RxInt maxIdx = 0.obs;
  List<String> timeAxis = RxList.empty();
  //RxList<dynamic> timeLine = RxList.empty();
  RxList<CheckBoxModel> ckbfirstList = RxList.empty();
  List<List<dynamic>> fields = RxList.empty();
  List<List<String?>> inputList = RxList.empty();
  List<String?> fileUrls = RxList.empty();

  void init() {
    for (var i = 0; i < 9; i++) {}
  }

  //파일셀렉트 함수

  Future<void> selectedFileFunc() async {
    enableRangeSelect.value = true;
    try {
      List<PlatformFile>? _paths;
      _paths = (await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['csv'],
              allowMultiple: true,
              withData: true,
              withReadStream: true,
              dialogTitle: 'File select'))
          ?.files;
      if (_paths != null) {
        bool first = selectedFileName.isEmpty;
        List<String> _fileNames = _paths.map((e) => e.name).toList();
        fileUrls = _paths.map((e) => e.path).toList();
        if (selectedFileName.length + _fileNames.length > 100) {
          var ableAddCnt = 100 - selectedFileUrls.length;
          selectedFileUrls.addAll(fileUrls.sublist(0, ableAddCnt));

          FilePickerCtrl.to.fileMaxAlertMsg.value = 'File maximum is 100';
        } else {
          selectedFileName.addAll(_fileNames);
          //나중에 fileName을 url로 바꾸자
          selectedFileUrls.addAll(fileUrls);
        }
        debugPrint('fileName : $selectedFileName');
        debugPrint('fileurls : $selectedFileUrls');
        //원래있던 파일불러오는거
        // final input2 = File(_fileUrls[selectedFileUrls.length - 1]!).openRead();
        // var d = const FirstOccurrenceSettingsDetector(
        // eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
        // final fields = await input2
        // .transform(utf8.decoder)
        // .transform(CsvToListConverter(csvSettingsDetector: d))
        // .toList();
        // forfields = fields;
        if (first) {
          List<List<dynamic>> fileData = RxList.empty();
          final input2 = await File(selectedFileName[0]).openRead();
          var d = const FirstOccurrenceSettingsDetector(
              eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
          fileData = await input2
              .transform(utf8.decoder)
              .transform(CsvToListConverter(csvSettingsDetector: d))
              .toList();
          String toConvert = '2022-01-01 ' + fileData[7][0];
          final DateTime firstTime = DateTime.parse(toConvert);
          for (var i = 7; i < fileData.length; i++) {
            String toConvert = '2022-01-01 ' + fileData[i][0];
            final DateTime dateTime = DateTime.parse(toConvert);
            TimeSelectCtrl.to.timeIdxList.add((DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        dateTime.hour,
                        dateTime.minute,
                        dateTime.second,
                        dateTime.millisecond)
                    .difference(
                      DateTime(
                          firstTime.year,
                          firstTime.month,
                          firstTime.day,
                          firstTime.hour,
                          firstTime.minute,
                          firstTime.second,
                          firstTime.millisecond),
                    )
                    .inMilliseconds
                    .toDouble()) /
                1000);
          }
          debugPrint(
              '첫번째 파일의 시간 인덱스가 떼어와 졌나?? : ${TimeSelectCtrl.to.timeIdxList}');
        }

        //파일 열 개 까지 불러오기

        debugPrint('파일 몇 개 선택?? :${selectedFileUrls.length}');
        // for (var f = 0; f < fileUrls.length; f++) {
        //   final input2 = await File(fileUrls[f]!).openRead();

        //   var d = const FirstOccurrenceSettingsDetector(
        //       eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
        //   fields = await input2
        //       .transform(utf8.decoder)
        //       .transform(CsvToListConverter(csvSettingsDetector: d))
        //       .toList();
        //   forfields = fields;
        //   debugPrint('인풋 for문 몇번? : $f');
        // }
        debugPrint(
            '파일 열개까지 불러와야함: 리스트 길이 ${fileUrls.length} 이고 리스트항목은 $fileUrls');
//레인지에 쓸거
        //firstLine.assignAll(fields[6].sublist(1, fields[6].length));
//시간축 떼어오기
        //timeLine.assignAll(fields[0].sublist(7, fields[7].length)[0]);
        // timeLine.value = fields.sublist(7, fields[7].length)[0];
        // maxIdx.value = firstLine.indexOf(867.9015275);
        print(
            'FilePickerCtrl.to.firstLine.last ${FilePickerCtrl.to.firstLine.last}');
        print('?? :  ${maxIdx}');
        // if (FilePickerCtrl.to.selectedFileName.length > 100) {
        //   throw new Exception("파일의 최대 갯수는 100개");
        // }
      }
    } catch (e) {}
  }
}
