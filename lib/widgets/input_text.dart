import 'package:flutter/material.dart';
import 'package:app_lince_emp/core/desings/themes.dart';
import 'package:app_lince_emp/core/utils/Text_field_extension.dart';
import 'package:app_lince_emp/core/utils/Text_extension.dart';
import 'package:app_lince_emp/widgets/flex_box.dart';

class Inputtext extends StatelessWidget {
  final String Label;
  final String? Placeholder;
  final TextEditingController? controller;
  const Inputtext({super.key, required this.Label, this.Placeholder, this.controller});

  @override
  Widget build(BuildContext context) {
    return FlexBox(
      gap: 10,
      children: [
        Text(Label).styled(cardLabel),
        TextField(
          controller: controller ?? null,
          decoration: InputDecoration(hintText: Placeholder, hintStyle: TextStyle(fontSize: 9.0)),
        ).withHoverTextField(config: cardTextField),
      ],
    );
  }
}
