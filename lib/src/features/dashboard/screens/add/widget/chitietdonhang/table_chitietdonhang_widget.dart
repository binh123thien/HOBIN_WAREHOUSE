import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:intl/intl.dart';

import '../../../../../../repository/history_repository/history_repository.dart';

// ignore: must_be_immutable
class TableChiTietDonHang extends StatelessWidget {
  final int phanbietNhapXuat;
  TableChiTietDonHang({
    super.key,
    required this.filteredList,
    required this.phanbietNhapXuat,
  });

  final List filteredList;
  final controllerHistoryRepo = Get.put(HistoryRepository());
  late List<dynamic> hoaDonPDF = [];
  @override
  Widget build(BuildContext context) {
    //xóa list tạm trước đó
    controllerHistoryRepo.hoaDonPDFControler.clear();
    hoaDonPDF = controllerHistoryRepo.hoaDonPDFControler;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(9),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(5),
          3: FlexColumnWidth(5),
        },
        border: TableBorder.all(color: darkColor),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(color: whiteColor),
            children: [
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text("Mặt hàng",
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text("SL",
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text("Đơn giá",
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text("T tiền",
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
            ],
          ),
          ...List.generate(
            filteredList.length,
            (index) {
              final item = filteredList[index];
              final tenSanPham = item["tensanpham"];
              final soLuong = item["soluong"];
              final donGia =
                  phanbietNhapXuat == 0 ? item["giaban"] : item["gianhap"];
              final thanhTien = soLuong * donGia;

              hoaDonPDF.add({
                "tenSanPham": tenSanPham,
                "soLuong": soLuong,
                "donGia": donGia,
                "thanhTien": thanhTien,
              });
              return TableRow(
                decoration: const BoxDecoration(color: whiteColor),
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        tenSanPham,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        NumberFormat.currency(
                          locale: "vi",
                          symbol: "",
                          decimalDigits: 0,
                        ).format(soLuong),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        NumberFormat.currency(
                          locale: "vi",
                          symbol: "",
                          decimalDigits: 0,
                        ).format(donGia),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        NumberFormat.currency(
                          locale: "vi",
                          symbol: "",
                          decimalDigits: 0,
                        ).format(thanhTien),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
