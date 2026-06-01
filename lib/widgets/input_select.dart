import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:app_lince_emp/core/desings/themes.dart';
import 'package:app_lince_emp/core/utils/Text_extension.dart';
import 'package:app_lince_emp/widgets/flex_box.dart';
import 'package:app_lince_emp/widgets/hover_wrapper.dart'; // Importamos tu HoverWrapper

class InputSelect extends StatelessWidget {
  final String label;
  final String placeholder;
  final String? value;
  final List<Map<String, dynamic>> options;
  final Function(String?) onChanged;

  const InputSelect({
    super.key,
    required this.label,
    required this.placeholder,
    required this.options,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Combinamos la configuración base con el placeholder dinámico de este Input
    final config = cardInputSelect.copyWith(placeholder: placeholder);

    return FlexBox(
      gap: 10,
      children: [
        Text(label).styled(cardLabel), // Tu extensión de texto existente
        // Envolvemos directamente con el HoverWrapper aquí
        HoverWrapper(
          hoverColor: Colors.white,
          baseColor: Colors.white,
          borderRadius: config.borderRadius.toString(),
          boxShadowHover: config.boxShadowHover,
          child: Builder(
            builder: (context) {
              // Detectamos si el mouse está encima gracias al HoverWrapper
              final bool isHovered = HoverData.of(context)?.isHovered ?? false;

              // Ajustamos el color del borde dinámicamente si hay Hover
              final effectiveBorderColor = isHovered
                  ? (config.borderColorHover ?? config.borderColor)
                  : config.borderColor;

              return DropdownButtonFormField2<String>(
                value: value?.toString(),
                items: options
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item['id'].toString(),
                        child: Text(
                          item['nombre'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,

                // APLICAR LOS ESTILOS DE TU CONFIG
                isExpanded: config.isExpanded,
                decoration: InputDecoration(
                  isDense: config.isDense,
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(config.borderRadius),
                    borderSide: BorderSide(
                      color: effectiveBorderColor,
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
                  style: TextStyle(
                    fontSize: config.fontSize,
                    color: config.borderColor,
                  ),
                ),
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.only(right: 8),
                  height: config.height,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      config.borderRadiusMenu,
                    ),
                    color: config.backgroundMenuColor,
                  ),
                  elevation: 8,
                  offset: const Offset(0, -4),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
