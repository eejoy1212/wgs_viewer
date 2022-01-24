import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/main.dart';
import 'package:wgs_viewer/model/oes_file_data_model.dart';
import 'package:wgs_viewer/view/widget/error_dialog_widget.dart';

class FilePickerCtrl extends GetxController {
  static FilePickerCtrl get to => Get.find();
  RxString fileMaxAlertMsg = ''.obs;
  RxList<dynamic> xTimes = RxList.empty();
  RxList<dynamic> xWLs = RxList.empty();
  // RxString path = ''.obs;
  // List<List<dynamic>> fileData = RxList.empty(growable: true);
  //oesModel 선언
  RxList<OESFileData> oesFD = RxList.empty();

  Rx<bool> ableApply = false.obs;
  Rx<bool> allChecked = false.obs;
  RxList<dynamic> dropdownFileName = RxList.empty();
  RxList<dynamic> dropdownFileName2 = RxList.empty();
  RxList timeIdxList = RxList.empty();
  RxList<String> noFile = ['파일없음'].obs;
  RxInt idx = 0.obs;
  /*
  1. isError==1->시간축떼어오기 실패
  1. isError==2->파일타입에러
  */
  RxInt isError = 0.obs;
  static Future<List<dynamic>> computeReadFileFormat(
      List<PlatformFile> paths) async {
    List<PlatformFile>? fileFormatPaths = [];
    if (paths != null) {
      List<String> _fileNames = paths.map((e) {
        return e.name;
      }).toList();

      for (var path in paths) {
        final input = File(path.name).openRead();
        var d = const FirstOccurrenceSettingsDetector(
            eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
        List<List<dynamic>> fileData = [];
        fileData = await input
            .transform(utf8.decoder)
            .transform(CsvToListConverter(csvSettingsDetector: d))
            .toList();
        if (fileData.length > 7) {
          if ((fileData[6][0] == 'Time') &&
              (fileData[0][0] == 'FileFormat : 1')) {
            fileFormatPaths.add(path);
          }
        }
      }
    }

    return fileFormatPaths;
  }

  // List<PlatformFile> _paths = [];
  Future readFileFormat(List<PlatformFile> paths) async {
    // _paths=
    return await compute(computeReadFileFormat, paths);
  }

  Future<List<List<dynamic>>> readFirstFile(String path) async {
    return await compute(computeReadFirstFile, path);
  }

  static Future<List<List<dynamic>>> computeReadFirstFile(String path) async {
    final input = await File(path).openRead();
    var d = const FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
    List<List<dynamic>> _fileData = [];
    _fileData = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter(csvSettingsDetector: d))
        .toList();

    //Time포함되어있는 셀 번호
    int fileFormatRowSize =
        _fileData.indexWhere((e) => e.contains('FileFormat : 1'));
    int timeRowSize = _fileData.indexWhere((e) => e.contains('Time'));
    List<dynamic> rtXWLs = [];
    List<dynamic> rtXTimes = [];
    if (fileFormatRowSize == 0 && timeRowSize == 6) {
      debugPrint('파일형식 맞음, 시간축 떼어오기 성공');

      rtXWLs.assignAll(
          _fileData[timeRowSize].sublist(1, _fileData[timeRowSize].length));
      String dtFormat = DateFormat('yyyy-MM-dd ').format(DateTime.now());
      debugPrint('시간 : $dtFormat ');
      String toConvert = dtFormat + _fileData[7][0];
      final DateTime firstTime = DateTime.parse(toConvert);

      for (var i = 7; i < _fileData.length; i++) {
        String toConvert = dtFormat + _fileData[i][0];
        debugPrint('toConvert : $toConvert');
        final DateTime dateTime = DateTime.parse(toConvert);

        rtXTimes.add((DateTime(
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
        // debugPrint('x축갯수  ${TimeSelectCtrl.to.timeIdxList.length}');
      }
    }
    return [rtXTimes, rtXWLs];
  }

  Future<bool> selectedFileFunc() async {
    try {
      List<PlatformFile>? paths;
      paths = (await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['csv'],
              allowMultiple: true,
              withData: true,
              withReadStream: true,
              dialogTitle: 'File select'))
          ?.files;

      if (paths != null) {
        bool first = oesFD.isEmpty;
//파일 유효성검사
//compute로 리턴해야 할 값==fileData[6][0]&&fileData[0][0]

//파일 유효성검사
        List<PlatformFile> _paths = await readFileFormat(paths);
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
          // FilePickerCtrl.to.fileMaxAlertMsg.value = 'File maximum is 100';
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
          List<List<dynamic>> rt = [];
          rt.addAll(await readFirstFile(filePath.first!));
          FilePickerCtrl.to.xTimes.value = rt[0];
          FilePickerCtrl.to.xWLs.value = rt[1];
          TimeSelectCtrl.to.timeIdxList = FilePickerCtrl.to.xTimes;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
