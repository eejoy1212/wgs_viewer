import 'dart:convert';

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:wgs_viewer/controller/chart_ctrl.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';
import 'package:wgs_viewer/view/widget/file_list_data_widget.dart';

class FilePickerCtrl extends GetxController {
  static FilePickerCtrl get to => Get.find();
  RxList<String> selectedFileName = RxList.empty(); //<String>[].obs;
  var selectedFileUrl = ''.obs;
  RxInt selectedFileNum = 0.obs;
  RxString selectedFileContent = ''.obs;
  RxList filenameData = RxList.empty();
  RxList filenamelist = RxList.empty();
  RxString fileMaxAlertMsg = ''.obs;
  List<List<dynamic>> _data = RxList.empty();
  List<List<dynamic>> _listData = RxList.empty();
  List yAxisData = RxList.empty();
  List xAxisData = RxList.empty();
  List<List<dynamic>> f1 = RxList.empty();
  List<List<dynamic>> f2 = RxList.empty();
  List<List<dynamic>> forfields = RxList.empty();
  RxBool enableRangeSelect = false.obs;
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
          var ableAddCnt = 100 - selectedFileName.length;
          selectedFileName.addAll(_fileNames.sublist(0, ableAddCnt));

          FilePickerCtrl.to.fileMaxAlertMsg.value = 'File maximum is 100';
        } else {
          selectedFileName.addAll(_fileNames);
        }
        //////////////////////////////////////////////////////1

        final input2 = File(_fileUrls[0]!).openRead();
        var d = const FirstOccurrenceSettingsDetector(
            eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
        final fields = await input2
            .transform(utf8.decoder)
            .transform(CsvToListConverter(csvSettingsDetector: d))
            .toList();
        //csv파일을 효율적으로 parsing해오는 방법(밑에거보다 효율적)

        // debugPrint('file csv data: ${fields[7][1]}');
        forfields = fields;
        List<String> aa = [];

        ///////////////////////////////////////////////////////////

        ///////////////////////////////////////////////////////////2
        final input = new File(_fileUrls[0]!).openRead();
        await input
            .map(utf8.decode)
            .transform(const LineSplitter())
            .forEach((l) {
          aa.add(l);
        });
        //파장 시작
        f1 = const CsvToListConverter().convert(aa[7]);
        f2 = const CsvToListConverter().convert(aa[8]);

        selectedFileUrl.value = _fileUrls.toString();

        //파일 리스트로 보여주는 것.
        int nn = CheckboxCtrl.to.ckb.length;
        CheckboxCtrl.to.ckb.add(
          CheckBoxModel(
            title: 'ds',
            fileName: '$nn번 파일 : ${FilePickerCtrl.to.selectedFileName[nn]} ',
            isChecked: false.obs,
            range: RangeModel(start: nn, end: nn + 2),
          ),
        );
        if (
            //예외상황
            FilePickerCtrl.to.selectedFileName.length > 100) {
          throw new Exception("파일의 최대 갯수는 100개");
        }
      }
    } catch (e) {}
  }
}
