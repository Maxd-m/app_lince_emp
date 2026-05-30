import 'package:flutter/material.dart';
import 'package:app_lince_emp/core/desings/flex_config.dart';
import 'package:app_lince_emp/core/utils/hover_extension.dart';
import 'package:app_lince_emp/core/utils/size_extension.dart';

/*Nota: Cuando se crea un widget con estado (StatefulWidget), se necesita definir dos clases:
   1. La clase del widget en sí (Slidebar) que extiende StatefulWidget.
   2. La clase del estado asociado (_SlidebarState) que extiende State<Slidebar>.

   El widget es la parte visual, mientras que el estado maneja la lógica y los cambios.
   En otras palabras, el widget es lo que ves, y el estado es lo que hace que ese widget cambie o se actualice.

   Cuando solo se necesita una clase, es porque el widget no tiene estado (StatelessWidget), lo que significa
   que no cambia después de ser construido. En ese caso, toda la lógica y la apariencia se manejan en una sola clase.
   Es por eso que se manejan dos clases en los widgets con estado.
   Esto esta diseñado asi porque flutter gestiona la parte visual y puede ejecutarla por separado de lo que tiene que hacer
   el widget, eso permite que solo tenga que actualizar una parte del la pantalla sin tener que reconstruir todo el widget.

 */

class FlexBox extends StatelessWidget {
  //Diseño de caja flexible personalizado para facilitar la creación de layouts responsivos y flexibles en Flutter.

  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow, boxShadowHover, baseBoxShadow;

  final List<Widget> children;

  final Color? backgroundColor, borderColor;

  final String flexDirection, verticalAlignment, horizontalAlignment;
  final String? padding, margin, borderRadius;

  final bool expanded;

  final double? width,
      height,
      widthPercent,
      heightPercent,
      parentWidthPercent,
      parentHeightPercent,
      gap,
      paddingHorizontal,
      paddingVertical,
      paddingTop,
      paddingBottom,
      paddingLeft,
      paddingRight,
      borderEndLeftRadius,
      borderEndRightRadius,
      borderStartLeftRadius,
      borderStartRightRadius,
      marginHorizontal,
      marginVertical,
      marginTop,
      marginBottom,
      marginLeft,
      marginRight,
      borderWidth;

      final int? durationHover;

  // Constructor del widget con parámetros opcionales y requeridos
  const FlexBox({
    // super.key permite que Flutter identifique este widget en el árbol (optimización)
    super.key,
    required this.children,
    this.flexDirection = 'column',
    this.verticalAlignment = 'start',
    this.horizontalAlignment = 'start',
    this.expanded = false,
    this.backgroundColor,
    this.gap,
    this.width,
    this.height,
    this.widthPercent,
    this.heightPercent,
    this.parentWidthPercent,
    this.parentHeightPercent,
    this.padding,
    this.paddingHorizontal,
    this.paddingVertical,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.borderRadius,
    this.borderEndLeftRadius,
    this.borderEndRightRadius,
    this.borderStartLeftRadius,
    this.borderStartRightRadius,
    this.margin,
    this.marginHorizontal,
    this.marginVertical,
    this.marginTop,
    this.marginBottom,
    this.marginLeft,
    this.marginRight,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.boxShadowHover,
    this.baseBoxShadow,
    this.durationHover,
    this.onTap,
  });

  // Método de construcción del widget, donde se define cómo se verá y se comportará pero predefinido por el config como en css
  static Widget styled(
    FlexConfig config, {
    required List<Widget> children,
    VoidCallback? onTap,
  }) {
    // 1. Creamos el FlexBox base con los datos del config
    Widget box = FlexBox(
      flexDirection: config.flexDirection,
      verticalAlignment: config.verticalAlignment,
      horizontalAlignment: config.horizontalAlignment,
      backgroundColor: config.backgroundColor,
      gap: config.gap,
      width: config.width,
      height: config.height,
      widthPercent: config.widthPercent,
      heightPercent: config.heightPercent,
      parentWidthPercent: config.parentWidthPercent,
      parentHeightPercent: config.parentHeightPercent,
      padding: config.padding,
      paddingHorizontal: config.paddingHorizontal,
      paddingVertical: config.paddingVertical,
      paddingTop: config.paddingTop,
      paddingBottom: config.paddingBottom,
      paddingLeft: config.paddingLeft,
      paddingRight: config.paddingRight,
      borderRadius: config.borderRadius,
      borderEndLeftRadius: config.borderEndLeftRadius,
      borderEndRightRadius: config.borderEndRightRadius,
      borderStartLeftRadius: config.borderStartLeftRadius,
      borderStartRightRadius: config.borderStartRightRadius,
      margin: config.margin,
      marginHorizontal: config.marginHorizontal,
      marginVertical: config.marginVertical,
      marginTop: config.marginTop,
      marginBottom: config.marginBottom,
      marginLeft: config.marginLeft,
      marginRight: config.marginRight,
      borderColor: config.borderColor,
      borderWidth: config.borderWidth,
      expanded: config.expanded,
      boxShadow: config.boxShadow,
      children: children,
    );

    // 2. Si el estilo tiene hoverColor, le aplicamos el superpoder automáticamente
    if (config.hoverColor != null) {
      box = box.withHover(
        hoverColor: config.hoverColor!,
        hoverTextColor: config.hoverTextColor,
        baseColor: config.baseColor,
        baseTextColor: config.baseTextColor,
        borderRadius: config.hoverBorderRadius,
        borderEndLeftRadius: config.hoverBorderRadiusEndLeft,
        borderEndRightRadius: config.hoverBorderRadiusEndRight,
        borderStartLeftRadius: config.hoverBorderRadiusStartLeft,
        borderStartRightRadius: config.hoverBorderRadiusStartRight,
        boxShadowHover: config.boxShadowHover,
        baseBoxShadow: config.baseBoxShadow,
        durationHover: config.durationHover,
        scale: config.scale,
        onTap: onTap,
      );
    }

    return box;
  }

