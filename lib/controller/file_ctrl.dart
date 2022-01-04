import 'dart:convert';

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';
import 'package:wgs_viewer/view/widget/file_list_data_widget.dart';

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
  Rx<RangeValues> rv = RangeValues(0, 0).obs;
  double vStart = 0.0;
  double vEnd = 0.0;
  RxBool enableRangeSelect = false.obs;
  RxInt maxIdx = 0.obs;
  List<String> timeAxis = RxList.empty();
  Future<void> selectedFileFunc() async {
    //파일 셀렉트 버튼 누르면, 파장선택 가능하게 하기
    enableRangeSelect.value = true;
    //시리즈 슛자
    try {
//
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
          // var ableAddCnt = 100 - selectedFileName.length;
          var ableAddCnt = 100 - selectedFileUrls.length;
          // selectedFileName.addAll(_fileNames.sublist(0, ableAddCnt));
          selectedFileUrls.addAll(_fileUrls.sublist(0, ableAddCnt));

          FilePickerCtrl.to.fileMaxAlertMsg.value = 'File maximum is 100';
        } else {
          selectedFileName.addAll(_fileNames);
          //나중에 fileName을 url로 바꾸자
          selectedFileUrls.addAll(_fileUrls);
        }
        //////////////////////////////////////////////////////1
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
        // for (var i = 7; i <

        // fields[0].last.; i++) {
        // fields[0]
        // }

        print('?? :  ${maxIdx}');
        //파일 리스트로 보여주는 것.

        // int nn = CheckboxCtrl.to.ckb.length;
        int nn = CheckboxCtrl.to.ckb.length;
        //addAll하려면 리스트에 담고 해줘야하므로 먼저 리스트에 추가
        List<CheckBoxModel> ckbfirstList = [];
        ckbfirstList.add(
          CheckBoxModel(
            title: 'ds',
            fileName: '$nn번 파일 : ${FilePickerCtrl.to.selectedFileName[nn]} ',
            isChecked: false.obs,
            range: RangeModel(start: nn, end: nn + 2),
          ),
        );
        //addAll하면, 파일선택 여러개 하면 한번에 다 리스트에 추가돼야
        CheckboxCtrl.to.ckb.addAll(ckbfirstList);

        // CheckboxCtrl.to.ckb.add(
        //   CheckBoxModel(
        //     title: 'ds',
        //     fileName: '$nn번 파일 : ${FilePickerCtrl.to.selectedFileName[nn]} ',
        //     isChecked: false.obs,
        //     range: RangeModel(start: nn, end: nn + 2),
        //   ),
        // );
        if (
            //예외상황
            FilePickerCtrl.to.selectedFileName.length > 100) {
          throw new Exception("파일의 최대 갯수는 100개");
        }
      }
    } catch (e) {}
  }
}
