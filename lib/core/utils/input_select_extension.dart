import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:app_lince_emp/core/desings/input_select_config.dart';
import 'package:app_lince_emp/widgets/hover_wrapper.dart';

extension InputselectExtension on DropdownButtonFormField2<String> {

  DropdownButtonFormField2<String> styled(
    InputselectConfig config,
  ) {
    // Retornamos una NUEVA instancia basada en las propiedades de la original (this)
    // pero aplicando los estilos del objeto config.
    return DropdownButtonFormField2<String>(
      // MANTENER LOS DATOS ORIGINALES
      value: initialValue,
      items: items , // ¡Importante! Si no, el dropdown sale vacío
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,

      // APLICAR ESTILOS DE CONFIG
      isExpanded: config.isExpanded,
      decoration: InputDecoration(
        isDense: config.isDense,
        contentPadding: EdgeInsets.zero,
        // Agregamos label si fuera necesario, o mantenemos el hint
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
          borderSide: BorderSide(
            color: config.borderColor,
            width: config.borderWidth ?? 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
          borderSide: BorderSide(
            color: config.borderColorHover ?? config.borderColor,
            width: config.borderWidth ?? 1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
        ),
      ),
      hint: Text(
        config.placeholder,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(fontSize: config.fontSize, color: config.borderColor),
      ),
      buttonStyleData: ButtonStyleData(
        padding: const EdgeInsets.only(right: 8),
        height: config.height,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(config.borderRadiusMenu),
          color: config.backgroundMenuColor,
        ),
        elevation: 8,
        offset: const Offset(0, -4),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  // Widget para envolver con Hover
  Widget withHoverInputSelect(
     InputselectConfig config,
  ) {
    return HoverWrapper(
      hoverColor: Colors.white,
      baseColor: Colors.white,
      borderRadius: config.borderRadius.toString(),
      boxShadowHover: config.boxShadowHover,
      child: Builder(
        builder: (context) {
          // Detectamos si el mouse está encima a través del context de HoverWrapper
          final bool isHovered = HoverData.of(context)?.isHovered ?? false;
          return this.styled(
            config.copyWith(
              borderColor: isHovered
                  ? (config.borderColorHover ?? config.borderColor)
                  : config.borderColor,
            ),
          );
        },
      ),
    );
  }
}