import 'dart:math';

import 'package:intl/intl.dart';

String formatCurrency(value) {
  return NumberFormat.currency(
    locale: "vi",
    symbol: "đ",
    decimalDigits: 0,
  ).format(value);
}

String formatCurrencWithoutD(value) {
  return NumberFormat.currency(
    locale: "vi",
    symbol: "",
    decimalDigits: 0,
  ).format(value).replaceAll('.', ',').trimRight();
}

String generateRandomCode(int length) {
  const chars =
      '0123456789'; //các kí tự có thể sử dụng để tạo mã. Ở đây là các số từ 0-9.
  final random = Random();

  //Tạo chuỗi ngẫu nhiên với độ dài truyền vào
  return List.generate(length, (index) => chars[random.nextInt(chars.length)])
      .join();
}

String generateBHCode() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('yyMMdd-HHmmss'); // Thêm định dạng giây

  // Lấy ngày giờ hiện tại và định dạng theo yyyyMMdd-HHmmss
  final formattedDateTime = formatter.format(now);

  // Ghép chuỗi BH với ngày giờ định dạng
  return 'BH$formattedDateTime';
}

String generateNHCode() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('yyMMdd-HHmmss'); // Thêm định dạng giây

  // Lấy ngày giờ hiện tại và định dạng theo yyyyMMdd-HHmmss
  final formattedDateTime = formatter.format(now);

  // Ghép chuỗi BH với ngày giờ định dạng
  return 'NH$formattedDateTime';
}

String generateKHCode() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('yyMMdd-HHmmss'); // Thêm định dạng giây

  // Lấy ngày giờ hiện tại và định dạng theo yyyyMMdd-HHmmss
  final formattedDateTime = formatter.format(now);

  // Ghép chuỗi BH với ngày giờ định dạng
  return 'KH$formattedDateTime';
}

String generateLSNCode() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('yyMMdd-HHmmss'); // Thêm định dạng giây

  // Lấy ngày giờ hiện tại và định dạng theo yyyyMMdd-HHmmss
  final formattedDateTime = formatter.format(now);

  // Ghép chuỗi BH với ngày giờ định dạng
  return 'LSN$formattedDateTime';
}

String formatNgaytao() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('HH:mm-dd/MM/yyyy');

  // Định dạng ngày hiện tại theo HH:mm-dd/MM/yyyy
  return formatter.format(now);
}

String formatDatetime() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('dd/MM/yyyy');

  // Định dạng ngày hiện tại theo HH:mm-dd/MM/yyyy
  return formatter.format(now);
}
