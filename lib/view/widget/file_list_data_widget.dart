import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';

class FileListData extends StatelessWidget {
  final ScrollController scrollCtrl = ScrollController();
  final allChecked = CheckBoxModel(title: 'All Select : ');

  @override
  Widget build(BuildContext context) {
    print('???? : ${FilePickerCtrl.to.selectedFileName}');
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            horizontalTitleGap: 200,
            title: Row(
              children: [
                Text(
                  allChecked.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Checkbox(
                    checkColor: Colors.black,
                    value: CheckboxCtrl.to.isChecked.value,
                    onChanged: (value) => {
                      CheckboxCtrl.to.isChecked.value =
                          !CheckboxCtrl.to.isChecked.value
                    },
                  ),
                )
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

          ///ListView.builder부터 파일이름 나오는 곳
          Container(
            height: 200,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      controller: scrollCtrl,
                      itemCount: FilePickerCtrl.to.selectedFileName.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(() => ListTile(
                            onTap: () {
                              print('tap');
                              CheckboxCtrl.to.selIdx.value = index;

                              print(
                                  'isSelected index: ${CheckboxCtrl.to.selIdx.value}');
                            },
                            hoverColor: Colors.cyan[50],
                            selected: index == CheckboxCtrl.to.selIdx.value,
                            selectedTileColor: Colors.cyan[100],
                            title: Text(
                              '${FilePickerCtrl.to.selectedFileName[index]}',
                              style: TextStyle(
                                color: index ==
                                        FilePickerCtrl
                                                .to.selectedFileName.length -
                                            1
                                    ? Colors.green[800]
                                    : Colors.black,
                              ),
                            ),
                            leading: Icon(
                              Icons.picture_as_pdf,
                              color: index ==
                                      FilePickerCtrl
                                              .to.selectedFileName.length -
                                          1
                                  ? Colors.green[800]
                                  : Colors.grey,
                            ),
                            trailing: Obx(
                              () => Checkbox(
                                checkColor: Colors.black,
                                value: CheckboxCtrl.to.selIdx.value == index,
                                onChanged: (value) {
                                  if (CheckboxCtrl.to.selIdx.value == index) {
                                    print(
                                        '체크박스 선택true? : ${CheckboxCtrl.to.selIdx.value == index}');
                                    CheckboxCtrl.to.isChecked.value = true;
                                  } else {
                                    print(
                                        '체크박스 선택false? : ${CheckboxCtrl.to.selIdx.value == index}');
                                    CheckboxCtrl.to.isChecked.value = false;
                                  }
                                },
                              ),
                            )));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// class FileView extends GetxController {
//   const FileView({Key? key, required this.index}) : super(key: key);
//   int index;
//   RxBool isChecked = false.obs;
//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
