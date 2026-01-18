import 'package:intl/intl.dart';

String formatCurrency(num? amount) {
  if (amount == null) return "0đ";
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  return formatter.format(amount);
}

String formatDate(String? dateString) {
  if (dateString == null) return "";
  final date = DateTime.tryParse(dateString);
  if (date == null) return "";
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatTime(String? dateString) {
  if (dateString == null) return "";
  final date = DateTime.tryParse(dateString);
  if (date == null) return "";
  return DateFormat('HH:mm').format(date);
}

String getDuration(String? startAt, String? endAt) {
  if (startAt == null || endAt == null) return "0";
  final start = DateTime.tryParse(startAt);
  final end = DateTime.tryParse(endAt);
  if (start == null || end == null) return "0";
  final diff = end.difference(start);
  return (diff.inMinutes / 60).toStringAsFixed(1);
}
