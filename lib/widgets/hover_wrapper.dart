import 'package:flutter/material.dart';

class HoverData extends InheritedWidget {
  final bool isHovered;

  const HoverData({super.key, required super.child, required this.isHovered});
  static HoverData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HoverData>();
  }

  // 4. La regla de actualización
  @override
  bool updateShouldNotify(HoverData oldWidget) {
    return isHovered != oldWidget.isHovered;
  }
}

class HoverWrapper extends StatefulWidget {
  final List<BoxShadow>? boxShadowHover, baseBoxShadow;
  final Widget child;
  final Color hoverColor;
  final Color? baseColor, hoverTextColor, baseTextColor;
  final String? borderRadius;
  final VoidCallback? onTap;
  final double scaleOnHover, translateOnHover;
  final double? borderEndLeftRadius,
      borderEndRightRadius,
      borderStartLeftRadius,
      borderStartRightRadius;

  final int? durationHover;

  const HoverWrapper({
    super.key,
    required this.child,
    required this.hoverColor,
    this.baseColor,
    this.hoverTextColor,
    this.baseTextColor,
    this.borderRadius,
    this.borderEndLeftRadius,
    this.borderEndRightRadius,
    this.borderStartLeftRadius,
    this.borderStartRightRadius,
    this.onTap,
    this.scaleOnHover = 1.0,
    this.translateOnHover = 0.0,
    this.boxShadowHover,
    this.baseBoxShadow,
    this.durationHover,
  });

  // Este método conecta el widget con su estado (_HoverWrapperState)
  // Flutter llama a esto para saber qué lógica usar

/*Nota: El nombre de la clase del estado comienza con un guion bajo (_) para indicar que es privada, lo que significa
que solo se puede usar dentro de este archivo. Esto es una convención en Dart para encapsular la lógica y evitar que
otras partes del código accedan directamente a ella.
*/
  @override
  State<HoverWrapper> createState() => _HoverWrapperState();
}

class _HoverWrapperState extends State<HoverWrapper> {
  bool _isHovered = false;
  bool _isFocus = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = _isHovered
        ? widget.hoverColor
        : (widget.baseColor ?? Colors.transparent);
    final effectiveText = _isHovered
        ? (widget.hoverTextColor ?? widget.baseTextColor)
        : widget.baseTextColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Focus(
          onFocusChange: (value) => setState(() => _isFocus = value),
          child: HoverData(
            isHovered: _isHovered,
            child: AnimatedScale(
              scale: _isHovered ? widget.scaleOnHover : 1.0,
              duration: Duration(milliseconds: widget.durationHover ?? 15),
              child: AnimatedContainer(
                duration: Duration(milliseconds: widget.durationHover ?? 15),
                transform: Matrix4.translationValues(
                  0,
                  _isHovered ? widget.translateOnHover : 0,
                  0,
                ),
                decoration: BoxDecoration(
                  color: effectiveBg,
                  borderRadius: _getBorderRadius(),
                  boxShadow: _isHovered || _isFocus
                      ? widget.boxShadowHover
                      : widget.baseBoxShadow,
                ),
                // Inyectamos el color a los hijos (Icons y Text)
                child: IconTheme(
                  data: IconThemeData(color: effectiveText),
                  child: DefaultTextStyle(
                    style: TextStyle(color: effectiveText),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _parserBorderRadius(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    final valores = parts.map((e) => double.tryParse(e) ?? 0.0).toList();
    switch (valores.length) {
      case 1:
        return BorderRadius.circular(valores[0]);
      case 2:
        return BorderRadius.only(
          topLeft: Radius.circular(valores[0]),
          topRight: Radius.circular(valores[1]),
          bottomLeft: Radius.circular(valores[1]),
          bottomRight: Radius.circular(valores[0]),
        );
      case 3:
        return BorderRadius.only(
          topLeft: Radius.circular(valores[0]),
          topRight: Radius.circular(valores[1]),
          bottomLeft: Radius.circular(valores[2]),
          bottomRight: Radius.circular(valores[1]),
        );
      case 4:
        return BorderRadius.only(
          topLeft: Radius.circular(valores[0]),
          topRight: Radius.circular(valores[1]),
          bottomRight: Radius.circular(valores[2]),
          bottomLeft: Radius.circular(valores[3]),
        );
      default:
        return BorderRadius.zero;
    }
  }

  BorderRadius _getBorderRadius() {
    if (widget.borderRadius != null)
      return _parserBorderRadius(widget.borderRadius!);
    return BorderRadius.only(
      topLeft: Radius.circular(widget.borderStartLeftRadius ?? 0),
      topRight: Radius.circular(widget.borderStartRightRadius ?? 0),
      bottomLeft: Radius.circular(widget.borderEndLeftRadius ?? 0),
      bottomRight: Radius.circular(widget.borderEndRightRadius ?? 0),
    );
  }
}
