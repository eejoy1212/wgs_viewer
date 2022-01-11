import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';
import 'package:wgs_viewer/model/oes_file_data_model.dart';

class FilePickerCtrl extends GetxController {
  static FilePickerCtrl get to => Get.find();
  RxList<String> selectedFileName = RxList.empty();
  List<String?> selectedFileUrls = RxList.empty();
  RxString fileMaxAlertMsg = ''.obs;
  RxList<dynamic> firstLine = RxList.empty();
  RxString path = ''.obs;
  List<List<dynamic>> fileData = RxList.empty(growable: true);
  //oesModel 선언
  RxList<OESFileData> oesFD = RxList.empty();
  Rx<bool> ableApply = false.obs;
  Rx<bool> allChecked = false.obs;
  RxList<String> dropdownFileName = RxList.empty();
  RxList timeIdxList = RxList.empty();
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
      debugPrint('_path가 ${_paths != null}');
      if (_paths != null) {
        bool first = oesFD.isEmpty;

        List<String> _fileNames = _paths.map((e) {
          return e.name;
        }).toList();
        List<String?> _fileUrls = _paths.map((e) => e.path).toList();
        if (oesFD.length + _fileUrls.length > 100) {
          var ableAddCnt = 100 - oesFD.length;
          for (int i = 0; i < _paths.length; i++) {
            oesFD.add(OESFileData(
                fileName: _paths[i].name,
                filePath: _paths[i].path,
                isChecked: false.obs));
          }
          //왜 map하면 안돼..?
          //한꺼번에 추가?
          // _fileUrls.forEach((urls) {
          //   _fileNames.forEach((names) {
          //     oesFD.add(OESFileData(
          //         fileName: names, filePath: urls, isChecked: false.obs));
          //   });
          // });

          oesFD.sublist(0, ableAddCnt);
          debugPrint('oesFD : $oesFD');
          FilePickerCtrl.to.fileMaxAlertMsg.value = 'File maximum is 100';
        } else {
          // _fileUrls.forEach((urls) {
          //   _fileNames.forEach((names) {
          //     oesFD.add(OESFileData(
          //         fileName: names, filePath: urls, isChecked: false.obs));
          //   });
          // });
          for (int i = 0; i < _paths.length; i++) {
            oesFD.add(OESFileData(
                fileName: _paths[i].name,
                filePath: _paths[i].path,
                isChecked: false.obs));
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
          debugPrint('fileData : ${fileData.length}');
////////////////////여까지 함
          debugPrint('fileData 내용 : $fileData');

          //Time포함되어있는 셀 번호
          int timeRowSize = fileData.indexWhere((e) => e.contains('Time')) + 1;
          //int timeRowSize = 7;
          firstLine.assignAll(
              fileData[timeRowSize].sublist(1, fileData[timeRowSize].length));
          debugPrint('firstLine : $firstLine');
          String toConvert = '2022-01-01 ' + fileData[timeRowSize][0];
          final DateTime firstTime = DateTime.parse(toConvert);
          for (var i = timeRowSize; i < fileData.length; i++) {
            String toConvert = '2022-01-01 ' + fileData[i][0];

            final DateTime dateTime = DateTime.parse(toConvert);

            TimeSelectCtrl.to.timeIdxList.addIf(
                firstLine.isNotEmpty,
                (DateTime(
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

            debugPrint('timeIdxList : ${TimeSelectCtrl.to.timeIdxList}');
          }
        }
      }
    } catch (e) {}
  }

  dropdownItemsFunc() {
    FilePickerCtrl.to.oesFD
        .forEach((el) => FilePickerCtrl.to.dropdownFileName.add(el.fileName));

    debugPrint('드롭다운 파일 이름 : ${FilePickerCtrl.to.dropdownFileName}');
  }
}
