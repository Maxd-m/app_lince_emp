import 'package:flutter/material.dart';

class TextFieldConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color borderSelectedColor;
  final Color textColor;
  final Color hintTextColor;
  final double borderRadius;
  final double paddingHorizontal;
  final double paddingVertical;
  final double? width; // El ancho suele ser opcional (para usar Expanded)
  final double height;
  final List<BoxShadow>? boxShadowHover;

  const TextFieldConfig({
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFE0E0E0),
    this.borderSelectedColor = Colors.blue,
    this.textColor = Colors.black87,
    this.hintTextColor = Colors.grey,
    this.borderRadius = 10.0,
    this.paddingHorizontal = 15.0,
    this.paddingVertical = 12.0,
    this.width,
    this.height = 45.0, // Altura estándar de un input moderno
    this.boxShadowHover,
  });

  // Esto te permite crear variaciones rápidas
  TextFieldConfig copyWith({
    Color? borderColor,
    backgroundColor,
    borderSelectedColor,
    textColor,
    hintTextColor,
    double? borderRadius,
    paddingHorizontal,
    paddingVertical,
    width,
    height,
  }) {
    return TextFieldConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderSelectedColor: borderSelectedColor ?? this.borderSelectedColor,
      textColor: textColor ?? this.textColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      paddingHorizontal: paddingHorizontal ?? this.paddingHorizontal,
      paddingVertical: paddingVertical ?? this.paddingVertical,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}
