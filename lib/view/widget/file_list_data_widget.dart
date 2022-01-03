import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';

class CkbViewWidget extends StatelessWidget {
  const CkbViewWidget({Key? key, required this.ckb}) : super(key: key);
  final CheckBoxModel ckb;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(ckb.fileName),
      Obx(
        () => Checkbox(
            value: ckb.isChecked.value,
            onChanged: (val) {
              if (val != null) {
                ckb.isChecked.value = val;
                debugPrint('isChecked $val!');
              }
            }),
      ),
    ]);
  }
}

class FileListData extends StatelessWidget {
  final ScrollController scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          horizontalTitleGap: 200,
          title: Row(
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: Obx(() => Scrollbar(
                    isAlwaysShown: true,
                    child: ListView.builder(
                      itemCount: CheckboxCtrl.to.ckb.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CkbViewWidget(ckb: CheckboxCtrl.to.ckb[index]);
                      },
                    ))),
              )
              //////////////////////////////이 라인 위에가 새로 만들고 있는 부분....
              ,
              // Obx(
              //   () => Checkbox(
              //     checkColor: Colors.black,
              //     value: CheckboxCtrl.to.isChecked.value,
              //     onChanged: (value) => {
              //       CheckboxCtrl.to.isChecked.value =
              //           !CheckboxCtrl.to.isChecked.value
              //     },
              //   ),
              // )
            ],
          ),
          // leading: Text(
          //   'File name',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
        // Divider(),

        ///ListView.builder부터 파일이름 나오는 곳
        // Container(
        //   height: 200,
        //   child: Scrollbar(
        //     child: SingleChildScrollView(
        //       child: Column(
        //         children: [
        //           ListView.builder(
        //             reverse: true,
        //             shrinkWrap: true,
        //             controller: scrollCtrl,
        //             itemCount: FilePickerCtrl.to.selectedFileName.length,
        //             itemBuilder: (BuildContext context, int index) {
        //               return Obx(() => ListTile(
        //                   onTap: () {
        //                     CheckboxCtrl.to.selIdx.value = index;
        //                   },
        //                   hoverColor: Colors.cyan[50],
        //                   selected: index == CheckboxCtrl.to.selIdx.value,
        //                   selectedTileColor: Colors.cyan[100],
        //                   title: Text(
        //                     '${FilePickerCtrl.to.selectedFileName[index]}',
        //                     style: TextStyle(
        //                       color: index ==
        //                               FilePickerCtrl
        //                                       .to.selectedFileName.length -
        //                                   1
        //                           ? Colors.green[800]
        //                           : Colors.black,
        //                     ),
        //                   ),
        //                   leading: Icon(
        //                     Icons.picture_as_pdf,
        //                     color: index ==
        //                             FilePickerCtrl
        //                                     .to.selectedFileName.length -
        //                                 1
        //                         ? Colors.green[800]
        //                         : Colors.grey,
        //                   ),
        //                   trailing: Obx(
        //                     () => Checkbox(
        //                       checkColor: Colors.black,
        //                       value: CheckboxCtrl.to.selIdx.value == index,
        //                       onChanged: (value) {
        //                         if (CheckboxCtrl.to.selIdx.value == index) {
        //                           CheckboxCtrl.to.isChecked.value = true;
        //                         } else {
        //                           CheckboxCtrl.to.isChecked.value = false;
        //                         }
        //                       },
        //                     ),
        //                   )));
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
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
