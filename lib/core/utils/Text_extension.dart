import 'package:flutter/material.dart';
import 'package:app_lince_emp/core/desings/text_config.dart';

extension TextStyled on Text {
  Text styled(TextConfig config) {
    return Text(
      this.data ?? '', // Usamos el texto que ya tenía el widget
      style: TextStyle(
        color: config.color,
        fontSize: config.fontSize,
        fontWeight: config.fontWeight,
        height: config.height, // Ojo: en TextStyle se llama height
        // ... el resto de tus propiedades
      ),
      textAlign: this.textAlign,
    );
  }
}