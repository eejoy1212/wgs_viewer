import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/ing/list_test.dart';

class FilePickerCtrl extends GetxController {
  static FilePickerCtrl get to => Get.find();
  RxList<String?> selectedFileName = RxList.empty();
  RxInt selectedFileNum = 0.obs;
  RxString selectedFileContent = ''.obs;
  Future<void> selectedFileFunc() async {
    // print(FilePickerCtrl.to.selectedFileNum.value > 0
    //     ? '선택된 파일명 : ${FilePickerCtrl.to.selectedFileName[FilePickerCtrl.to.selectedFileNum.value - 1]}'
    //     : '파일 없음.');
    ListCtrl.to.filenamesave();
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['csv', 'txt'],
          allowMultiple: true,
          withData: true,
          withReadStream: true,
          dialogTitle: 'File select');

      if (result != null) {
        // var result = await FilePicker.platform.getDirectoryPath();
        selectedFileName.value = result.names;
        selectedFileNum.value = result.count;
        selectedFileContent.value = result.files.toString();
        print(
            '\nfilepicker name result : \n${FilePickerCtrl.to.selectedFileName}');
        print(
            '\nfilepicker file num result : \n${FilePickerCtrl.to.selectedFileName.length}');
        print(
            '\nfilepicker file content result : \n${FilePickerCtrl.to.selectedFileContent.value}');
      }
    } catch (e) {
      print('파일을 선택 해 주세요 : $e');
    }
  }
}
