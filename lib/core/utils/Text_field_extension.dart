import 'package:flutter/material.dart';
import 'package:app_lince_emp/core/desings/text_field_config.dart';
import 'package:app_lince_emp/widgets/hover_wrapper.dart';

extension TextfieldExtension on TextField {
  Widget styled(TextFieldConfig config) {
    Widget box = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(config.borderRadius),
        boxShadow: config.boxShadowHover,
      ),
      width: config.width,

      child: TextField(
        controller: this.controller,
        onChanged: this.onChanged,
        onSubmitted: this.onSubmitted,
        keyboardType: this.keyboardType,
        obscureText: this.obscureText,
        style: TextStyle(color: config.textColor, fontSize: 14),
        // IMPORTANTE: .copyWith mantiene lo que ya le pusiste al TextField original
        decoration: (this.decoration ?? const InputDecoration()).copyWith(
          isDense: true,
          hintStyle: TextStyle(color: config.hintTextColor, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(
            horizontal: config.paddingHorizontal,
            vertical: (config.height - 20) / 2, // Centrado vertical automático
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
            borderSide: BorderSide(color: config.borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
            borderSide: BorderSide(
              color: config.borderSelectedColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );

    return box;
  }

  Widget withHoverTextField({
    required TextFieldConfig config,
    VoidCallback? onTap,
  }) {
    return HoverWrapper(
      hoverColor: config.backgroundColor,
      borderRadius: config.borderRadius.toString(),
      boxShadowHover: config.boxShadowHover,
      child: Builder(
        builder: (context) {
          final bool isHovered = HoverData.of(context)?.isHovered ?? false;
          return styled(
            config.copyWith(
              borderColor: isHovered
                  ? (config.borderSelectedColor)
                  : config.borderColor,
            ),
          );
        },
      ),
    );
  }
}
