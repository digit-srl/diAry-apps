import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

requestStoragePermission() async {
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
    return false;
  } else if (permissions[PermissionGroup.storage] !=
      PermissionStatus.neverAskAgain) {}
  return true;
}

requestIgnoreBatteryOptimization() async {
  try {
    PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.ignoreBatteryOptimizations);
    if (permissionStatus == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.ignoreBatteryOptimizations]);
    }
  } catch (ex) {
    print('[App] Error requestIgnoreBatteryOptimization');
    print(ex);
    analytics.logEvent(
        name: 'Error Ignore Optimization Battery',
        parameters: {'error': ex.toString()});
  }
}
