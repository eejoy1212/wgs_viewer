import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
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
  Future<void> selectedFileFunc() async {
    try {
//파일 url오픈 연습
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'output-file.csv',
      );

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

//
        if (selectedFileName.length + _fileNames.length > 100) {
          var ableAddCnt = 100 - selectedFileName.length;
          selectedFileName.addAll(_fileNames.sublist(0, ableAddCnt));
        } else {
          selectedFileName.addAll(_fileNames);
        }
        //
        var _fileUrls = _paths.map((e) => e.path);
        selectedFileUrl.value = _fileUrls.toString();

        print('$_paths');
        print('paths ${_fileNames}');
        print('총 파일갯수 :\n${selectedFileName.length}');
        print('파일 url :\n${selectedFileUrl.value}');
        if (
            //예외상황
            FilePickerCtrl.to.selectedFileName.length > 100) {
          throw new Exception("파일의 최대 갯수는 100개");
        }
      }
    } catch (e) {
      FilePickerCtrl.to.fileMaxAlertMsg.value = 'File maximum is 100';
      //예외상황일 때 발생시킬 상황
      print('파일 최대 갯수는 100개입니다.');
      print('파일을 선택 해 주세요 : $e');
    }
  }
}
