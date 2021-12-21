// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:wgs_viewer/main.dart';
// import 'package:wgs_viewer/model/all_checkbox_model.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: HomePg());
//   }
// }

// class HomePg extends StatefulWidget {
//   @override
//   State<HomePg> createState() => _HomePgState();
// }

// class _HomePgState extends State<HomePg> {
// final allChecked = CheckBoxModel(title: 'All check');

// final checkboxList = [
//   CheckBoxModel(title: '1'),
//   CheckBoxModel(title: '2'),
//   CheckBoxModel(title: '3'),
// ];

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('checkbox test'),
//           centerTitle: true,
//         ),
//         body: ListView(
//           children: [
//             ListTile(
//               onTap: () => onAllClicked(allChecked),
//               leading: Checkbox(
//                 value: allChecked.value,
//                 onChanged: (value) => onAllClicked(allChecked),
//               ),
//               title: Text(allChecked.title),
//             ),
//             Divider(),
//             ...checkboxList
//                 .map(
//                   (item) => ListTile(
//                     onTap: () => onItemClicked(item),
//                     leading: Checkbox(
//                       value: item.value,
//                       onChanged: (value) => onItemClicked(item),
//                     ),
//                     title: Text(item.title),
//                   ),
//                 )
//                 .toList()
//           ],
//         ),
//       ),
//     );
//   }

//   onAllClicked(CheckBoxModel ckbItem) {
//     final newValue = !ckbItem.value;
//     setState(() {
//       ckbItem.value = newValue;
//       checkboxList.forEach((element) {
//         element.value = newValue;
//       });
//     });
//   }

//   onItemClicked(CheckBoxModel ckbItem) {
//     setState(() {
//       ckbItem.value = !ckbItem.value;
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/main.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';

class FileList extends StatelessWidget {
  final allChecked = CheckBoxModel(title: 'All Select : ');

  @override
  Widget build(BuildContext context) {
    return ListView(
      // scrollDirection: Axis.vertical,
      shrinkWrap: true,

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
        ...CheckBoxCtrl.to.checkboxList
            .map((item) => Obx(() => ListTile(
                horizontalTitleGap: 600,
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
                leading: Text(item.title))))
            .toList()
      ],
    );
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

  /*원래거 밑에
  onAllClicked(CheckBoxModel ckbItem) {
    final newValue = !ckbItem.value;
    setState(() {
      ckbItem.value = newValue;
      checkboxList.forEach((element) {
        element.value = newValue;
      });
    });
  }

  onItemClicked(CheckBoxModel ckbItem) {
    CheckBoxCtrl.to.isChecked.value = !ckbItem.value;
    print('체크박스 상태 : ${CheckBoxCtrl.to.isChecked.value}');
    // setState(() {
    //   ckbItem.value = !ckbItem.value;
    //   print('뭐지?? : ${ckbItem.value}');
    // });
  }*/
}
