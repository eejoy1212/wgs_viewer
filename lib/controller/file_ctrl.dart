import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class FilePickerCtrl extends GetxController {
  static FilePickerCtrl get to => Get.find();
  RxList<String?> selectedFileName = RxList.empty();
  RxInt selectedFileNum = 0.obs;
  Future<void> uploadFile() async {
    // print(FilePickerCtrl.to.selectedFileNum.value > 0
    //     ? '선택된 파일명 : ${FilePickerCtrl.to.selectedFileName[FilePickerCtrl.to.selectedFileNum.value - 1]}'
    //     : '파일 없음.');
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['csv', 'txt'],
          allowMultiple: true,
          withData: true,
          dialogTitle: 'File select');

      if (result != null) {
        // var result = await FilePicker.platform.getDirectoryPath();
        selectedFileName.value = result.names;
        selectedFileNum.value = result.count;
        print(
            '\nfilepicker name result : \n${FilePickerCtrl.to.selectedFileName.value}');
        print('\nfilepicker file num result : \n${result.count}');
      }
    } catch (e) {
      print('파일을 선택 해 주세요 : $e');
    }
  }
}
