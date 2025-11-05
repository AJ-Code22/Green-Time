import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1200;
  
  static double getFontSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile + 8;
    if (isTablet(context)) return tablet ?? mobile + 4;
    return mobile;
  }
  
  static EdgeInsets getPadding(BuildContext context, {
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile * 2;
    if (isTablet(context)) return tablet ?? mobile * 1.5;
    return mobile;
  }
  
  static double getIconSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile * 1.5;
    if (isTablet(context)) return tablet ?? mobile * 1.25;
    return mobile;
  }
}