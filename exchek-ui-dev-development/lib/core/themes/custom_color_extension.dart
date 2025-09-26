import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.primaryColor,
    required this.textdarkcolor,
    required this.darktextcolor,
    required this.fillColor,
    required this.secondaryTextColor,
    required this.shadowColor,
    required this.blackColor,
    required this.borderColor,
    required this.greenColor,
    required this.purpleColor,
    required this.lightBackgroundColor,
    required this.redColor,
    required this.darkShadowColor,
    required this.dividerColor,
    required this.iconColor,
    required this.darkBlueColor,
    required this.lightPurpleColor,
    required this.hintTextColor,
    required this.lightUnSelectedBGColor,
    required this.lightBorderColor,
    required this.disabledColor,
    required this.boxBgColor,
    required this.boxBorderColor,
    required this.blueColor,
    required this.hoverShadowColor,
    required this.hoverBorderColor,
    required this.errorColor,
    required this.lightBlueColor,
    required this.lightBlueBorderColor,
    required this.darkBlueTextColor,
    required this.blueTextColor,
    required this.drawerIconColor,
    required this.darkGreyColor,
    required this.badgeColor,
    required this.greyTextColor,
    required this.greyBorderPaginationColor,
    required this.paginationTextColor,
    required this.tableHeaderColor,
    required this.greentextColor,
    required this.redtextColor,
    required this.tableBorderColor,
    required this.filtercheckboxcolor,
    required this.filtercheckboxunselectedcolor,
    required this.filterbordercolor,
    required this.daterangecolor,
    required this.lightBoxBGColor,
    required this.lightDividerColor,
    required this.lightGreyColor,
  });

  final Color? primaryColor;
  final Color? textdarkcolor;
  final Color? darktextcolor;
  final Color? fillColor;
  final Color? secondaryTextColor;
  final Color? shadowColor;
  final Color? blackColor;
  final Color? borderColor;
  final Color? greenColor;
  final Color? purpleColor;
  final Color? lightBackgroundColor;
  final Color? redColor;
  final Color? darkShadowColor;
  final Color? dividerColor;
  final Color? iconColor;
  final Color? darkBlueColor;
  final Color? lightPurpleColor;
  final Color? hintTextColor;
  final Color? lightUnSelectedBGColor;
  final Color? lightBorderColor;
  final Color? disabledColor;
  final Color? boxBgColor;
  final Color? boxBorderColor;
  final Color? blueColor;
  final Color? hoverShadowColor;
  final Color? hoverBorderColor;
  final Color? errorColor;
  final Color? lightBlueColor;
  final Color? lightBlueBorderColor;
  final Color? darkBlueTextColor;
  final Color? blueTextColor;
  final Color? drawerIconColor;
  final Color? darkGreyColor;
  final Color? badgeColor;
  final Color? greyTextColor;
  final Color? greyBorderPaginationColor;
  final Color? paginationTextColor;
  final Color? tableHeaderColor;
  final Color? greentextColor;
  final Color? redtextColor;
  final Color? tableBorderColor;
  final Color? filtercheckboxcolor;
  final Color? filtercheckboxunselectedcolor;
  final Color? filterbordercolor;
  final Color? daterangecolor;
  final Color? lightBoxBGColor;
  final Color? lightDividerColor;
  final Color? lightGreyColor;
  // Default light theme colors
  static const light = CustomColors(
    primaryColor: Color(0xFF4E55F4),
    textdarkcolor: Color(0xFF6B7588),
    darktextcolor: Color(0xFF6B7588),
    fillColor: Color(0xFFFFFFFF),
    secondaryTextColor: Color(0xFF414143),
    shadowColor: Color(0xFF101828),
    blackColor: Color(0xFF000000),
    borderColor: Color(0xffD4D7E3),
    greenColor: Color(0xFF009956),
    purpleColor: Color(0xFF7F56D9),
    lightBackgroundColor: Color(0xFFD7DDF4),
    redColor: Color(0xFFF53D5D),
    darkShadowColor: Color(0xFF051D3D),
    dividerColor: Color(0xFFCFD4E2),
    iconColor: Color(0xFF292D32),
    darkBlueColor: Color(0xFF313957),
    lightPurpleColor: Color(0xFFEBECF4),
    hintTextColor: Color(0xFF313957),
    lightUnSelectedBGColor: Color(0xFFF8F9FD),
    lightBorderColor: Color(0xFFEBEEF9),
    disabledColor: Color(0xFFF7F7FC),
    boxBgColor: Color(0xFFE8E9FF),
    boxBorderColor: Color(0xFFD8DEF3),
    blueColor: Color(0xFF424AF3),
    hoverShadowColor: Color(0xFF99BBFF),
    hoverBorderColor: Color(0xFFB4B7D1),
    errorColor: Color(0xFFD91807),
    lightBlueColor: Color(0xFFE6F4FB),
    lightBlueBorderColor: Color(0xFF9DC0EE),
    darkBlueTextColor: Color(0xFF2F3F53),
    blueTextColor: Color(0xFF343A3E),
    drawerIconColor: Color(0xFF4C5259),
    darkGreyColor: Color(0xFF9B9B9B),
    badgeColor: Color(0xFFFF2D55),
    greyTextColor: Color(0xFF666666),
    greyBorderPaginationColor: Color(0xFFD5D5D5),
    paginationTextColor: Color(0xFF202224),
    tableHeaderColor: Color(0xFFEBF3FC),
    greentextColor: Color(0xff17A05E),
    redtextColor: Color(0xffEF3826),
    tableBorderColor: Color(0xffC1C1C1),
    filtercheckboxcolor: Color(0XFFD8E6FD),
    filtercheckboxunselectedcolor: Color(0XFFA1A1AA),
    filterbordercolor: Color(0XFFDFDFDF),
    daterangecolor: Color(0XFFDCE9FF),
    lightBoxBGColor: Color(0xFFF6F6FA),
    lightDividerColor: Color(0xFFE8EAED),
    lightGreyColor: Color(0xFF6D6D6D),
  );

  // Default dark theme colors
  static const dark = CustomColors(
    primaryColor: Color(0xFF4E55F4),
    textdarkcolor: Color(0xFF6B7588),
    darktextcolor: Color(0xFF6B7588),
    fillColor: Color(0xFFFFFFFF),
    secondaryTextColor: Color(0xFF414143),
    shadowColor: Color(0xFF101828),
    blackColor: Color(0xFF000000),
    borderColor: Color(0xffD4D7E3),
    greenColor: Color(0xFF009957),
    purpleColor: Color(0xFF7F56D9),
    lightBackgroundColor: Color(0xFFD7DDF4),
    redColor: Color(0xFFF53D5D),
    darkShadowColor: Color(0xFF051D3D),
    dividerColor: Color(0xFFCFD4E2),
    iconColor: Color(0xFF292D32),
    darkBlueColor: Color(0xFF313957),
    lightPurpleColor: Color(0xFFEBECF4),
    hintTextColor: Color(0xFF313957),
    lightUnSelectedBGColor: Color(0xFFF8F9FD),
    lightBorderColor: Color(0xFFEBEEF9),
    disabledColor: Color(0xFFF7F7FC),
    boxBgColor: Color(0xFFE8E9FF),
    boxBorderColor: Color(0xFFD8DEF3),
    blueColor: Color(0xFF424AF3),
    hoverShadowColor: Color(0xFF99BBFF),
    hoverBorderColor: Color(0xFFB4B7D1),
    errorColor: Color(0xFFD91807),
    lightBlueColor: Color(0xFFE6F4FB),
    lightBlueBorderColor: Color(0xFF9DC0EE),
    darkBlueTextColor: Color(0xFF2F3F53),
    blueTextColor: Color(0xFF343A3E),
    drawerIconColor: Color(0xFF4C5259),
    darkGreyColor: Color(0xFF9B9B9B),
    badgeColor: Color(0xFFFF2D55),
    greyTextColor: Color(0xFF666666),
    greyBorderPaginationColor: Color(0xFFD5D5D5),
    paginationTextColor: Color(0xFF202224),
    tableHeaderColor: Color(0xFFEBF3FC),
    greentextColor: Color(0xff17A05E),
    redtextColor: Color(0xffEF3826),
    tableBorderColor: Color(0xffC1C1C1),
    filtercheckboxcolor: Color(0XFFD8E6FD),
    filtercheckboxunselectedcolor: Color(0XFFA1A1AA),
    filterbordercolor: Color(0XFFDFDFDF),
    daterangecolor: Color(0XFFDCE9FF),
    lightBoxBGColor: Color(0xFFF6F6FA),
    lightDividerColor: Color(0xFFE8EAED),
    lightGreyColor: Color(0xFF6D6D6D),
  );

  @override
  CustomColors copyWith({
    Color? primaryColor,
    Color? textdarkcolor,
    Color? darktextcolor,
    Color? fillColor,
    Color? secondaryTextColor,
    Color? shadowColor,
    Color? blackColor,
    Color? borderColor,
    Color? greenColor,
    Color? purpleColor,
    Color? lightBackgroundColor,
    Color? redColor,
    Color? darkShadowColor,
    Color? dividerColor,
    Color? iconColor,
    Color? darkBlueColor,
    Color? lightPurpleColor,
    Color? hintTextColor,
    Color? lightUnSelectedBGColor,
    Color? lightBorderColor,
    Color? disabledColor,
    Color? boxBgColor,
    Color? boxBorderColor,
    Color? blueColor,
    Color? hoverShadowColor,
    Color? hoverBorderColor,
    Color? errorColor,
    Color? lightBlueColor,
    Color? lightBlueBorderColor,
    Color? darkBlueTextColor,
    Color? blueTextColor,
    Color? drawerIconColor,
    Color? darkGreyColor,
    Color? badgeColor,
    Color? greyTextColor,
    Color? greyBorderPaginationColor,
    Color? paginationTextColor,
    Color? tableHeaderColor,
    Color? greentextColor,
    Color? redtextColor,
    Color? tableBorderColor,
    Color? filtercheckboxcolor,
    Color? filtercheckboxunselectedcolor,
    Color? filterbordercolor,
    Color? daterangecolor,
    Color? lightBoxBGColor,
    Color? lightDividerColor,
    Color? lightGreyColor,
  }) {
    return CustomColors(
      primaryColor: primaryColor ?? this.primaryColor,
      darktextcolor: darktextcolor ?? this.darktextcolor,
      fillColor: fillColor ?? this.fillColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      shadowColor: shadowColor ?? this.shadowColor,
      blackColor: blackColor ?? this.blackColor,
      borderColor: borderColor ?? this.borderColor,
      greenColor: greenColor ?? this.greenColor,
      purpleColor: purpleColor ?? this.purpleColor,
      lightBackgroundColor: lightBackgroundColor ?? this.lightBackgroundColor,
      redColor: redColor ?? this.redColor,
      darkShadowColor: darkShadowColor ?? this.darkShadowColor,
      dividerColor: dividerColor ?? this.dividerColor,
      iconColor: iconColor ?? this.iconColor,
      darkBlueColor: darkBlueColor ?? this.darkBlueColor,
      lightPurpleColor: lightPurpleColor ?? this.lightPurpleColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      textdarkcolor: textdarkcolor ?? this.textdarkcolor,
      lightUnSelectedBGColor: lightUnSelectedBGColor ?? this.lightUnSelectedBGColor,
      lightBorderColor: lightBorderColor ?? this.lightBorderColor,
      disabledColor: disabledColor ?? this.disabledColor,
      boxBgColor: boxBgColor ?? this.boxBgColor,
      boxBorderColor: boxBorderColor ?? this.boxBorderColor,
      blueColor: blueColor ?? this.blueColor,
      hoverShadowColor: hoverShadowColor ?? this.hoverShadowColor,
      hoverBorderColor: hoverBorderColor ?? this.hoverBorderColor,
      errorColor: errorColor ?? this.errorColor,
      lightBlueColor: lightBlueColor ?? this.lightBlueColor,
      lightBlueBorderColor: lightBlueBorderColor ?? this.lightBlueBorderColor,
      darkBlueTextColor: darkBlueTextColor ?? this.darkBlueTextColor,
      blueTextColor: blueTextColor ?? this.blueTextColor,
      drawerIconColor: drawerIconColor ?? this.drawerIconColor,
      darkGreyColor: darkGreyColor ?? this.darkGreyColor,
      badgeColor: badgeColor ?? this.badgeColor,
      greyTextColor: greyTextColor ?? this.greyTextColor,
      greyBorderPaginationColor: greyBorderPaginationColor ?? this.greyBorderPaginationColor,
      paginationTextColor: paginationTextColor ?? this.paginationTextColor,
      tableHeaderColor: tableHeaderColor ?? this.tableHeaderColor,
      greentextColor: greentextColor ?? this.greentextColor,
      redtextColor: redtextColor ?? this.redtextColor,
      tableBorderColor: tableBorderColor ?? this.tableBorderColor,
      filtercheckboxcolor: filtercheckboxcolor ?? this.filtercheckboxcolor,
      filtercheckboxunselectedcolor: filtercheckboxunselectedcolor ?? this.filtercheckboxunselectedcolor,
      filterbordercolor: filterbordercolor ?? this.filterbordercolor,
      daterangecolor: daterangecolor ?? this.daterangecolor,
      lightBoxBGColor: lightBoxBGColor ?? this.lightBoxBGColor,
      lightDividerColor: lightDividerColor ?? this.lightDividerColor,
      lightGreyColor: lightGreyColor ?? this.lightGreyColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
      textdarkcolor: Color.lerp(textdarkcolor, other.textdarkcolor, t),
      darktextcolor: Color.lerp(darktextcolor, other.darktextcolor, t),
      fillColor: Color.lerp(fillColor, other.fillColor, t),
      secondaryTextColor: Color.lerp(secondaryTextColor, other.secondaryTextColor, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      blackColor: Color.lerp(blackColor, other.blackColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      greenColor: Color.lerp(greenColor, other.greenColor, t),
      purpleColor: Color.lerp(purpleColor, other.purpleColor, t),
      lightBackgroundColor: Color.lerp(lightBackgroundColor, other.lightBackgroundColor, t),
      redColor: Color.lerp(redColor, other.redColor, t),
      darkShadowColor: Color.lerp(darkShadowColor, other.darkShadowColor, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      darkBlueColor: Color.lerp(darkBlueColor, other.darkBlueColor, t),
      lightPurpleColor: Color.lerp(lightPurpleColor, other.lightPurpleColor, t),
      hintTextColor: Color.lerp(hintTextColor, other.hintTextColor, t),
      lightUnSelectedBGColor: Color.lerp(lightUnSelectedBGColor, other.lightUnSelectedBGColor, t),
      lightBorderColor: Color.lerp(lightBorderColor, other.lightBorderColor, t),
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t),
      boxBgColor: Color.lerp(boxBgColor, other.boxBgColor, t),
      boxBorderColor: Color.lerp(boxBorderColor, other.boxBorderColor, t),
      blueColor: Color.lerp(blueColor, other.blueColor, t),
      hoverShadowColor: Color.lerp(hoverShadowColor, other.hoverShadowColor, t),
      hoverBorderColor: Color.lerp(hoverBorderColor, other.hoverBorderColor, t),
      errorColor: Color.lerp(errorColor, other.errorColor, t),
      lightBlueColor: Color.lerp(lightBlueColor, other.lightBlueColor, t),
      lightBlueBorderColor: Color.lerp(lightBlueBorderColor, other.lightBlueBorderColor, t),
      darkBlueTextColor: Color.lerp(darkBlueTextColor, other.darkBlueTextColor, t),
      blueTextColor: Color.lerp(blueTextColor, other.blueTextColor, t),
      drawerIconColor: Color.lerp(drawerIconColor, other.drawerIconColor, t),
      darkGreyColor: Color.lerp(darkGreyColor, other.darkGreyColor, t),
      badgeColor: Color.lerp(badgeColor, other.badgeColor, t),
      greyTextColor: Color.lerp(greyTextColor, other.greyTextColor, t),
      greyBorderPaginationColor: Color.lerp(greyBorderPaginationColor, other.greyBorderPaginationColor, t),
      paginationTextColor: Color.lerp(paginationTextColor, other.paginationTextColor, t),
      tableHeaderColor: Color.lerp(tableHeaderColor, other.tableHeaderColor, t),
      greentextColor: Color.lerp(greentextColor, other.greentextColor, t),
      redtextColor: Color.lerp(redtextColor, other.redtextColor, t),
      tableBorderColor: Color.lerp(tableBorderColor, other.tableBorderColor, t),
      filtercheckboxcolor: Color.lerp(filtercheckboxcolor, other.filtercheckboxcolor, t),
      filtercheckboxunselectedcolor: Color.lerp(filtercheckboxunselectedcolor, other.filtercheckboxunselectedcolor, t),
      filterbordercolor: Color.lerp(filterbordercolor, other.filterbordercolor, t),
      daterangecolor: Color.lerp(daterangecolor, other.daterangecolor, t),
      lightBoxBGColor: Color.lerp(lightBoxBGColor, other.lightBoxBGColor, t),
      lightDividerColor: Color.lerp(lightDividerColor, other.lightDividerColor, t),
      lightGreyColor: Color.lerp(lightGreyColor, other.lightGreyColor, t),
    );
  }
}

extension ThemeDataCustomColors on ThemeData {
  CustomColors get customColors {
    final customColors = extension<CustomColors>();
    if (customColors == null) {
      return CustomColors.light;
    }
    return customColors;
  }
}
