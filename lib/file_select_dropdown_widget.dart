import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

class FileSelectDropDown extends StatelessWidget {
  const FileSelectDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch(
      mode: Mode.MENU,
      showSearchBox: true,
      items: FilePickerCtrl.to.dropdownFileName,
      itemAsString: (item) {
        return item.toString();
      },
    );
  }
}
