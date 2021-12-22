import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/view/widget/file_list_data_widget.dart';

class FilePickerCtrl extends GetxController {
  static FilePickerCtrl get to => Get.find();
  RxList<String> selectedFileName = RxList.empty(); //<String>[].obs;
  RxInt selectedFileNum = 0.obs;
  RxString selectedFileContent = ''.obs;
  RxList filenameData = RxList.empty();
  RxList filenamelist = RxList.empty();
  Future<void> selectedFileFunc() async {
    try {
      // final FilePickerResult? result = await FilePicker.platform.pickFiles(
      //     type: FileType.custom,
      //     allowedExtensions: ['csv'],
      //     allowMultiple: true,
      //     withData: true,
      //     withReadStream: true,
      //     dialogTitle: 'File select');
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
        selectedFileName.addAll(_fileNames);
        print('paths $_fileNames');
      }

      // if (result != null) {
      //   //addAll->원래거 보존하고 뒤에 추가
      //   List<String> fff = ['wefwef', 'zxcszd'];
      //   selectedFileName.addAll(fff);
      //   //selectedFileName.addAll(result.names);

      //   selectedFileNum.value = result.count;
      //   selectedFileContent.value = result.files.toString();

      //   print(
      //       '\nfilepicker name result : \n${result.names}\n 여태 선택된 모든 파일 : \n${FilePickerCtrl.to.selectedFileName}');

      //   print(
      //       '\nfilepicker file num result : \n${FilePickerCtrl.to.selectedFileName.length}');
      //   print(
      //       '\nfilepicker file content result : \n${FilePickerCtrl.to.selectedFileContent.value}');
      // }
    } catch (e) {
      print('파일 최대 갯수는 100개입니다.');
      print('파일을 선택 해 주세요 : $e');
    }
  }
}
