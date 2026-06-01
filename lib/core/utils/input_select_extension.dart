import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:app_lince_emp/core/desings/input_select_config.dart';
import 'package:app_lince_emp/widgets/hover_wrapper.dart';

extension InputselectExtension on DropdownButtonFormField2<String> {
  // Ahora styled pide obligatoriamente los datos que no puede leer de 'this'
  DropdownButtonFormField2<String> styled({
    required InputselectConfig config,
    required List<DropdownMenuItem<String>>? items,
    required ValueChanged<String?>? onChanged,
  }) {
    return DropdownButtonFormField2<String>(
      // MANTENER LOS DATOS ORIGINALES ACCESIBLES
      value: this.initialValue,
      onSaved: this.onSaved,
      validator: this.validator,

      // DATOS INYECTADOS PORQUE NO SON ACCESIBLES MEDIANTE 'THIS'
      items: items,
      onChanged: onChanged,

      // APLICAR ESTILOS DE CONFIG
      isExpanded: config.isExpanded,
      decoration: InputDecoration(
        isDense: config.isDense,
        contentPadding: EdgeInsets.zero,
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

  // Modificamos también este método para arrastrar los parámetros requeridos
  Widget withHoverInputSelect({
    required InputselectConfig config,
    required List<DropdownMenuItem<String>>? items,
    required ValueChanged<String?>? onChanged,
  }) {
    return HoverWrapper(
      hoverColor: Colors.white,
      baseColor: Colors.white,
      borderRadius: config.borderRadius.toString(),
      boxShadowHover: config.boxShadowHover,
      child: Builder(
        builder: (context) {
          final bool isHovered = HoverData.of(context)?.isHovered ?? false;
          return this.styled(
            items: items,
            onChanged: onChanged,
            config: config.copyWith(
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
