import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/widget/chitiet_lichsu_donhang.dart';

import '../../../../../../../constants/color.dart';
import '../../../../../../../utils/utils.dart';

class CardListDanhSachNo extends StatelessWidget {
  const CardListDanhSachNo({
    super.key,
    required this.docs,
  });

  final List<dynamic> docs;

  @override
  Widget build(BuildContext context) {
    double total = docs.fold(0.0, (sum, doc) {
      if (doc["no"] != null) {
        return sum + doc["no"];
      } else {
        return sum;
      }
    });
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: processColor),
                      color: whiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Tổng nợ: ${formatCurrency(total)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChiTietLichSuDonHang(doc: doc)),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const SizedBox(
                            width: 30,
                            height: 30,
                            child: Image(image: AssetImage(dangchoIcon)),
                          ),
                          title: Text(doc["khachhang"]),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    doc["ngaytao"],
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Text("Nợ: ${formatCurrency(doc["no"])}",
                                      style: const TextStyle(fontSize: 15)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "SL: ${doc["tongsl"]}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Text(formatCurrency(doc["tongthanhtoan"]),
                                      style: const TextStyle(fontSize: 15)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: PhanCachWidget.dotLine(context),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
