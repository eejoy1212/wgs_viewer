import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/model/oes_file_data_model.dart';

class FilePickerCtrl extends GetxController {
  static FilePickerCtrl get to => Get.find();
  RxString fileMaxAlertMsg = ''.obs;
  RxList<dynamic> xTimes = RxList.empty();
  RxList<dynamic> xWLs = RxList.empty();
  RxString path = ''.obs;
  List<List<dynamic>> fileData = RxList.empty(growable: true);
  //oesModel 선언
  RxList<OESFileData> oesFD = RxList.empty();

  Rx<bool> ableApply = false.obs;
  Rx<bool> allChecked = false.obs;
  RxList<dynamic> dropdownFileName = RxList.empty();
  RxList<dynamic> dropdownFileName2 = RxList.empty();
  RxList timeIdxList = RxList.empty();
  RxList<String> noFile = ['파일없음'].obs;
  RxInt idx = 0.obs;

  Future<void> selectedFileFunc() async {
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
        bool first = oesFD.isEmpty;
//파일 유효성검사

//파일 유효성검사

        List<String> _fileNames = _paths.map((e) {
          return e.name;
        }).toList();
        List<String?> _fileUrls = _paths.map((e) => e.path).toList();
        if (oesFD.length + _fileUrls.length > 100) {
          var ableAddCnt = 100 - oesFD.length;
          for (int i = 0; i < _paths.length; i++) {
            //체크박스에 추가되는 파일리스트
            oesFD.add(OESFileData(
              fileName: '${i + 1} : ' + _paths[i].name,
              filePath: _paths[i].path,
              isChecked: false.obs,
              avg: [],
            ));
//드롭박스에 추가되는 파일리스트
            dropdownFileName.add(_paths[i].name);
          }
          oesFD.sublist(0, ableAddCnt);
          FilePickerCtrl.to.fileMaxAlertMsg.value = 'File maximum is 100';
        } else {
          for (int i = 0; i < _paths.length; i++) {
            //체크박스에 추가되는 리스트
            oesFD.add(OESFileData(
              fileName: _paths[i].name,
              filePath: _paths[i].path,
              isChecked: false.obs,
              avg: [],
            ));
            //드롭박스에 추가되는 파일리스트
            dropdownFileName.add(_paths[i].name);
          }
        }
        if (first) {
          var filePath = oesFD.map((el) => el.filePath).toList();
          final input = await File(filePath.first!).openRead();
          var d = const FirstOccurrenceSettingsDetector(
              eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);

          fileData = await input
              .transform(utf8.decoder)
              .transform(CsvToListConverter(csvSettingsDetector: d))
              .toList();
          debugPrint('파일유효성검사 [0][0] : ${fileData[0][0]}');

          debugPrint('파일유효성검사 [6][0] : ${fileData[6][0]}');

          //Time포함되어있는 셀 번호
          // int timeRowSize = fileData.indexWhere((e) => e.contains('Time'));
          // int timeRowSize = 7;

          if (fileData[0][0] != 'FileFormat : 1' || fileData[6][0] != 'Time') {
            debugPrint('파일형식 다름');
            ChartCtrl.to.isTypeError.value = true;
          }
          if (fileData[0][0] == 'FileFormat : 1' || fileData[6][0] == 'Time') {
            debugPrint('올바른 파일 형식');
            FilePickerCtrl.to.xWLs
                .assignAll(fileData[7].sublist(1, fileData[7].length));
// RangeSliderCtrl.to.rsWGS.map((element) => element.rv.assign)

            // String toConvert = '2022-01-01 ' + fileData[timeRowSize + 1][0];
            String toConvert = fileData[7][0];
            final DateTime firstTime = DateTime.parse(toConvert);
            for (var i = 7; i < fileData.length; i++) {
              // String toConvert = '2022-01-01 ' + fileData[i][0];
              String toConvert = fileData[i][0];
              final DateTime dateTime = DateTime.parse(toConvert);
              FilePickerCtrl.to.xTimes.add((DateTime(
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
              TimeSelectCtrl.to.timeIdxList = FilePickerCtrl.to.xTimes;

              debugPrint('x축갯수  ${TimeSelectCtrl.to.timeIdxList.length}');
            }
          }
        }
      }
    } catch (e) {}
  }
}