  @override
  // Crea el estado asociado a este widget
  Widget build(BuildContext context) {
    return Container(
      padding: _getPadding(),
      margin: _getMargin(),
      width: _getFinalWidth(context),
      height: _getFinalHeight(context),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: _getBorderRadius(),
        border: borderColor != null && borderWidth != null
            ? Border.all(color: borderColor!, width: borderWidth!)
            : null,
        boxShadow: boxShadow,
      ),
      child: _buildChild(),
    );
  }

  double? _getFinalWidth(BuildContext context) {
    if (widthPercent != null) {
      if (parentWidthPercent != null) {
        // Lógica: (Pixeles del padre) * (Mi % / 100)
        return context.wP(parentWidthPercent!) * (widthPercent! / 100);
      }
      // Si no hay padre, asume que es % de la pantalla directamente
      return context.wP(widthPercent!);
    }
    return width;
  }

  double? _getFinalHeight(BuildContext context) {
    if (heightPercent != null) {
      if (parentHeightPercent != null) {
        return context.hP(parentHeightPercent!) * (heightPercent! / 100);
      }
      return context.hP(heightPercent!);
    }
    return height;
  }

  MainAxisAlignment _parseMainAlign(String align) {
    return switch (align) {
      'start' => MainAxisAlignment.start,
      'center' => MainAxisAlignment.center,
      'end' => MainAxisAlignment.end,
      'spaceBetween' => MainAxisAlignment.spaceBetween,
      'spaceAround' => MainAxisAlignment.spaceAround,
      'spaceEvenly' => MainAxisAlignment.spaceEvenly,
      _ => MainAxisAlignment.start,
    };
  }

  CrossAxisAlignment _parseCrossAlign(String align) {
    return switch (align) {
      'start' => CrossAxisAlignment.start,
      'center' => CrossAxisAlignment.center,
      'end' => CrossAxisAlignment.end,
      'stretch' => CrossAxisAlignment.stretch,
      _ => CrossAxisAlignment.start,
    };
  }

  EdgeInsets _getMargin() {
    if (margin != null) return _parser(margin!);
    if (marginHorizontal != null || marginVertical != null) {
      return EdgeInsets.symmetric(
        horizontal: marginHorizontal ?? 0,
        vertical: marginVertical ?? 0,
      );
    }
    return EdgeInsets.only(
      top: marginTop ?? 0,
      bottom: marginBottom ?? 0,
      left: marginLeft ?? 0,
      right: marginRight ?? 0,
    );
  }

  EdgeInsets _getPadding() {
    if (padding != null) return _parser(padding!);
    if (paddingHorizontal != null || paddingVertical != null) {
      return EdgeInsets.symmetric(
        horizontal: paddingHorizontal ?? 0,
        vertical: paddingVertical ?? 0,
      );
    }
    return EdgeInsets.only(
      top: paddingTop ?? 0,
      bottom: paddingBottom ?? 0,
      left: paddingLeft ?? 0,
      right: paddingRight ?? 0,
    );
  }

  EdgeInsets _parser(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    final valores = parts.map((e) => double.tryParse(e) ?? 0.0).toList();
    switch (valores.length) {
      case 1:
        return EdgeInsets.all(valores[0]);
      case 2:
        return EdgeInsets.symmetric(
          vertical: valores[0],
          horizontal: valores[1],
        );
      case 3:
        return EdgeInsets.only(
          top: valores[0],
          left: valores[1],
          right: valores[1],
          bottom: valores[2],
        );
      case 4:
        return EdgeInsets.only(
          top: valores[0],
          right: valores[1],
          bottom: valores[2],
          left: valores[3],
        );
      default:
        return EdgeInsets.zero;
    }
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
    if (borderRadius != null) return _parserBorderRadius(borderRadius!);
    return BorderRadius.only(
      topLeft: Radius.circular(borderStartLeftRadius ?? 0),
      topRight: Radius.circular(borderStartRightRadius ?? 0),
      bottomLeft: Radius.circular(borderEndLeftRadius ?? 0),
      bottomRight: Radius.circular(borderEndRightRadius ?? 0),
    );
  }

  Widget _buildChild() {
    final isColumn = flexDirection == 'column';
    return isColumn
        ? Column(
            mainAxisAlignment: _parseMainAlign(verticalAlignment),
            crossAxisAlignment: _parseCrossAlign(horizontalAlignment),
            spacing: gap ?? 0,
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            children: children,
          )
        : Row(
            mainAxisAlignment: _parseMainAlign(horizontalAlignment),
            crossAxisAlignment: _parseCrossAlign(verticalAlignment),
            spacing: gap ?? 0,
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            children: children,
          );
  }
}
