import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/logger.dart';
import 'package:state_notifier/state_notifier.dart';

class WomPocketNotifier extends StateNotifier<bool> {
  WomPocketNotifier(bool isInstalled) : super(isInstalled) {
    checkIfPocketIsInstalled();
  }

  bool get isInstalled => state;

  Future<bool> checkIfPocketIsInstalled() async {
    logger.i('checkIfPocketIsInstalled');
    try {
      state = await GenericUtils.checkIfPocketIsInstalled();
    } catch (ex) {
      logger.e(ex.toString());
    }
    return state;
  }
}
