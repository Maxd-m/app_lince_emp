import 'package:flutter/material.dart';
import 'package:app_lince_emp/core/theme/app_colors.dart';

class InputselectConfig {
  final bool isExpanded, isDense;
  final double borderRadius, height, borderRadiusMenu, fontSize;
  final double? borderWidth;
  final Color borderColor, backgroundMenuColor;
  final Color? borderColorHover;
  final String placeholder;


  final List<BoxShadow>? boxShadowHover;

  const InputselectConfig(
    {
      this.isExpanded = true,
      this.isDense = true,
      this.borderRadius = 10,
      this.fontSize = 14,
      this.borderColor = AppColors.borderTextField,
      this.borderWidth,
      this.borderColorHover,
      this.placeholder = "Inserte texto",
      this.height = 40,
      this.borderRadiusMenu = 15,
      this.backgroundMenuColor = Colors.white,
      this.boxShadowHover
    });

    InputselectConfig copyWith({
         bool? isExpanded, isDense,
         double? borderRadius, height, borderRadiusMenu,
         double? borderWidth, fontSize,
         Color? borderColor, backgroundMenuColor,
         Color? borderColorHover,
         String? placeholder,
         List<BoxShadow>? boxShadowHover

    })
    {
      return InputselectConfig(
        isExpanded: isExpanded ?? this.isExpanded,
        isDense: isDense ?? this.isDense,
        borderRadius: borderRadius ?? this.borderRadius,
        fontSize: fontSize ?? this.fontSize,
        borderColor: borderColor ?? this.borderColor,
        borderWidth: borderWidth ?? this.borderWidth,
        borderColorHover: borderColorHover ?? this.borderColorHover,
        placeholder: placeholder ?? this.placeholder,
        height: height ?? this.height,
        borderRadiusMenu: borderRadiusMenu ?? this.borderRadiusMenu,
        backgroundMenuColor: backgroundMenuColor ?? this.backgroundMenuColor,
        boxShadowHover: boxShadowHover ?? this.boxShadowHover,
      );
    }
}
