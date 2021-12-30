import 'dart:convert';

import 'package:get/get.dart';

class CheckBoxModel {
  String title;
  String fileName;
  Rx<bool> isChecked;
  RangeModel range;
  CheckBoxModel({
    required this.title,
    required this.fileName,
    required this.isChecked,
    required this.range,
  });

  CheckBoxModel copyWith({
    String? title,
    String? fileName,
    Rx<bool>? isChecked,
    RangeModel? range,
  }) {
    return CheckBoxModel(
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      isChecked: isChecked ?? this.isChecked,
      range: range ?? this.range,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'fileName': fileName,
      'isChecked': isChecked,
      'range': range.toMap(),
    };
  }

  factory CheckBoxModel.fromMap(Map<String, dynamic> map) {
    return CheckBoxModel(
      title: map['title'] ?? '',
      fileName: map['fileName'] ?? '',
      isChecked: map['isChecked'] ?? false,
      range: RangeModel.fromMap(map['range']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckBoxModel.fromJson(String source) =>
      CheckBoxModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CheckBoxModel(title: $title, fileName: $fileName, isChecked: $isChecked, range: $range)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckBoxModel &&
        other.title == title &&
        other.fileName == fileName &&
        other.isChecked == isChecked &&
        other.range == range;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        fileName.hashCode ^
        isChecked.hashCode ^
        range.hashCode;
  }
}

////////레인지 슬라이드 관련 모델
class RangeModel {
  int start;
  int end;
  RangeModel({
    required this.start,
    required this.end,
  });

  RangeModel copyWith({
    int? start,
    int? end,
  }) {
    return RangeModel(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
    };
  }

  factory RangeModel.fromMap(Map<String, dynamic> map) {
    return RangeModel(
      start: map['start']?.toDouble() ?? 0.0,
      end: map['end']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RangeModel.fromJson(String source) =>
      RangeModel.fromMap(json.decode(source));

  @override
  String toString() => 'RangeModel(start: $start, end: $end)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RangeModel && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
