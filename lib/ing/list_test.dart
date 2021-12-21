import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';

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
  final allChecked = CheckBoxModel(title: 'All Select : ');
//로그뷰 참고
  @override
  Widget build(BuildContext context) {
    print('???? : ${FilePickerCtrl.to.selectedFileName}');
    return Obx(() {
      return SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
              child: Column(
            children: [
              ListTile(
                horizontalTitleGap: 200,
                onTap: () => onAllClicked(allChecked),
                title: Row(
                  children: [
                    Text(
                      allChecked.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Checkbox(
                      checkColor: Colors.black,
                      value: allChecked.value,
                      onChanged: (value) => onAllClicked(allChecked),
                    ),
                  ],
                ),
                leading: Text(
                  'File name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              ListView.builder(
                reverse: true,
                shrinkWrap: true,
                controller: scrollCtrl,
                itemCount: FilePickerCtrl.to.selectedFileName.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      onTap: () {
                        CheckBoxCtrl.to.isChecked.value =
                            !CheckBoxCtrl.to.isChecked.value;
                      },
                      title: Checkbox(
                        checkColor: Colors.black,
                        value: CheckBoxCtrl.to.isChecked.value,
                        onChanged: (value) {
                          CheckBoxCtrl.to.isChecked.value =
                              !CheckBoxCtrl.to.isChecked.value;
                        },
                      ),
                      leading: Text(
                        '${FilePickerCtrl.to.selectedFileName[index]}',
                        style: TextStyle(
                          color: index ==
                                  FilePickerCtrl.to.selectedFileName.length - 1
                              ? Colors.red
                              : Colors.black,
                        ),
                      ));
                },
              ),
            ],
          )),
        ),
      );
    });
  }

  onAllClicked(CheckBoxModel ckbItem) {
    final newValue = !ckbItem.value;
    // setState(() {
    //   ckbItem.value = newValue;
    //   checkboxList.forEach((element) {
    //     element.value = newValue;
    //   });
    // });
  }
}
