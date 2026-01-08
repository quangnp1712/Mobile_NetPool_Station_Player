import 'package:intl/intl.dart';

class MoneyFormatter {
  /// Chỉ format số, KHÔNG kèm đơn vị
  /// 1990248 -> 1.990.248
  static String format(int amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(amount);
  }

  /// Format tiền Việt Nam
  /// 1990248 -> 1.990.248 đ
  static String formatVND(int amount) {
    return '${format(amount)} đ';
  }

  /// Format tiền có dấu + / -
  /// +40000 -> +40.000 đ
  /// -40000 -> -40.000 đ
  static String formatSigned(int amount) {
    if (amount >= 0) {
      return '+${format(amount)} đ';
    } else {
      return '-${format(amount.abs())} đ';
    }
  }
}
