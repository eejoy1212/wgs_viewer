import 'dart:convert';

import 'package:get/get.dart';

class OESFileData {
  String? filePath;
  Rx<bool> checked;
  List<dynamic> firstLine;
  OESFileData({
    required this.filePath,
    required this.checked,
    this.firstLine = const [],
  });

  OESFileData copyWith({
    String? filePath,
    Rx<bool>? checked,
  }) {
    return OESFileData(
      filePath: filePath ?? this.filePath,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filePath': filePath,
      'checked': checked,
    };
  }

  factory OESFileData.fromMap(Map<String, dynamic> map) {
    return OESFileData(
      filePath: map['filePath'],
      checked: map['checked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory OESFileData.fromJson(String source) =>
      OESFileData.fromMap(json.decode(source));

  @override
  String toString() => 'OESFileData(filePath: $filePath, checked: $checked)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OESFileData &&
        other.filePath == filePath &&
        other.checked == checked;
  }

  @override
  int get hashCode => filePath.hashCode ^ checked.hashCode;
}
