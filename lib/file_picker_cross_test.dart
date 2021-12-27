import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

FileQuotaCross quota = FileQuotaCross(quota: 0, usage: 0);
String _fileString = '';
late Set<String> lastFiles;
late FilePickerCross filePickerCross;

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Desktop file picker'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // _selectFile(context);
              //          FilePickerCross.importMultipleFromStorage().then((filePicker) {
              // setFilePicker(filePicker[0]);
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('You selected ${filePicker.length} file(s).'),
              //   ),
              // );
              var myFiles = await FilePickerCross.importMultipleFromStorage(
                type: FileTypeCross.custom,
                fileExtension: 'csv',
              );
            },
            child: Text('file_picker_cross'),
          ),
        ));
  }

  // void _selectFile(context) {
  //   FilePickerCross.importMultipleFromStorage().then((filePicker) {
  //     setFilePicker(filePicker[0]);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('You selected ${filePicker.length} file(s).'),
  //       ),
  //     );

  //     setState(() {});
  //   });
  // }

  // setFilePicker(FilePickerCross filePicker) => setState(() {
  //       filePickerCross = filePicker;
  //       filePickerCross.saveToPath(path: filePickerCross.fileName.toString());
  //       FilePickerCross.quota().then((value) {
  //         setState(() => quota = value);
  //       });
  //       lastFiles.add(filePickerCross.fileName.toString());
  //       try {
  //         _fileString = filePickerCross.toString();
  //       } catch (e) {
  //         _fileString = 'Not a text file. Showing base64.\n\n' +
  //             filePickerCross.toBase64();
  //       }
  //     });
}
