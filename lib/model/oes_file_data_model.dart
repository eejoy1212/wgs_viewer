import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OESFileData {
  String fileNama;
  String filePath;
  bool checked;
  OESFileData({
    required this.fileNama,
    required this.filePath,
    required this.checked,
  });

  OESFileData copyWith({
    String? fileNama,
    String? filePath,
    bool? checked,
  }) {
    return OESFileData(
      fileNama: fileNama ?? this.fileNama,
      filePath: filePath ?? this.filePath,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileNama': fileNama,
      'filePath': filePath,
      'checked': checked,
    };
  }

  factory OESFileData.fromMap(Map<String, dynamic> map) {
    return OESFileData(
      fileNama: map['fileNama'] ?? '',
      filePath: map['filePath'] ?? '',
      checked: map['checked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory OESFileData.fromJson(String source) =>
      OESFileData.fromMap(json.decode(source));

  @override
  String toString() =>
      'OESFileData(fileNama: $fileNama, filePath: $filePath, checked: $checked)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OESFileData &&
        other.fileNama == fileNama &&
        other.filePath == filePath &&
        other.checked == checked;
  }

  @override
  int get hashCode => fileNama.hashCode ^ filePath.hashCode ^ checked.hashCode;
}

///////////////////
class WaveLengthChartData {
  List<FlSpot> chartData;
  RangeValues rv;
  WaveLengthChartData({
    required this.chartData,
    required this.rv,
  });

  WaveLengthChartData copyWith({
    List<FlSpot>? chartData,
    RangeValues? rv,
  }) {
    return WaveLengthChartData(
      chartData: chartData ?? this.chartData,
      rv: rv ?? this.rv,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'chartData': chartData.map((x) => x.toMap()).toList(),
  //     'rv': rv.toMap(),
  //   };
  // }

  // factory WaveLengthChartData.fromMap(Map<String, dynamic> map) {
  //   return WaveLengthChartData(
  //     chartData: List<FlSpot>.from(map['chartData']?.map((x) => FlSpot.fromMap(x))),
  //     rv: RangeValues.fromMap(map['rv']),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory WaveLengthChartData.fromJson(String source) => WaveLengthChartData.fromMap(json.decode(source));

  @override
  String toString() => 'WaveLengthChartData(chartData: $chartData, rv: $rv)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WaveLengthChartData &&
        listEquals(other.chartData, chartData) &&
        other.rv == rv;
  }

  @override
  int get hashCode => chartData.hashCode ^ rv.hashCode;
}

//////////////////////////////////////
class RangeSliderWGS {
  List<RangeSlider> rv;
  List<double> waveLengths;
  RangeSliderWGS({
    required this.rv,
    required this.waveLengths,
  });

  RangeSliderWGS copyWith({
    List<RangeSlider>? rv,
    List<double>? waveLengths,
  }) {
    return RangeSliderWGS(
      rv: rv ?? this.rv,
      waveLengths: waveLengths ?? this.waveLengths,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'rv': rv.map((x) => x.toMap()).toList(),
  //     'waveLengths': waveLengths,
  //   };
  // }

  // factory RangeSliderWGS.fromMap(Map<String, dynamic> map) {
  //   return RangeSliderWGS(
  //     rv: List<RangeSlider>.from(map['rv']?.map((x) => RangeSlider.fromMap(x))),
  //     waveLengths: List<double>.from(map['waveLengths']),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory RangeSliderWGS.fromJson(String source) => RangeSliderWGS.fromMap(json.decode(source));

  @override
  String toString() => 'RangeSliderWGS(rv: $rv, waveLengths: $waveLengths)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RangeSliderWGS &&
        listEquals(other.rv, rv) &&
        listEquals(other.waveLengths, waveLengths);
  }

  @override
  int get hashCode => rv.hashCode ^ waveLengths.hashCode;
}
///////////////////


