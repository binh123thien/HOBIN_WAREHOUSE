import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/dashboard.dart';
import '../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../constants/color.dart';
import '../../../../../utils/utils.dart';
import 'chitiet_lichsu_donhang.dart';

class CardHistory extends StatefulWidget {
  const CardHistory({
    super.key,
    required this.docs,
  });

  final List<dynamic> docs;

  @override
  State<CardHistory> createState() => _CardHistoryState();
}

class _CardHistoryState extends State<CardHistory> {
  List<dynamic> documents = [];
  @override
  void initState() {
    super.initState();
    documents = widget.docs;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          var doc = documents[index];
          phanbietIcon() {
            //BanHang thanh cong
            if (doc["billType"] == "XuatHang" &&
                doc["trangthai"] == "Thành công") {
              return xuathangIcon;
            } else
            //Nhaphang thanh cong
            if (doc["billType"] == "NhapHang" &&
                doc["trangthai"] == "Thành công") {
              return nhaphangIcon;
            } else
            //BanHang NhapHang Dang cho
            if (doc["trangthai"] == "Đang chờ") {
              return dangchoIcon;
            } else if (doc["billType"] == "HetHan") {
              return hethanIcon;
            } else {
              return huyIcon;
            }
          }

          phanbietmau() {
            if (doc["trangthai"] == "Thành công") {
              return success600Color;
            } else
            //BanHang NhapHang Dang cho
            if (doc["trangthai"] == "Đang chờ") {
              return processColor;
            } else {
              return cancel600Color;
            }
          }

          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChiTietLichSuDonHang(doc: doc)),
                  ).then((isHuy) {
                    if (isHuy) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(
                            currentPage: 3,
                          ),
                        ),
                      );
                    }
                  });
                },
                child: ListTile(
                  leading: SizedBox(
                      height: 35,
                      width: 35,
                      child: Image(image: AssetImage(phanbietIcon()))),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          doc["khachhang"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        doc["billType"] == "NhapHang" &&
                                doc["tongthanhtoan"] > 0
                            ? "-${formatCurrency(doc["tongthanhtoan"])}"
                            : "+${formatCurrency(doc["tongthanhtoan"])}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: doc["billType"] == "NhapHang" &&
                                    doc["tongthanhtoan"] > 0
                                ? cancel600Color
                                : darkColor),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${doc["ngaytao"]} - SL: ${doc["tongsl"]}",
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w100),
                        ),
                        Row(
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
                              width: 78,
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: phanbietmau()),
                                  color: whiteColor),
                              child: Center(
                                  child: Text(
                                doc["trangthai"],
                                style: TextStyle(
                                    fontSize: 12, color: phanbietmau()),
                              )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              PhanCachWidget.dotLine(context),
            ],
          );
        });
  }
}
