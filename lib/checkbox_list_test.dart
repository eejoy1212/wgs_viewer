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
import 'package:wgs_viewer/model/all_checkbox_model.dart';

class FileList extends StatefulWidget {
  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  final allChecked = CheckBoxModel(title: 'All Select : ');

  final checkboxList = [
    CheckBoxModel(title: 'File 1'),
    CheckBoxModel(title: 'File 2'),
    CheckBoxModel(title: 'File 3'),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      // scrollDirection: Axis.vertical,
      shrinkWrap: true,

      children: [
        ListTile(
          horizontalTitleGap: 600,
          onTap: () => onAllClicked(allChecked),
          title: Row(
            children: [
              Text(allChecked.title),
              Checkbox(
                value: allChecked.value,
                onChanged: (value) => onAllClicked(allChecked),
              ),
            ],
          ),
          leading: Text('file name'),
        ),
        Divider(),
        ...checkboxList
            .map(
              (item) => ListTile(
                horizontalTitleGap: 600,
                onTap: () => onItemClicked(item),
                title: Checkbox(
                  value: item.value,
                  onChanged: (value) => onItemClicked(item),
                ),
                leading: Text(item.title),
              ),
            )
            .toList()
      ],
    );
  }

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
    setState(() {
      ckbItem.value = !ckbItem.value;
    });
  }
}
