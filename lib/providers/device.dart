import 'package:flutter/foundation.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class DeviceManager with ChangeNotifier {
  String mode = '';
  bool isPhone = false;
  bool isTablet = false;
  bool isDesktop = false;

  DeviceManager() {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      isDesktop = true;
      mode = 'desktop';
    } else if (Device.get().isTablet) {
      isTablet = true;
      mode = 'mobile';
    } else if (Device.get().isPhone) isPhone = true;
  }

  void setToDesktopMode() {
    mode = 'desktop';
  }

  void setToMobileMode() {
    mode = 'mobile';
  }

  bool isDesktopMode() {
    return (mode == 'desktop');
  }
}
