import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1280;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1280;

  static double getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  // Physical width helps keep breakpoints stable on web browser zoom
  static double getPhysicalWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio;

  static bool isBigScreen(BuildContext context) {
    // Use physical width so browser zoom doesn't flip this breakpoint
    final physicalWidth = ResponsiveHelper.getPhysicalWidth(context);
    return physicalWidth >= 1780;
  }

  // Responsive padding
  static EdgeInsets getScreenPadding(BuildContext context, {double? mobile, double? tablet, double? desktop}) {
    if (isDesktop(context)) {
      return isBigScreen(context)
          ? EdgeInsets.symmetric(horizontal: desktop ?? 80)
          : EdgeInsets.symmetric(horizontal: desktop ?? 65);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: tablet ?? ResponsiveHelper.getScreenWidth(context) * 0.05);
    } else {
      return EdgeInsets.symmetric(horizontal: mobile ?? 30);
    }
  }

  // Responsive font sizes
  static double getFontSize(BuildContext context, {double? mobile, double? tablet, double? desktop}) {
    if (isDesktop(context)) {
      return (desktop ?? 18);
    } else if (isTablet(context)) {
      return (tablet ?? 16);
    } else {
      return (mobile ?? 14);
    }
  }

  // Responsive widget sizing
  static double getWidgetSize(BuildContext context, {double? mobile, double? tablet, double? desktop}) {
    if (isDesktop(context)) {
      return (desktop ?? 100);
    } else if (isTablet(context)) {
      return (tablet ?? 80);
    } else {
      return (mobile ?? 60);
    }
  }

  // Responsive height
  static double getWidgetHeight(BuildContext context, {double? mobile, double? tablet, double? desktop}) {
    if (isDesktop(context)) {
      return (desktop ?? 100);
    } else if (isTablet(context)) {
      return (tablet ?? 80);
    } else {
      return (mobile ?? 60);
    }
  }

  // Max width for forms/cards on large screens
  static double getMaxFormWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 650;
    } else if (isTablet(context)) {
      return 650;
    } else {
      return double.infinity;
    }
  }

  static double getMaxDialogWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 600;
    } else if (isTablet(context)) {
      return 600;
    } else {
      return double.infinity;
    }
  }

  static double getMaxAuthFormWidth(BuildContext context) {
    if (isDesktop(context)) {
      return isBigScreen(context) ? 700 : 500;
    } else if (isTablet(context)) {
      return isBigScreen(context) ? 700 : 500;
    } else {
      return double.infinity;
    }
  }

  static double getMaxTileWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 520;
    } else if (isTablet(context)) {
      return 520;
    } else {
      return double.infinity;
    }
  }

  static double getMaxSliderWidthWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 740;
    } else if (isTablet(context)) {
      return 580;
    } else {
      return double.infinity;
    }
  }

  // Max width for forms/cards on large screens
  static EdgeInsets getScreenMargin(BuildContext context) {
    if ((MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 760)) {
      return EdgeInsets.symmetric(horizontal: kIsWeb ? 20.0 : 0.0);
    } else {
      return EdgeInsets.zero;
    }
  }

  static double getAuthBoxRadius(BuildContext context, {double? mobile, double? tablet, double? desktop}) {
    if (isDesktop(context)) {
      return (desktop ?? 60);
    } else if (isTablet(context)) {
      return (tablet ?? 60);
    } else {
      return (mobile ?? 40);
    }
  }

  static bool isWebAndIsNotMobile(BuildContext context) => (kIsWeb && !ResponsiveHelper.isMobile(context));

  static double getLogoHeight(BuildContext context, {double? mobile, double? tablet, double? desktop}) {
    if (isDesktop(context)) {
      return (desktop ?? (ResponsiveHelper.isBigScreen(context) ? 65 : 46));
    } else if (isTablet(context)) {
      return (tablet ?? (ResponsiveHelper.isBigScreen(context) ? 65 : 46));
    } else {
      return (mobile ?? (kIsWeb ? 55 : 65));
    }
  }

  // Responsive padding
  static EdgeInsets getDialogPadding(BuildContext context, {double? mobile, double? tablet, double? desktop}) {
    if (isDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: desktop ?? 36);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: tablet ?? 30);
    } else {
      return EdgeInsets.symmetric(horizontal: mobile ?? 20);
    }
  }
}
