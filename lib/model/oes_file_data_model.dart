import 'dart:convert';

import 'package:get/get.dart';

class OESFileData {
  String fileName;
  String? filePath;
  Rx<bool> isChecked;
  List<List<dynamic>> fileData;
  //List<dynamic> firstLine;//time
  //List<dynamic> xTime; //time
  // List<dynamic> xWL; //wavelength
  List<double> avg;
  OESFileData({
    required this.fileName,
    required this.filePath,
    required this.isChecked,
    this.fileData = const [],
    //this.firstLine = const [],
    //this.xTime = const [],
    // this.xWL = const [],
    this.avg = const [0.0, 0.0, 0.0, 0.0, 0.0],
  });

  factory OESFileData.init() {
    return OESFileData(fileName: '', filePath: '', isChecked: false.obs);
  }

  OESFileData copyWith({
    String? filePath,
    Rx<bool>? isChecked,
  }) {
    return OESFileData(
      filePath: filePath ?? this.filePath,
      isChecked: isChecked ?? this.isChecked,
      fileName: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filePath': filePath,
      'isChecked': isChecked,
      // 'xTime': xTime,
      //'xWL': xWL,
    };
  }

  factory OESFileData.fromMap(Map<String, dynamic> map) {
    return OESFileData(
      filePath: map['filePath'],
      isChecked: map['isChecked'] ?? false,
      fileName: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OESFileData.fromJson(String source) =>
      OESFileData.fromMap(json.decode(source));

  @override
  String toString() => fileName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OESFileData &&
        other.filePath == filePath &&
        other.isChecked == isChecked;
  }

  @override
  int get hashCode => filePath.hashCode ^ isChecked.hashCode;
}
