import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart'; //onLayout: (PdfPageFormat format)
import 'package:pdf/widgets.dart' as pw;

import '../repository/history_repository/history_repository.dart';
import '../utils/utils.dart';

final controllerHistoryRepo = Get.put(HistoryRepository());
late List<dynamic> hoadonPDF = controllerHistoryRepo.hoaDonPDFControler;
late List<dynamic> chitietTThoaDonPDF =
    controllerHistoryRepo.chitietTThoaDonPDFControler;

// Function to create PDF page
Future<pw.Page> createPDFPage(BuildContext context) async {
  final utf8 =
      pw.Font.ttf(await rootBundle.load('assets/fonts/arial_unicode_ms.ttf'));
  return pw.Page(
    pageFormat: PdfPageFormat.letter,
    build: (pw.Context context) {
      return pw.Column(
        children: [
          pw.Text('CHI TIÊT HÓA ĐƠN',
              style: pw.TextStyle(
                  font: utf8, fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.Padding(padding: pw.EdgeInsets.only(bottom: 30)),

          // ignore: deprecated_member_use
          pw.Table.fromTextArray(
            data: [
              [],
              ['Mặt hàng', 'Số lượng', 'Đơn giá', 'Tổng tiền'],
              ...hoadonPDF.map((item) => [
                    item['tenSanPham'],
                    item['soLuong'].toString(),
                    formatCurrencWithoutD(item['donGia']),
                    formatCurrencWithoutD(item['donGia'] * item['soLuong'])
                  ])
            ],
            headerCount: 1,
            columnWidths: {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(1),
            },
            cellAlignment: pw.Alignment.center,
            cellStyle: pw.TextStyle(font: utf8),
          ),
          // chi tiết thanh toán
          pw.ListView.builder(
              itemCount: chitietTThoaDonPDF.length,
              itemBuilder: (pw.Context context, int index) {
                final item = chitietTThoaDonPDF[index];
                final tongtien = formatCurrency(item['tongtien']);
                final giamgia = formatCurrency((item['giamgia']));
                final no = formatCurrency((item['no']));
                final tongthanhtoan = formatCurrency((item['tongthanhtoan']));
                return pw.Row(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(18.0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text("Chi tiết thanh toán",
                                style: pw.TextStyle(
                                    fontSize: 18,
                                    font: utf8,
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Tổng số lượng: ",
                                style: pw.TextStyle(
                                    fontSize: 17,
                                    font: utf8,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text((item['tongsl'].toString()),
                                style: const pw.TextStyle(
                                  fontSize: 17,
                                )),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Tổng tiền: ",
                                style: pw.TextStyle(
                                  fontSize: 17,
                                  font: utf8,
                                )),
                            pw.Text(
                              (tongtien.toString()),
                              style: pw.TextStyle(
                                fontSize: 17,
                                font: utf8,
                              ),
                            )
                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Giảm giá: ",
                                style: pw.TextStyle(
                                  fontSize: 17,
                                  font: utf8,
                                )),
                            pw.Text(giamgia.toString(),
                                style: pw.TextStyle(
                                  fontSize: 17,
                                  font: utf8,
                                ))
                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Tổng thanh toán: ",
                                style: pw.TextStyle(
                                  fontSize: 17,
                                  font: utf8,
                                )),
                            pw.Text(
                              tongthanhtoan.toString(),
                              style: pw.TextStyle(
                                fontSize: 17,
                                font: utf8,
                              ),
                            )
                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                                item['billType'] == "BanHang"
                                    ? "Khách nợ: "
                                    : "Nợ nhà cung cấp: ",
                                style: pw.TextStyle(
                                  fontSize: 17,
                                  font: utf8,
                                )),
                            pw.Text(
                              no.toString(),
                              style: pw.TextStyle(
                                fontSize: 17,
                                font: utf8,
                              ),
                            )
                          ],
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(top: 10),
                          child: pw.Container(
                            decoration: pw.BoxDecoration(
                                borderRadius: pw.BorderRadius.circular(15)),
                            width: double.infinity,
                            height: 260,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(top: 12.0),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.SizedBox(height: 20),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("Trạng thái: ",
                                          style: pw.TextStyle(
                                            fontSize: 17,
                                            font: utf8,
                                          )),
                                      pw.Container(
                                        width: 95,
                                        height: 30,
                                        child: pw.Align(
                                          alignment: pw.Alignment.center,
                                          child: pw.Text(
                                            no == 0 ? "Thành công" : "Đang chờ",
                                            style: pw.TextStyle(
                                              fontSize: 16,
                                              font: utf8,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("Thời gian: ",
                                          style: pw.TextStyle(
                                            fontSize: 17,
                                            font: utf8,
                                          )),
                                      pw.Text(item['ngaytao'].toString(),
                                          style: pw.TextStyle(
                                            fontSize: 17,
                                            font: utf8,
                                          )),
                                    ],
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("Số HD: ",
                                          style: pw.TextStyle(
                                            fontSize: 17,
                                            font: utf8,
                                          )),
                                      pw.Text(item['soHD'].toString(),
                                          style: pw.TextStyle(
                                            fontSize: 17,
                                            font: utf8,
                                          )),
                                    ],
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text(
                                          item['billType'] == "BanHang"
                                              ? "Khách hàng: "
                                              : "Nhà cùng cấp: ",
                                          style: pw.TextStyle(
                                            fontSize: 17,
                                            font: utf8,
                                          )),
                                      pw.Text(item['khachhang'],
                                          style: pw.TextStyle(
                                            fontSize: 17,
                                            font: utf8,
                                          )),
                                    ],
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("Hình thức thanh toán:",
                                          style: pw.TextStyle(
                                            fontSize: 17,
                                            font: utf8,
                                          )),
                                      pw.Text(item['payment'],
                                          style: pw.TextStyle(
                                            fontSize: 17,
                                            font: utf8,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              }),
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
  await Printing.sharePdf(bytes: bytes, filename: 'bill.pdf');
}
