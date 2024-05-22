import 'package:logger/web.dart';

///Log Handler
class LogHandler {
  ///Logger Instance
  static final Logger _logger = Logger();

  ///Log by Level
  static void log({required String message, required LogLevel level}) {
    switch (level) {
      //Trace Log
      case LogLevel.trace:
        _logger.t(message);

      //Debug Log
      case LogLevel.debug:
        _logger.d(message);

      //Info Log
      case LogLevel.info:
        _logger.i(message);

      //Warning Log
      case LogLevel.warning:
        _logger.w(message);

      //Error Log
      case LogLevel.error:
        _logger.e(message);

      //Fatal Log
      case LogLevel.fatal:
        _logger.f(message);
    }
  }
}

///Log Levels
enum LogLevel { trace, debug, info, warning, error, fatal }
