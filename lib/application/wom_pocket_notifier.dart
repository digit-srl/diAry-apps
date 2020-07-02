import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/logger.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class WomPocketNotifier extends StateNotifier<bool> {
  WomPocketNotifier() : super(true) {
    checkIfPocketIsInstalled();
  }

  bool get isInstalled => state;

  Future<bool> checkIfPocketIsInstalled() async {
    try {
      bool isInstalled;
      if (Platform.isAndroid) {
        isInstalled = await DeviceApps.isAppInstalled('social.wom.pocket');
        state = isInstalled;
      } else {
        isInstalled = await canLaunch('1466969163://');
        state = isInstalled;
      }
      return isInstalled;
    } catch (ex) {
      logger.e(ex.toString());
      return false;
    }
  }
}
