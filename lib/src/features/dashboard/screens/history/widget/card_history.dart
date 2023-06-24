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
                    Expanded(
                      flex: 1,
                      child: ImageIcon(
                        AssetImage(phanbietIcon()),
                        color: phanbietmau(),
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
                                fontSize: 18, fontWeight: FontWeight.w600),
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
                      flex: 3,
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
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: doc["billType"] == "NhapHang" &&
                                        doc["tongthanhtoan"] > 0
                                    ? cancel600Color
                                    : darkColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            doc["trangthai"],
                            style: TextStyle(
                                fontSize: 14,
                                color: doc["trangthai"] == "Thành công"
                                    ? success600Color
                                    : doc["trangthai"] == "Đang chờ"
                                        ? processColor
                                        : cancel600Color),
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
        });
  }
}
