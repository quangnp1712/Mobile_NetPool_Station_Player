// ignore_for_file: avoid_print

class DebugLogger {
  static final DebugLogger _instance = DebugLogger._internal();

  factory DebugLogger() {
    return _instance;
  }

  DebugLogger._internal();

  static void printLog(String message) {
    print('\x1B[31m$message\x1B[0m'); // Màu đỏ
  }
}
