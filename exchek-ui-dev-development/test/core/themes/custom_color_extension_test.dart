import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/themes/custom_color_extension.dart';

void main() {
  group('CustomColors Tests', () {
    group('Light Theme Colors', () {
      testWidgets('should have correct light theme color values', (WidgetTester tester) async {
        const lightColors = CustomColors.light;

        expect(lightColors.primaryColor, const Color(0xFF4E55F4));
        expect(lightColors.textdarkcolor, const Color(0xFF6B7588));
        expect(lightColors.darktextcolor, const Color(0xFF6B7588));
        expect(lightColors.fillColor, const Color(0xFFFFFFFF));
        expect(lightColors.secondaryTextColor, const Color(0xFF414143));
        expect(lightColors.shadowColor, const Color(0xFF101828));
        expect(lightColors.blackColor, const Color(0xFF000000));
        expect(lightColors.borderColor, const Color(0xffD4D7E3));
        expect(lightColors.greenColor, const Color(0xFF009956));
        expect(lightColors.purpleColor, const Color(0xFF7F56D9));
        expect(lightColors.lightBackgroundColor, const Color(0xFFD7DDF4));
        expect(lightColors.redColor, const Color(0xFFF53D5D));
        expect(lightColors.darkShadowColor, const Color(0xFF051D3D));
        expect(lightColors.dividerColor, const Color(0xFFCFD4E2));
        expect(lightColors.iconColor, const Color(0xFF292D32));
        expect(lightColors.darkBlueColor, const Color(0xFF313957));
        expect(lightColors.lightPurpleColor, const Color(0xFFEBECF4));
        expect(lightColors.hintTextColor, const Color(0xFF313957));
        expect(lightColors.lightUnSelectedBGColor, const Color(0xFFF8F9FD));
        expect(lightColors.lightBorderColor, const Color(0xFFEBEEF9));
        expect(lightColors.disabledColor, const Color(0xFFF7F7FC));
        expect(lightColors.blueTextColor, const Color(0xFF343A3E));
        expect(lightColors.greyBorderPaginationColor, const Color(0xFFD5D5D5));
        expect(lightColors.tableHeaderColor, const Color(0xFFF8F9FD));
        expect(lightColors.greentextColor, const Color(0xFF009956));
        expect(lightColors.redtextColor, const Color(0xFFF53D5D));
        expect(lightColors.tableBorderColor, const Color(0xff979797));
        expect(lightColors.filtercheckboxcolor, const Color(0XFFD8E6FD));
        expect(lightColors.filtercheckboxunselectedcolor, const Color(0XFFA1A1AA));
        expect(lightColors.filterbordercolor, const Color(0XFFD8E6FD));
      });
    });

    group('Dark Theme Colors', () {
      testWidgets('should have correct dark theme color values', (WidgetTester tester) async {
        const darkColors = CustomColors.dark;

        expect(darkColors.primaryColor, const Color(0xFF4E55F4));
        expect(darkColors.textdarkcolor, const Color(0xFF6B7588));
        expect(darkColors.darktextcolor, const Color(0xFF6B7588));
        expect(darkColors.fillColor, const Color(0xFFFFFFFF));
        expect(darkColors.secondaryTextColor, const Color(0xFF414143));
        expect(darkColors.shadowColor, const Color(0xFF101828));
        expect(darkColors.blackColor, const Color(0xFF000000));
        expect(darkColors.borderColor, const Color(0xffD4D7E3));
        expect(darkColors.greenColor, const Color(0xFF009957)); // Note: slightly different from light
        expect(darkColors.purpleColor, const Color(0xFF7F56D9));
        expect(darkColors.lightBackgroundColor, const Color(0xFFD7DDF4));
        expect(darkColors.redColor, const Color(0xFFF53D5D));
        expect(darkColors.darkShadowColor, const Color(0xFF051D3D));
        expect(darkColors.dividerColor, const Color(0xFFCFD4E2));
        expect(darkColors.iconColor, const Color(0xFF292D32));
        expect(darkColors.darkBlueColor, const Color(0xFF313957));
        expect(darkColors.lightPurpleColor, const Color(0xFFEBECF4));
        expect(darkColors.hintTextColor, const Color(0xFF313957));
        expect(darkColors.lightUnSelectedBGColor, const Color(0xFFF8F9FD));
        expect(darkColors.lightBorderColor, const Color(0xFFEBEEF9));
        expect(darkColors.disabledColor, const Color(0xFFF7F7FC));
        expect(darkColors.blueTextColor, const Color(0xFF343A3E));
        expect(darkColors.greyBorderPaginationColor, const Color(0xFF4C5259));
        expect(darkColors.tableHeaderColor, const Color(0xFFF8F9FD));
        expect(darkColors.greentextColor, const Color(0xFF009956));
        expect(darkColors.redtextColor, const Color(0xFFF53D5D));
        expect(darkColors.tableBorderColor, const Color(0xff979797));
        expect(darkColors.filtercheckboxcolor, const Color(0XFFD8E6FD));
        expect(darkColors.filtercheckboxunselectedcolor, const Color(0XFFA1A1AA));
        expect(darkColors.filterbordercolor, const Color(0XFFD8E6FD));
        expect(darkColors.daterangecolor, const Color(0xFF4E55F4));
      });
    });

    group('CustomColors Constructor', () {
      testWidgets('should create CustomColors with all required parameters', (WidgetTester tester) async {
        const customColors = CustomColors(
          primaryColor: Color(0xFF123456),
          textdarkcolor: Color(0xFF234567),
          darktextcolor: Color(0xFF345678),
          fillColor: Color(0xFF456789),
          secondaryTextColor: Color(0xFF567890),
          shadowColor: Color(0xFF678901),
          blackColor: Color(0xFF789012),
          borderColor: Color(0xFF890123),
          greenColor: Color(0xFF901234),
          purpleColor: Color(0xFF012345),
          lightBackgroundColor: Color(0xFF123450),
          redColor: Color(0xFF234561),
          darkShadowColor: Color(0xFF345672),
          dividerColor: Color(0xFF456783),
          iconColor: Color(0xFF567894),
          darkBlueColor: Color(0xFF678905),
          lightPurpleColor: Color(0xFF789016),
          hintTextColor: Color(0xFF890127),
          lightUnSelectedBGColor: Color(0xFF901238),
          lightBorderColor: Color(0xFF012349),
          disabledColor: Color(0xFF123460),
          boxBgColor: Color(0xFF234571),
          boxBorderColor: Color(0xFF345682),
          blueColor: Color(0xFF456793),
          hoverShadowColor: Color(0xFF567804),
          hoverBorderColor: Color(0xFF678915),
          errorColor: Color(0xFFD91807),
          lightBlueColor: Color(0xFFE6F4FB),
          lightBlueBorderColor: Color(0xFF9DC0EE),
          darkBlueTextColor: Color(0xFF2F3F53),
          blueTextColor: Color(0xFF343A3E),
          drawerIconColor: Color(0xFF4C5259),
          darkGreyColor: Color(0xFF9B9B9B),
          badgeColor: Color(0xFFFF2D55),
          greyTextColor: Color(0xFF666666),
          greyBorderPaginationColor: Color(0xFF4C5259),
          paginationTextColor: Color(0xFF202224),
          tableHeaderColor: Color(0xFFF8F9FD),
          greentextColor: Color(0xFF009956),
          redtextColor: Color(0xFFF53D5D),
          tableBorderColor: Color(0xff979797),
          filtercheckboxcolor: Color(0XFFD8E6FD),
          filtercheckboxunselectedcolor: Color(0XFFA1A1AA),
          filterbordercolor: Color(0XFFD8E6FD),
          daterangecolor: Color(0xFF4E55F4),
          lightBoxBGColor: Color(0xFFF8F9FD),
          lightDividerColor: Color(0xFFE8EAED),
          lightGreyColor: Color(0xFF6D6D6D),
        );

        expect(customColors.primaryColor, const Color(0xFF123456));
        expect(customColors.textdarkcolor, const Color(0xFF234567));
        expect(customColors.darktextcolor, const Color(0xFF345678));
        expect(customColors.fillColor, const Color(0xFF456789));
        expect(customColors.secondaryTextColor, const Color(0xFF567890));
        expect(customColors.shadowColor, const Color(0xFF678901));
        expect(customColors.blackColor, const Color(0xFF789012));
        expect(customColors.borderColor, const Color(0xFF890123));
        expect(customColors.greenColor, const Color(0xFF901234));
        expect(customColors.purpleColor, const Color(0xFF012345));
        expect(customColors.lightBackgroundColor, const Color(0xFF123450));
        expect(customColors.redColor, const Color(0xFF234561));
        expect(customColors.darkShadowColor, const Color(0xFF345672));
        expect(customColors.dividerColor, const Color(0xFF456783));
        expect(customColors.iconColor, const Color(0xFF567894));
        expect(customColors.darkBlueColor, const Color(0xFF678905));
        expect(customColors.lightPurpleColor, const Color(0xFF789016));
        expect(customColors.hintTextColor, const Color(0xFF890127));
        expect(customColors.lightUnSelectedBGColor, const Color(0xFF901238));
        expect(customColors.lightBorderColor, const Color(0xFF012349));
        expect(customColors.disabledColor, const Color(0xFF123460));
        expect(customColors.boxBgColor, const Color(0xFF234571));
        expect(customColors.boxBorderColor, const Color(0xFF345682));
        expect(customColors.blueColor, const Color(0xFF456793));
        expect(customColors.hoverShadowColor, const Color(0xFF567804));
        expect(customColors.hoverBorderColor, const Color(0xFF678915));
        expect(customColors.blueTextColor, const Color(0xFF343A3E));
        expect(customColors.drawerIconColor, const Color(0xFF4C5259));
        expect(customColors.darkGreyColor, const Color(0xFF9B9B9B));
        expect(customColors.badgeColor, const Color(0xFFFF2D55));
        expect(customColors.greyTextColor, const Color(0xFF666666));
        expect(customColors.greyBorderPaginationColor, const Color(0xFF4C5259));
        expect(customColors.tableHeaderColor, const Color(0xFFF8F9FD));
        expect(customColors.greentextColor, const Color(0xFF009956));
        expect(customColors.redtextColor, const Color(0xFFF53D5D));
        expect(customColors.tableBorderColor, const Color(0xff979797));
        expect(customColors.filtercheckboxcolor, const Color(0XFFD8E6FD));
        expect(customColors.filtercheckboxunselectedcolor, const Color(0XFFA1A1AA));
        expect(customColors.filterbordercolor, const Color(0XFFD8E6FD));
      });
    });

    group('CopyWith Method', () {
      testWidgets('should copy with new values', (WidgetTester tester) async {
        const originalColors = CustomColors.light;

        final copiedColors = originalColors.copyWith(
          primaryColor: const Color(0xFF999999),
          fillColor: const Color(0xFF888888),
        );

        expect(copiedColors.primaryColor, const Color(0xFF999999));
        expect(copiedColors.fillColor, const Color(0xFF888888));
        // Other colors should remain the same
        expect(copiedColors.textdarkcolor, originalColors.textdarkcolor);
        expect(copiedColors.secondaryTextColor, originalColors.secondaryTextColor);
        expect(copiedColors.shadowColor, originalColors.shadowColor);
      });

      testWidgets('should copy with null values keeping original', (WidgetTester tester) async {
        const originalColors = CustomColors.light;

        final copiedColors = originalColors.copyWith();

        expect(copiedColors.primaryColor, originalColors.primaryColor);
        expect(copiedColors.fillColor, originalColors.fillColor);
        expect(copiedColors.textdarkcolor, originalColors.textdarkcolor);
        expect(copiedColors.secondaryTextColor, originalColors.secondaryTextColor);
      });

      testWidgets('should copy with partial values', (WidgetTester tester) async {
        const originalColors = CustomColors.light;

        final copiedColors = originalColors.copyWith(
          greenColor: const Color(0xFF111111),
          redColor: const Color(0xFF222222),
          borderColor: const Color(0xFF333333),
        );

        expect(copiedColors.greenColor, const Color(0xFF111111));
        expect(copiedColors.redColor, const Color(0xFF222222));
        expect(copiedColors.borderColor, const Color(0xFF333333));
        // Other colors should remain the same
        expect(copiedColors.primaryColor, originalColors.primaryColor);
        expect(copiedColors.fillColor, originalColors.fillColor);
        expect(copiedColors.filtercheckboxcolor, originalColors.filtercheckboxcolor);
        expect(copiedColors.filtercheckboxunselectedcolor, originalColors.filtercheckboxunselectedcolor);
        expect(copiedColors.filterbordercolor, originalColors.filterbordercolor);
      });
    });

    group('Lerp Method', () {
      testWidgets('should interpolate between two CustomColors', (WidgetTester tester) async {
        const color1 = CustomColors(
          primaryColor: Color(0xFF000000),
          textdarkcolor: Color(0xFF000000),
          darktextcolor: Color(0xFF000000),
          fillColor: Color(0xFF000000),
          secondaryTextColor: Color(0xFF000000),
          shadowColor: Color(0xFF000000),
          blackColor: Color(0xFF000000),
          borderColor: Color(0xFF000000),
          greenColor: Color(0xFF000000),
          purpleColor: Color(0xFF000000),
          lightBackgroundColor: Color(0xFF000000),
          redColor: Color(0xFF000000),
          darkShadowColor: Color(0xFF000000),
          dividerColor: Color(0xFF000000),
          iconColor: Color(0xFF000000),
          darkBlueColor: Color(0xFF000000),
          lightPurpleColor: Color(0xFF000000),
          hintTextColor: Color(0xFF000000),
          lightUnSelectedBGColor: Color(0xFF000000),
          lightBorderColor: Color(0xFF000000),
          disabledColor: Color(0xFF000000),
          boxBgColor: Color(0xFF000000),
          boxBorderColor: Color(0xFF000000),
          blueColor: Color(0xFF000000),
          hoverShadowColor: Color(0xFF000000),
          hoverBorderColor: Color(0xFF000000),
          errorColor: Color(0xFFD91807),
          lightBlueColor: Color(0xFFE6F4FB),
          lightBlueBorderColor: Color(0xFF9DC0EE),
          darkBlueTextColor: Color(0xFF2F3F53),
          blueTextColor: Color(0xFF343A3E),
          drawerIconColor: Color(0xFF4C5259),
          darkGreyColor: Color(0xFF9B9B9B),
          badgeColor: Color(0xFFFF2D55),
          greyTextColor: Color(0xFF666666),
          greyBorderPaginationColor: Color(0xFF4C5259),
          paginationTextColor: Color(0xFF202224),
          tableHeaderColor: Color(0xFFF8F9FD),
          greentextColor: Color(0xFF009956),
          redtextColor: Color(0xFFF53D5D),
          tableBorderColor: Color(0xff979797),
          filtercheckboxcolor: Color(0XFFD8E6FD),
          filtercheckboxunselectedcolor: Color(0XFFA1A1AA),
          filterbordercolor: Color(0XFFD8E6FD),
          daterangecolor: Color(0xFF4E55F4),
          lightBoxBGColor: Color(0xFFF8F9FD),
          lightDividerColor: Color(0xFFE8EAED),
          lightGreyColor: Color(0xFF6D6D6D),
        );

        const color2 = CustomColors(
          primaryColor: Color(0xFFFFFFFF),
          textdarkcolor: Color(0xFFFFFFFF),
          darktextcolor: Color(0xFFFFFFFF),
          fillColor: Color(0xFFFFFFFF),
          secondaryTextColor: Color(0xFFFFFFFF),
          shadowColor: Color(0xFFFFFFFF),
          blackColor: Color(0xFFFFFFFF),
          borderColor: Color(0xFFFFFFFF),
          greenColor: Color(0xFFFFFFFF),
          purpleColor: Color(0xFFFFFFFF),
          lightBackgroundColor: Color(0xFFFFFFFF),
          redColor: Color(0xFFFFFFFF),
          darkShadowColor: Color(0xFFFFFFFF),
          dividerColor: Color(0xFFFFFFFF),
          iconColor: Color(0xFFFFFFFF),
          darkBlueColor: Color(0xFFFFFFFF),
          lightPurpleColor: Color(0xFFFFFFFF),
          hintTextColor: Color(0xFFFFFFFF),
          lightUnSelectedBGColor: Color(0xFFFFFFFF),
          lightBorderColor: Color(0xFFFFFFFF),
          disabledColor: Color(0xFFFFFFFF),
          boxBgColor: Color(0xFFFFFFFF),
          boxBorderColor: Color(0xFFFFFFFF),
          blueColor: Color(0xFFFFFFFF),
          hoverShadowColor: Color(0xFFFFFFFF),
          hoverBorderColor: Color(0xFFFFFFFF),
          errorColor: Color(0xFFD91807),
          lightBlueColor: Color(0xFFE6F4FB),
          lightBlueBorderColor: Color(0xFF9DC0EE),
          darkBlueTextColor: Color(0xFF2F3F53),
          blueTextColor: Color(0xFF343A3E),
          drawerIconColor: Color(0xFF4C5259),
          darkGreyColor: Color(0xFF4C5259),
          badgeColor: Color(0xFF4C5259),
          greyTextColor: Color(0xFF4C5259),
          greyBorderPaginationColor: Color(0xFF4C5259),
          paginationTextColor: Color(0xFF202224),
          tableHeaderColor: Color(0xFFF8F9FD),
          greentextColor: Color(0xFF009956),
          redtextColor: Color(0xFFF53D5D),
          tableBorderColor: Color(0xff979797),
          filtercheckboxcolor: Color(0XFFD8E6FD),
          filtercheckboxunselectedcolor: Color(0XFFA1A1AA),
          filterbordercolor: Color(0XFFD8E6FD),
          daterangecolor: Color(0xFF4E55F4),
          lightBoxBGColor: Color(0xFFF8F9FD),
          lightDividerColor: Color(0xFFE8EAED),
          lightGreyColor: Color(0xFF6D6D6D),
        );

        final lerpedColors = color1.lerp(color2, 0.5);

        // At t=0.5, should interpolate between the two colors
        expect(lerpedColors, isA<CustomColors>());
        expect(lerpedColors.primaryColor, isNotNull);
        expect(lerpedColors.fillColor, isNotNull);
        expect(lerpedColors.textdarkcolor, isNotNull);

        // The lerped color should be different from both original colors
        expect(lerpedColors.primaryColor, isNot(equals(color1.primaryColor)));
        expect(lerpedColors.primaryColor, isNot(equals(color2.primaryColor)));
      });

      testWidgets('should return original when other is not CustomColors', (WidgetTester tester) async {
        const originalColors = CustomColors.light;

        final result = originalColors.lerp(null, 0.5);

        expect(result, originalColors);
      });

      testWidgets('should lerp at t=0 return first color', (WidgetTester tester) async {
        const color1 = CustomColors.light;
        const color2 = CustomColors.dark;

        final lerpedColors = color1.lerp(color2, 0.0);

        expect(lerpedColors.primaryColor, color1.primaryColor);
        expect(lerpedColors.fillColor, color1.fillColor);
      });

      testWidgets('should lerp at t=1 return second color', (WidgetTester tester) async {
        const color1 = CustomColors.light;
        const color2 = CustomColors.dark;

        final lerpedColors = color1.lerp(color2, 1.0);

        expect(lerpedColors.primaryColor, color2.primaryColor);
        expect(lerpedColors.fillColor, color2.fillColor);
      });
    });

    group('ThemeDataCustomColors Extension', () {
      testWidgets('should return CustomColors from ThemeData extension', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: const [CustomColors.light]),
            home: Builder(
              builder: (context) {
                final customColors = Theme.of(context).customColors;

                expect(customColors.primaryColor, const Color(0xFF4E55F4));
                expect(customColors.fillColor, const Color(0xFFFFFFFF));

                return const Scaffold(body: Text('Test'));
              },
            ),
          ),
        );
      });

      testWidgets('should return default light colors when no extension', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(), // No custom colors extension
            home: Builder(
              builder: (context) {
                final customColors = Theme.of(context).customColors;

                // Should return CustomColors.light as default
                expect(customColors.primaryColor, CustomColors.light.primaryColor);
                expect(customColors.fillColor, CustomColors.light.fillColor);

                return const Scaffold(body: Text('Test'));
              },
            ),
          ),
        );
      });
    });
  });
}
