import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

class ListCtrl extends GetxController {
  static ListCtrl get to => Get.find();
  RxList filenameData = RxList.empty();
  RxList filenamelist = RxList.empty();
  filenamesave() {
    filenameData.addAll(Get.find<ListCtrl>().filenamelist);
  }

  fileStack() {
    filenamesave();
    ListCtrl.to.filenamelist.add(FilePickerCtrl
        .to.selectedFileName[FilePickerCtrl.to.selectedFileName.length - 1]);
  }
}

class ListTest extends GetView<ListCtrl> {
  final ScrollController scrollCtrl = ScrollController();
  ListTest({Key? key}) : super(key: key);
//로그뷰 참고
  @override
  Widget build(BuildContext context) {
    print('???? : ${FilePickerCtrl.to.selectedFileName}');
    return Obx(() {
      return SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
              child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            controller: scrollCtrl,
            itemCount: FilePickerCtrl.to.selectedFileName.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Column(
                  children: [
                    Text(
                      '${FilePickerCtrl.to.selectedFileName[index]}',
                      style: TextStyle(
                        color: index ==
                                FilePickerCtrl.to.selectedFileName.length - 1
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
        ),
      );
    });
  }
}
