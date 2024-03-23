import 'package:flutter/foundation.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:platform_detector/platform_detector.dart';

//stores data related to the device specifications

class DeviceManager with ChangeNotifier {
  String mode = '';
  bool isPhone = false;
  bool isTablet = false;
  bool isDesktop = false;
  bool isMobileWeb = false;

  DeviceManager() {
    print('kisWeb = ' + kIsWeb.toString());
    print('targetPlatform = ' + defaultTargetPlatform.toString());
    // if (defaultTargetPlatform != TargetPlatform.android &&
    //     defaultTargetPlatform != TargetPlatform.iOS) {
    //   isDesktop = true;
    //   mode = 'desktop';
    // }
    // // else if (Device.get().isTablet) {
    // //   isTablet = true;
    // //   mode = 'mobile';
    // // }
    // else if (Device.get().isPhone) {
    //   isPhone = true;
    //   mode = 'mobile';
    // }
    // if (kIsWeb &&
    //     (defaultTargetPlatform == TargetPlatform.android ||
    //         defaultTargetPlatform == TargetPlatform.iOS)) {
    //   isMobileWeb = true;
    //   mode = 'mobile';
    // }

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      isDesktop = false;
      mode = 'mobile';
    } else
      mode = 'desktop';

    // if (isMobileWeb) {
    //   isMobileWeb = true;
    //   mode = 'mobile';
    // }

    print('exiting devicemanager constructor');
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

  String getRoute() {
    // if (isMobileWeb) return '/main-mobile';
    if (mode == 'desktop') return '/main-desktop';
    if (mode == 'mobile') return '/main-mobile';

    return '/main-desktop';
    // print('returning mobile screen route');
    // return '/main-mobile';
  }
}
