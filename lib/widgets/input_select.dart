import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:app_lince_emp/core/desings/themes.dart';
import 'package:app_lince_emp/core/utils/Text_extension.dart';
import 'package:app_lince_emp/core/utils/input_select_extension.dart';
import 'package:app_lince_emp/widgets/flex_box.dart';

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
    this.value
  });

  @override
  Widget build(BuildContext context) {
    return FlexBox(
      gap: 10,
      children: [
        Text(label).styled(cardLabel), // Tu extensión de texto
        DropdownButtonFormField2<String>(
          value: value?.toString(),
          items: options
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item['id'].toString(),
                  child: Text(item['nombre'], overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ).withHoverInputSelect(
          cardInputSelect.copyWith(placeholder: this.placeholder),
        ),
      ],
    );
  }
}
