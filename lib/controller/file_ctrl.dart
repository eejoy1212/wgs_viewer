import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
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
  Rx<RangeValues> rv = const RangeValues(0, 0).obs;
  double vStart = 0.0;
  double vEnd = 0.0;
  RxBool enableRangeSelect = false.obs;
  RxInt maxIdx = 0.obs;
  List<String> timeAxis = RxList.empty();
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
        List<String> _fileNames = _paths.map((e) => e.name).toList();
        List<String?> _fileUrls = _paths.map((e) => e.path).toList();
        if (selectedFileName.length + _fileNames.length > 100) {
          var ableAddCnt = 100 - selectedFileUrls.length;
          selectedFileUrls.addAll(_fileUrls.sublist(0, ableAddCnt));

          FilePickerCtrl.to.fileMaxAlertMsg.value = 'File maximum is 100';
        } else {
          selectedFileName.addAll(_fileNames);
          //나중에 fileName을 url로 바꾸자
          selectedFileUrls.addAll(_fileUrls);
        }
        debugPrint('fileName : $selectedFileName');
        debugPrint('fileurls : $selectedFileUrls');
        final input2 = File(_fileUrls[selectedFileUrls.length - 1]!).openRead();
        var d = const FirstOccurrenceSettingsDetector(
            eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
        final fields = await input2
            .transform(utf8.decoder)
            .transform(CsvToListConverter(csvSettingsDetector: d))
            .toList();
        forfields = fields;
//레인지에 쓸거
        firstLine.assignAll(fields[6].sublist(1, fields[6].length));
        print('firstLine ${firstLine.length}');
        maxIdx.value = firstLine.indexOf(867.9015275);
        print(
            'FilePickerCtrl.to.firstLine.last ${FilePickerCtrl.to.firstLine.last}');
        print('?? :  ${maxIdx}');
        int nn = CheckboxCtrl.to.ckb.length;
        List<CheckBoxModel> ckbfirstList = [];
        ckbfirstList.add(
          CheckBoxModel(
            title: 'ds',
            fileName: '$nn번 파일 : ${FilePickerCtrl.to.selectedFileUrls[nn]} ',
            isChecked: false.obs,
            range: RangeModel(start: nn, end: nn + 2),
          ),
        );
        CheckboxCtrl.to.ckb.addAll(ckbfirstList);
        if (FilePickerCtrl.to.selectedFileName.length > 100) {
          throw new Exception("파일의 최대 갯수는 100개");
        }
      }
    } catch (e) {}
  }
}
