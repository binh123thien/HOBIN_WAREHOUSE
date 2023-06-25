import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/history/widget/chitiet_lichsu_donhang.dart';

import '../../../../../constants/color.dart';
import '../../../../../utils/utils.dart';

class CardHistory extends StatelessWidget {
  const CardHistory({
    super.key,
    required this.docs,
  });

  final List<dynamic> docs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final doc = docs[index];
          phanbietIcon() {
            //BanHang thanh cong
            if (doc["billType"] == "BanHang" &&
                doc["trangthai"] == "Thành công") {
              return banhangIcon;
            } else
            //Nhaphang thanh cong
            if (doc["billType"] == "NhapHang" &&
                doc["trangthai"] == "Thành công") {
              return nhaphangIcon;
            } else
            //BanHang NhapHang Dang cho
            if (doc["trangthai"] == "Đang chờ") {
              return dangchoIcon;
            } else {
              return huyIcon;
            }
          }

          phanbietmau() {
            if (doc["billType"] == "BanHang" &&
                doc["trangthai"] == "Thành công") {
              return success600Color;
            } else
            //Nhaphang thanh cong
            if (doc["billType"] == "NhapHang" &&
                doc["trangthai"] == "Thành công") {
              return blueColor;
            } else
            //BanHang NhapHang Dang cho
            if (doc["trangthai"] == "Đang chờ") {
              return processColor;
            } else {
              return cancel600Color;
            }
          }

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChiTietLichSuDonHang(doc: doc)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Container(
                // color: Colors.amber,
                height: 75,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ImageIcon(
                            AssetImage(phanbietIcon()),
                            color: phanbietmau(),
                            size: 30,
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
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                doc["ngaytao"],
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w100),
                              ),
                              Text(
                                "SL: ${doc["tongsl"]}",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                doc["billType"] == "NhapHang" &&
                                        doc["tongthanhtoan"] > 0
                                    ? "-${formatCurrency(doc["tongthanhtoan"])}"
                                    : "+${formatCurrency(doc["tongthanhtoan"])}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: doc["billType"] == "NhapHang" &&
                                            doc["tongthanhtoan"] > 0
                                        ? cancel600Color
                                        : darkColor),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  doc["giamgia"] != 0
                                      ? const Padding(
                                          padding: EdgeInsets.only(right: 3),
                                          child: SizedBox(
                                            child: ImageIcon(
                                              AssetImage(disCountIcon),
                                              size: 20,
                                              color: cancel600Color,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: phanbietmau().withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: 77,
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          doc["trangthai"],
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: doc["trangthai"] ==
                                                      "Thành công"
                                                  ? success600Color
                                                  : doc["trangthai"] ==
                                                          "Đang chờ"
                                                      ? processColor
                                                      : cancel600Color),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Divider()
                  ],
                ),
              ),
            ),
          );
        });
  }
}
