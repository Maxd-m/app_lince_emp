import 'package:flutter/material.dart';
import 'package:app_lince_emp/core/desings/flex_config.dart';
import 'package:app_lince_emp/core/desings/input_select_config.dart';
import 'package:app_lince_emp/core/desings/text_field_config.dart';
import 'package:app_lince_emp/core/desings/text_config.dart';
import 'package:app_lince_emp/core/theme/app_colors.dart';

// Sombras suaves para tarjetas (Cards)
final List<BoxShadow> shadowSm = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.5),
    blurRadius: 10,
    offset: const Offset(4, 4), // Sombra hacia abajo
  ),
];

// Sombra más fuerte para modales o elementos flotantes
final List<BoxShadow> shadowLg = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.3),
    blurRadius: 20,
    offset: const Offset(0, 10),
  ),
];

final List<BoxShadow> shadowAppBar = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.1),
    blurRadius: 10,
    offset: const Offset(0, 1),
  ),
];

final List<BoxShadow> shadowCard = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.1),
    blurRadius: 5,
    offset: const Offset(0, 2),
  ),
];

final sidebar = FlexConfig(
  widthPercent: 18,
  heightPercent: 97,
  padding: '0 0 40 0',
  backgroundColor: AppColors.sidebarBackground,
  borderRadius: '0 0 50 0',
  boxShadow: shadowSm,
);

final sidebarElement = FlexConfig(
  parentWidthPercent: 15,
  widthPercent: 80,
  height: 35,
  paddingLeft: 20,
  flexDirection: 'row',
  borderRadius: '0 50 50 0',
  verticalAlignment: 'center',
  gap: 20,
  hoverColor: AppColors.iconSidebar,
  hoverTextColor: Colors.black,
  baseTextColor: AppColors.iconSidebar,
  hoverBorderRadius: '8',
  scale: 1.05,
);

final sidebarElementList = FlexConfig(
  widthPercent: 18,
  margin: '40 0 0 0',
  padding: '0 0 0 40',
  borderWidth: 1,
  gap: 15,
);
final sidebarText = TextConfig(fontSize: 16);

final sidebarFooterText = TextConfig(
  fontSize: 16,
  color: AppColors.iconSidebar,
);

final sidebarFooterSecondaryText = TextConfig(
  fontSize: 12,
  color: AppColors.textSecondary,
);

final sidebarFooter = FlexConfig(
  flexDirection: 'row',
  horizontalAlignment: 'center',
  verticalAlignment: 'center',
  padding: '0 0 0 50',
  gap: 20,
);



final appBar = FlexConfig(
  flexDirection: 'row',
  verticalAlignment: 'center',
  heightPercent: 12,
  widthPercent: 100,
  padding: "10 50 10 0",
  backgroundColor: Colors.white,
  horizontalAlignment: 'end',
  boxShadow: shadowAppBar,
);

final mainContainer = FlexConfig(
  flexDirection: 'row',
  expanded: true,
  height: double.infinity,
  backgroundColor: AppColors.bgPrimary,
);

final slidebarSpace = FlexConfig(widthPercent: 18, heightPercent: 100);

final bodySpace = FlexConfig(widthPercent: 82, heightPercent: 100);

final bodyContainer = FlexConfig(
  padding: '20 30',
  widthPercent: 100,
  heightPercent: 80,
);

final cardContainer = FlexConfig(
  borderRadius: '10',
  widthPercent: 100,
  parentWidthPercent: 77,
  heightPercent: 75,
  parentHeightPercent: 88,
  marginTop: 10,
);

final card = FlexConfig(
  backgroundColor: Colors.white, // Un gris muy tenue
  borderRadius: '12',
  padding: '0 25',
  flexDirection: 'column',
  horizontalAlignment: 'center',
  verticalAlignment: 'center',
  boxShadow: shadowCard,
  gap: 10,
  boxShadowHover: shadowLg,
  hoverTextColor: Colors.blue,
  baseTextColor: AppColors.textPrimary,
  hoverColor: Colors.transparent,
  durationHover: 200,
  scale: 1.02,
);

final cardText = FlexConfig(
  flexDirection: 'row',
  horizontalAlignment: 'start',
  expanded: true,
);

final cardButton = FlexConfig(
  flexDirection: 'row',
  backgroundColor: Colors.black,
  verticalAlignment: 'center',
  horizontalAlignment: 'center',
  width: 100,
  gap: 10,
  height: 30,
  borderRadius: '50',
  hoverColor: Colors.transparent,
  scale: 1.05,
);

final cardTextField = TextFieldConfig(
  borderColor: AppColors.borderTextField,
  borderRadius: 10,
  borderSelectedColor: AppColors.selectedWidegets,
  paddingVertical: 10,
  paddingHorizontal: 10,
  hintTextColor: AppColors.borderTextField,
  height: 40,
  boxShadowHover: shadowCard,
);

final cardOverlay = FlexConfig(
  widthPercent: 100,
  heightPercent: 100,
  horizontalAlignment: 'center',
  verticalAlignment: 'center',
  backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
);

final cardForm = FlexConfig(
  heightPercent: 80,
  widthPercent: 50,
  backgroundColor: Colors.white,
  borderRadius: '20',
  padding: '20 30',
);

final cardFormTitle = FlexConfig(
  flexDirection: 'row',
  horizontalAlignment: 'start',
  gap: 10,
  padding: '20 10',
);

final cardFormFooter = FlexConfig(
  flexDirection: 'row',
  expanded: true,
  gap: 10,

  margin: '20 0',
  horizontalAlignment: 'end',
  verticalAlignment: 'center',
);

final cardFormTitleText = TextConfig(
  color: AppColors.textPrimary,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

final cardLabel = TextConfig(

  fontWeight: FontWeight.normal,
  color: AppColors.textPrimary,
);

final cardInputSelect = InputselectConfig(
  borderColorHover: AppColors.selectedWidegets,
  boxShadowHover: shadowCard,
);
