import 'package:flutter/material.dart';

class TextConfig {
  final Color? color;
  final double? fontSize, height;
  final FontWeight? fontWeight;

  const TextConfig({this.color, this.fontSize, this.height, this.fontWeight});

  TextConfig copyWith({
    Color? color,
    double? fontSize,
    height,
    FontWeight? fontWeight,
  })
  {
    return TextConfig(
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      height: height ?? this.height,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }
}
