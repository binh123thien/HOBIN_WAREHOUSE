import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "Tổng nợ: ${formatCurrency(total)}",
              style: const TextStyle(fontSize: 18),
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: darkColor.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                      ),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: ImageIcon(
                              AssetImage(dangchoIcon),
                              color: processColor,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  doc["khachhang"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  doc["ngaytao"],
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w100),
                                ),
                                Text(
                                  "SL: ${doc["tongsl"]}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Nợ: ${formatCurrency(doc["no"])}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: doc["billType"] == "NhapHang"
                                          ? cancel600Color
                                          : darkColor),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  formatCurrency(doc["tongthanhtoan"]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: darkColor),
                                ),
                                const SizedBox(height: 2),
                                SizedBox(
                                  child: doc["giamgia"] != 0
                                      ? const ImageIcon(
                                          AssetImage(disCountIcon),
                                          size: 20,
                                          color: cancel600Color,
                                        )
                                      : const SizedBox.shrink(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
