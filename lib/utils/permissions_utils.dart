import 'package:permission_handler/permission_handler.dart';

requestStoragePermission() async {
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
    return false;
  } else if (permissions[PermissionGroup.storage] !=
      PermissionStatus.neverAskAgain) {}
  return true;
}
