import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<List<dynamic>> employeeData;

  @override
  initState() {
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

    employeeData = List<List<dynamic>>.empty(growable: true);
    for (int i = 0; i < 5; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List.empty(growable: true);
      row.add("Employee Name $i");
      row.add((i % 2 == 0) ? "Male" : "Female");
      row.add(" Experience : ${i * 5}");
      employeeData.add(row);
    }
  }

  getCsv() async {
    if (await Permission.storage.request().isGranted) {
//store file in documents folder

      String dir = "./datafiles/20211215-162607__1.csv";
      String file = "$dir";

      File f = new File(file);

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(employeeData);
      f.writeAsString(csv);
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Flutter CSV Upload"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: employeeData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employeeData[index][0]),
                          Text(employeeData[index][1]),
                          Text(employeeData[index][2]),
                        ],
                      ),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.green,
                height: 30,
                child: Tooltip(
                  message: 'Export to CSV',
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: getCsv,
                    icon: const Icon(
                      Icons.file_copy_outlined,
                      size: 20,
                    ),
                    label: const Text('Export'),
                  ),
                ),

                //
              ),
            ),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
