import 'dart:convert';

import 'package:get/get.dart';

class OESFileData {
  String fileName;
  String? filePath;
  Rx<bool> isChecked;
  List<dynamic> firstLine;
  OESFileData({
    required this.fileName,
    required this.filePath,
    required this.isChecked,
    this.firstLine = const [],
  });

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
  String toString() =>
      'OESFileData(filePath: $filePath, isChecked: $isChecked)';

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
