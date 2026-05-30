import 'package:flutter/material.dart';
import 'package:app_lince_emp/widgets/hover_wrapper.dart';

// --- 1. EXTENSIÓN PARA USARLO COMO EN WEB ---
extension WidgetHoverPower on Widget {
  Widget withHover({
    required Color hoverColor,
    Color? baseColor,
    Color? hoverTextColor,
    Color? baseTextColor,
    String? borderRadius,
    VoidCallback? onTap,
    double scale = 1.0,
    double translate = 0.0,
    double? borderEndLeftRadius,
    double? borderEndRightRadius,
    double? borderStartLeftRadius,
    double? borderStartRightRadius,
    int? durationHover,

    List<BoxShadow>? boxShadowHover,
    baseBoxShadow,
  }) {
    return HoverWrapper(
      hoverColor: hoverColor,
      baseColor: baseColor,
      hoverTextColor: hoverTextColor,
      baseTextColor: baseTextColor,
      borderRadius: borderRadius,
      borderEndLeftRadius: borderEndLeftRadius,
      borderEndRightRadius: borderEndRightRadius,
      borderStartLeftRadius: borderStartLeftRadius,
      borderStartRightRadius: borderStartRightRadius,
      onTap: onTap,
      scaleOnHover: scale,
      translateOnHover: translate,
      boxShadowHover: boxShadowHover,
      baseBoxShadow: baseBoxShadow,
      durationHover: durationHover,
      child: this,
    );
  }
}
