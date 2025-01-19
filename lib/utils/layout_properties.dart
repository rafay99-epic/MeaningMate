import 'package:flutter/material.dart';
import 'package:meaning_mate/utils/sizes.dart';

class LayoutProperties {
  final double horizontalPadding;
  final double buttonWidth;
  final double spacing;
  final double logoWidth;

  LayoutProperties({
    required this.horizontalPadding,
    required this.buttonWidth,
    required this.spacing,
    required this.logoWidth,
  });

  static LayoutProperties getProperties(
      DeviceCategory deviceCategory, BuildContext context) {
    switch (deviceCategory) {
      case DeviceCategory.smallPhone:
        return LayoutProperties(
          horizontalPadding: 8.0,
          buttonWidth: MediaQuery.of(context).size.width * 0.8,
          spacing: 20.0,
          logoWidth: 150.0,
        );
      case DeviceCategory.largePhone:
        return LayoutProperties(
          horizontalPadding: 16.0,
          buttonWidth: MediaQuery.of(context).size.width * 0.7,
          spacing: 30.0,
          logoWidth: 200.0,
        );
      default:
        return LayoutProperties(
          horizontalPadding: 32.0,
          buttonWidth: MediaQuery.of(context).size.width * 0.6,
          spacing: 50.0,
          logoWidth: 300.0,
        );
    }
  }
}
