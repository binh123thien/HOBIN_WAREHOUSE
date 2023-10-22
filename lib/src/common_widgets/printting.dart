// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart'; //onLayout: (PdfPageFormat format)
import 'package:pdf/widgets.dart' as pw;

import '../repository/history_repository/history_repository.dart';
import '../utils/utils.dart';

final controllerHistoryRepo = Get.put(HistoryRepository());
List<dynamic> hoadonPDF = controllerHistoryRepo.hoaDonPDFControler;
List<dynamic> chitietTThoaDonPDF =
    controllerHistoryRepo.chitietTThoaDonPDFControler;

// Function to create PDF page
Future<pw.Page> createPDFPage(BuildContext context) async {
  final utf8 =
      pw.Font.ttf(await rootBundle.load('assets/fonts/arial_unicode_ms.ttf'));

  String timePrint = formatNgayTao();

  final item = chitietTThoaDonPDF[0];
  final tongtien = formatCurrency(item['tongtien']);
  final giamgia = formatCurrency((item['giamgia']));
  final no = formatCurrency((item['no']));
  final tongthanhtoan = formatCurrency((item['tongthanhtoan']));

  return pw.Page(
    pageFormat: PdfPageFormat.letter,
    build: (pw.Context context) {
      return pw.Column(
        children: [
          pw.Text('CHI TIÊT HÓA ĐƠN',
              style: pw.TextStyle(
                  font: utf8, fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.Padding(padding: const pw.EdgeInsets.only(bottom: 15)),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text("Thời gian: ",
                          style: pw.TextStyle(
                            fontSize: 14,
                            font: utf8,
                          )),
                      pw.Text(
                        item['ngaytao'].toString(),
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: utf8,
                        ),
                      ),
                    ],
                  ),
                  pw.Padding(padding: const pw.EdgeInsets.only(bottom: 5)),
                  pw.Row(
                    children: [
                      pw.Text("In lúc: ",
                          style: pw.TextStyle(
                            fontSize: 14,
                            font: utf8,
                          )),
                      pw.Text(
                        timePrint,
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: utf8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text("Số HĐ: ",
                          style: pw.TextStyle(
                            fontSize: 14,
                            font: utf8,
                          )),
                      pw.Text(
                        item['soHD'].toString(),
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: utf8,
                        ),
                      ),
                    ],
                  ),
                  pw.Padding(padding: const pw.EdgeInsets.only(bottom: 5)),
                  pw.Row(
                    children: [
                      pw.Text(
                          item['billType'] == "BanHang"
                              ? "Người mua: "
                              : "Người bán: ",
                          style: pw.TextStyle(
                            fontSize: 14,
                            font: utf8,
                          )),
                      pw.Text(item['khachhang'],
                          style: pw.TextStyle(
                            fontSize: 14,
                            font: utf8,
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
          pw.Padding(padding: const pw.EdgeInsets.only(bottom: 20)),
          pw.Table.fromTextArray(
            data: [
              [],
              ['Mặt hàng', 'Số lượng', 'Đơn giá', 'Tổng tiền'],
              ...hoadonPDF.map((item) => [
                    item['tensanpham'],
                    item['soluong'].toString(),
                    formatCurrencWithoutD(item['gia']),
                    formatCurrencWithoutD(item['gia'] * item['soluong'])
                  ])
            ],
            headerCount: 1,
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1),
            },
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: pw.TextStyle(font: utf8, fontSize: 16),
          ),
          pw.Padding(padding: const pw.EdgeInsets.only(bottom: 20)),
          // chi tiết thanh toán
          pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Tổng tiền:",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: utf8,
                      )),
                  pw.Text(item['tongsl'].toString(),
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: utf8,
                      )),
                  pw.SizedBox(width: 145),
                  pw.Text(tongtien,
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: utf8,
                      )),
                ],
              ),
              pw.Padding(padding: const pw.EdgeInsets.only(bottom: 5)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Giảm giá:",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: utf8,
                      )),
                  pw.Text(
                    giamgia,
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: utf8,
                    ),
                  ),
                ],
              ),
              pw.Padding(padding: const pw.EdgeInsets.only(bottom: 5)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Nợ:",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: utf8,
                      )),
                  pw.Text(
                    no,
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: utf8,
                    ),
                  ),
                ],
              ),
              pw.Padding(padding: const pw.EdgeInsets.only(bottom: 5)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Thành tiền:",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: utf8,
                      )),
                  pw.Text(
                    tongthanhtoan,
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: utf8,
                    ),
                  ),
                ],
              ),
              pw.Padding(padding: const pw.EdgeInsets.only(bottom: 5)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Hình thức thanh toán:",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: utf8,
                      )),
                  pw.Text(
                    item['payment'].toString(),
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: utf8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.Padding(padding: const pw.EdgeInsets.only(bottom: 25)),
          pw.Center(
            child: pw.Text(
              "Cảm ơn rất hân hạnh được phục vụ quý khách!",
              style: pw.TextStyle(
                fontSize: 18,
                font: utf8,
              ),
            ),
          )
        ],
      );
    },
  );
}

Future<void> printPDF(chitietTT, BuildContext context) async {
  // xoa DS truoc do
  controllerHistoryRepo.chitietTThoaDonPDFControler.clear();
  chitietTThoaDonPDF = controllerHistoryRepo.chitietTThoaDonPDFControler;

  chitietTThoaDonPDF.add({
    'billType': chitietTT['billType'],
    "tongsl": chitietTT['tongsl'],
    "tongtien": chitietTT['tongtien'],
    'tongthanhtoan': chitietTT['tongthanhtoan'],
    'giamgia': chitietTT['giamgia'],
    "trangthai": chitietTT['trangthai'],
    "soHD": chitietTT['soHD'],
    "ngaytao": chitietTT['ngaytao'],
    "khachhang": chitietTT['khachhang'],
    "no": chitietTT['no'],
    "payment": chitietTT['payment'],
  });
  // Create PDF document
  final pdf = pw.Document();
  // Add pages to PDF
  pdf.addPage(
    await createPDFPage(context),
  );

  final bytes = await pdf.save();
  final preview = PdfPreview(
    build: (format) => bytes,
  );
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => preview),
  );
}

// Share PDF function
Future<void> sharePDF(chitietTT, BuildContext context) async {
  // xoa DS truoc do
  controllerHistoryRepo.chitietTThoaDonPDFControler.clear();
  chitietTThoaDonPDF = controllerHistoryRepo.chitietTThoaDonPDFControler;

  chitietTThoaDonPDF.add({
    'billType': chitietTT['billType'],
    "tongsl": chitietTT['tongsl'],
    "tongtien": chitietTT['tongtien'],
    'tongthanhtoan': chitietTT['tongthanhtoan'],
    'giamgia': chitietTT['giamgia'],
    "trangthai": chitietTT['trangthai'],
    "soHD": chitietTT['soHD'],
    "ngaytao": chitietTT['ngaytao'],
    "khachhang": chitietTT['khachhang'],
    "no": chitietTT['no'],
    "payment": chitietTT['payment'],
  });
  final pdf = pw.Document();
  pdf.addPage(
    await createPDFPage(context),
  );
  final bytes = await pdf.save();
  await Printing.sharePdf(
      bytes: bytes, filename: 'Bill_${chitietTT['soHD']}.pdf');
}
