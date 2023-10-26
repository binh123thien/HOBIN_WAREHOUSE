import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../utils/utils.dart';

class CardChiTietDoanhThuWidget extends StatelessWidget {
  const CardChiTietDoanhThuWidget({
    super.key,
    required this.tongdoanhthu,
    required this.thanhcong,
    required this.dangcho,
    required this.huy,
  });

  final num tongdoanhthu;
  final int thanhcong;
  final int dangcho;
  final int huy;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<dynamic> chitietdonDoanhThu = [
      {
        "icon": doanhthuThanhCongIcon,
        "title": "  Đơn thành công",
        "value": thanhcong,
      },
      {
        "icon": doanhthuDangChoIcon,
        "title": "  Đơn đang chờ",
        "value": dangcho,
      },
      {
        "icon": doanhthuHuyIcon,
        "title": "  Đơn hủy",
        "value": huy,
      }
    ];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: size.width - 24,
        height: size.height * 0.23,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: backGround600Color.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                "Tổng doanh thu",
                style: TextStyle(fontSize: Font.sizes(context)[1]),
              ),
              const SizedBox(height: 5),
              Text(formatCurrency(tongdoanhthu),
                  style: TextStyle(fontSize: Font.sizes(context)[2])),
              const SizedBox(height: 5),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final doc = chitietdonDoanhThu[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image(
                                image: AssetImage(doc["icon"]),
                                width: Font.sizes(context)[2]),
                            Text(
                              doc["title"],
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[1]),
                            ),
                          ],
                        ),
                        Text(
                          doc["value"].toString(),
                          style: TextStyle(fontSize: Font.sizes(context)[1]),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
