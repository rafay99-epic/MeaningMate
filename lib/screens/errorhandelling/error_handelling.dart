import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:meaning_mate/utils/image.dart";
import "package:meaning_mate/utils/sizes.dart";

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  const ErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    // Adjusting values based on device type
    final deviceCategory = DeviceType.getDeviceCategory(context);
    double logoWidth;
    double spacing;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (deviceCategory) {
      case DeviceCategory.smallPhone:
        logoWidth = 150;
        spacing = 20;
        break;
      case DeviceCategory.largePhone:
        logoWidth = 200;
        spacing = 30;
        break;
      case DeviceCategory.tablet:
        logoWidth = 300;
        spacing = 50;
        break;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 350),
              SvgPicture.asset(
                ErrorScreenImage.logo,
                width: logoWidth,
              ),
              SizedBox(height: spacing),
              Text(
                errorMessage,
                style: TextStyle(
                  color: colorScheme.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
