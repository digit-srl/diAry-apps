import 'package:logger/logger.dart';

final logger = Logger(filter: ReleaseLogger());

class ReleaseLogger extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
