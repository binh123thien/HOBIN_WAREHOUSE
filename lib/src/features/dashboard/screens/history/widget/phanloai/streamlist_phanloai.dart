import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/widget/card_history.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/widget/phanloai/chitietthang_phanloai.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../repository/history_repository/history_repository.dart';

class StreamListHistoryPhanLoai extends StatelessWidget {
  final String searchHistory;
  const StreamListHistoryPhanLoai({
    super.key,
    required this.controller,
    required this.docsByMonth,
    required this.searchHistory,
  });

  final HistoryRepository controller;
  final List<List<DocumentSnapshot<Object?>>> docsByMonth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //list được chia theo tháng
    List<List<dynamic>> filteredItemsByMonth = docsByMonth.map((month) {
      List<dynamic> items = month.where((item) {
        final soHDMatch = item["soHD"]
            .toString()
            .toLowerCase()
            .contains(searchHistory.toLowerCase());
        final tenKhachHangMatch = item["khachhang"]
            .toString()
            .toLowerCase()
            .contains(searchHistory.toLowerCase());
        final ngaytaoMatch = item["ngaytao"]
            .toString()
            .toLowerCase()
            .contains(searchHistory.toLowerCase());
        return soHDMatch || tenKhachHangMatch || ngaytaoMatch;
      }).toList();
      return items;
    }).toList();
    return Container(
      color: whiteColor,
      height: size.height * 0.75,
      child: StreamBuilder<QuerySnapshot>(
          stream: controller.getAllDonBanHangHoacNhapHang("NhapHang"),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text(
                "Không có dữ liệu",
                style: TextStyle(fontSize: Font.sizes(context)[1]),
              ));
            } else {
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: docsByMonth.length,
                itemBuilder: ((BuildContext context, int index) {
                  final docs = filteredItemsByMonth[index];
                  if (docs.isNotEmpty) {
                    final month = docs.first['ngaytao'].split('/')[1];
                    final year = docs.first['ngaytao'].split('/')[2];

                    final tongBanHangMonthly = docs
                        .where((doc) => doc['billType'] == 'XuatHang')
                        .fold<num>(
                            0, (prev, curr) => prev + curr['tongthanhtoan']);
                    final tongNhapHangMonthly = docs
                        .where((doc) => doc['billType'] == 'NhapHang')
                        .fold<num>(
                            0, (prev, curr) => prev + curr['tongthanhtoan']);
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: whiteColor,
                      child: Column(children: [
                        Container(
                          color: whiteColor,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tháng $month" "/" "$year",
                                      style: TextStyle(
                                          fontSize: Font.sizes(context)[2],
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              ChitietThangPhanLoai(
                                tongBanHangMonthly: tongBanHangMonthly,
                                tongNhapHangMonthly: tongNhapHangMonthly,
                              ),
                            ],
                          ),
                        ),
                        CardHistory(
                          docs: docs,
                        )
                      ]),
                    );
                  }
                  return null;
                }),
              );
            }
          }),
    );
  }
}
