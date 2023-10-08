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

String formatNgayTaoString(String dateString) {
  final inputFormat = DateFormat('dd/MM/yyyy');
  final outputFormat = DateFormat('ddMMyyyy');

  // Chuyển đổi chuỗi ngày sang đúng định dạng
  final date = inputFormat.parse(dateString);

  // Định dạng lại ngày theo đúng định dạng đầu ra
  final formattedDate = outputFormat.format(date);

  return formattedDate;
}

String generateXHCode() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('yyMMdd-HHmmss'); // Thêm định dạng giây

  // Lấy ngày giờ hiện tại và định dạng theo yyyyMMdd-HHmmss
  final formattedDateTime = formatter.format(now);

  // Ghép chuỗi BH với ngày giờ định dạng
  return 'XH$formattedDateTime';
}

String generateNHCode() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('yyMMdd-HHmmss'); // Thêm định dạng giây

  // Lấy ngày giờ hiện tại và định dạng theo yyyyMMdd-HHmmss
  final formattedDateTime = formatter.format(now);

  // Ghép chuỗi BH với ngày giờ định dạng
  return 'NH$formattedDateTime';
}

String generateHHCode() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('yyMMdd-HHmmss'); // Thêm định dạng giây

  // Lấy ngày giờ hiện tại và định dạng theo yyyyMMdd-HHmmss
  final formattedDateTime = formatter.format(now);

  // Ghép chuỗi BH với ngày giờ định dạng
  return 'HH$formattedDateTime';
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
  final formatter = DateFormat('HH:mm-ddMMyyyy');

  // Định dạng ngày hiện tại theo HH:mm-ddMMyyyy
  return formatter.format(now);
}

String formatNgayTao() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('HH:mm - dd/MM/yyyy');

  // Định dạng ngày hiện tại theo HH:mm-ddMMyyyy
  return formatter.format(now);
}

String formatDatetime() {
  final DateTime now = DateTime.now();
  final formatter = DateFormat('dd-MM-yyyy');

  // Định dạng ngày hiện tại theo HH:mm-dd/MM/yyyy
  return formatter.format(now);
}
