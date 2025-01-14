import 'package:flutter/material.dart';

class DeviceType {
  static const double smallPhoneMaxWidth = 360;
  static const double largePhoneMaxWidth = 600;

  // Enum for device type
  static DeviceCategory getDeviceCategory(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= smallPhoneMaxWidth) {
      return DeviceCategory.smallPhone;
    } else if (screenWidth <= largePhoneMaxWidth) {
      return DeviceCategory.largePhone;
    } else {
      return DeviceCategory.tablet;
    }
  }
}

enum DeviceCategory { smallPhone, largePhone, tablet }
