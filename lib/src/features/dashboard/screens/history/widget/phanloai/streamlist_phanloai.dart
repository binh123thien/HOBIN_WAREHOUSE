import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/widget/card_history.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/widget/phanloai/chitietthang_phanloai.dart';

import '../../../../../../constants/color.dart';
import '../../../../../../repository/history_repository/history_repository.dart';

class StreamListHistoryPhanLoai extends StatelessWidget {
  const StreamListHistoryPhanLoai({
    super.key,
    required this.controller,
    required this.docsByMonth,
  });

  final HistoryRepository controller;
  final List<List<DocumentSnapshot<Object?>>> docsByMonth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: whiteColor,
      height: size.height - kToolbarHeight - 140,
      child: StreamBuilder<QuerySnapshot>(
          stream: controller.getAllDonBanHangHoacNhapHang("NhapHang"),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Không có dữ liệu"));
            } else {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: docsByMonth.length,
                itemBuilder: ((BuildContext context, int index) {
                  final docs = docsByMonth[index];
                  final month = docs.first['ngaytao'].split('/')[1];
                  final year = docs.first['ngaytao'].split('/')[2];

                  final tongBanHangMonthly = docs
                      .where((doc) => doc['billType'] == 'BanHang')
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          color: backGroundSearch,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tháng $month" "/" "$year",
                                      style: const TextStyle(
                                          fontSize: 18,
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
                      ),
                      CardHistory(
                        docs: docs,
                      )
                    ]),
                  );
                }),
              );
            }
          }),
    );
  }
}
