import 'package:app_lince_emp/core/utils/hover_extension.dart';
import 'package:flutter/material.dart';
import 'package:app_lince_emp/core/desings/themes.dart';
import 'package:app_lince_emp/core/theme/app_colors.dart';
import 'package:app_lince_emp/core/utils/Text_extension.dart';
import 'package:app_lince_emp/widgets/flex_box.dart';

class Modalcard extends StatefulWidget {
  final String title;
  final List<Widget> childrenBody;
  final VoidCallback? onTapAceptar;

  const Modalcard({
    super.key,
    required this.title,
    required this.childrenBody,
    this.onTapAceptar,
  });

  @override
  State<Modalcard> createState() => _ModalCardState();
}

class _ModalCardState extends State<Modalcard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      type: MaterialType.transparency,
      child: FlexBox.styled(
        cardOverlay,
        children: [
          FlexBox(
            heightPercent: 80,
            widthPercent: width < 800 ? 90 : 50,
            backgroundColor: Colors.white,
            borderRadius: '20',
            padding: '20 30',
            children: [
              FlexBox.styled(
                cardFormTitle,
                children: [
                  Expanded(child: Text(widget.title).styled(cardFormTitleText)),
                  InkWell(
                    borderRadius: BorderRadius.circular(
                      50,
                    ), // Para que el efecto sea circular
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              DefaultTextStyle(
                style: TextStyle(
                  fontSize: width < 400 ? 12.0 : null,
                ),
                child: Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: FlexBox(gap: 20, children: widget.childrenBody),
                  ),
                ),
              ),

              // FOOTER: Fijo abajo
              FlexBox.styled(
                cardFormFooter,
                children: [
                  _buildButton(text: "Aceptar", onTap: widget.onTapAceptar, parentWidth: width),
                  _buildButton(
                    text: "Cancelar",
                    onTap: () => Navigator.pop(context),
                     parentWidth: width
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Pequeño helper para no repetir código de botones
  Widget _buildButton({required text, VoidCallback? onTap, required double parentWidth}) {
    return FlexBox(
      flexDirection: 'row',
      backgroundColor: Colors.black,
      verticalAlignment: 'center',
      horizontalAlignment: 'center',
      width: parentWidth < 800 ? 100 : 150,
      gap: 10,
      height: 30,
      borderRadius: '50',
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: parentWidth < 800 ? 12.0 : null,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ).withHover(hoverColor: Colors.transparent, scale: 1.05, onTap: onTap);
  }
}
