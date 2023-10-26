import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../repository/history_repository/history_repository.dart';
import '../card_history.dart';
import 'chitiet_thang.dart';

class StreamList extends StatefulWidget {
  final String searchHistory;
  const StreamList({
    super.key,
    required this.controller,
    required List<List<DocumentSnapshot<Object?>>> docsByMonth,
    required this.snapshotCollection,
    required this.searchHistory,
  }) : _docsByMonth = docsByMonth;
  final String snapshotCollection;
  final HistoryRepository controller;
  final List<List<DocumentSnapshot<Object?>>> _docsByMonth;

  @override
  State<StreamList> createState() => _StreamListState();
}

class _StreamListState extends State<StreamList> {
  @override
  Widget build(BuildContext context) {
    //list được chia theo tháng
    List<List<dynamic>> filteredItemsByMonth = widget._docsByMonth.map((month) {
      List<dynamic> items = month.where((item) {
        final soHDMatch = item["soHD"]
            .toString()
            .toLowerCase()
            .contains(widget.searchHistory.toLowerCase());
        final tenKhachHangMatch = item["khachhang"]
            .toString()
            .toLowerCase()
            .contains(widget.searchHistory.toLowerCase());
        final ngaytaoMatch = item["ngaytao"]
            .toString()
            .toLowerCase()
            .contains(widget.searchHistory.toLowerCase());
        return soHDMatch || tenKhachHangMatch || ngaytaoMatch;
      }).toList();
      return items;
    }).toList();
    final size = MediaQuery.of(context).size;
    return Container(
      color: whiteColor,
      height: size.height * 0.75,
      child: StreamBuilder<QuerySnapshot>(
          stream: widget.controller
              .getAllDonBanHangHoacNhapHang(widget.snapshotCollection),
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
                itemCount: widget._docsByMonth.length,
                itemBuilder: ((BuildContext context, int index) {
                  final docs = filteredItemsByMonth[index];
                  if (docs.isNotEmpty) {
                    final month = docs.first['ngaytao'].split('/')[1];
                    final year = docs.first['ngaytao'].split('/')[2];
                    // Tính tổng tongthanhtoan theo tháng
                    final doanhThuMonthlyTotal = docs
                        .where((doc) => doc['trangthai'] != "Hủy")
                        .fold<num>(
                            0, (prev, curr) => prev + curr['tongthanhtoan']);
                    final soluongMonthlyTotal = docs
                        .where((doc) => doc['trangthai'] != "Hủy")
                        .fold<num>(0, (prev, curr) => prev + curr['tongsl']);
                    final soLuongDonHangMonthlyTotal =
                        docs.where((doc) => doc['trangthai'] != "Hủy").length;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: whiteColor,
                      child: Column(
                        children: [
                          Container(
                            color: whiteColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 18, 8, 0),
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
                                ChitietThang(
                                  doanhThuMonthlyTotal: doanhThuMonthlyTotal,
                                  soluongMonthlyTotal: soluongMonthlyTotal,
                                  soLuongDonHangMonthlyTotal:
                                      soLuongDonHangMonthlyTotal,
                                  phanbietNhapHangBanHang:
                                      widget.snapshotCollection,
                                ),
                              ],
                            ),
                          ),
                          CardHistory(
                            docs: docs,
                          )
                        ],
                      ),
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
