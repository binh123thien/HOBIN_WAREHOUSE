import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../repository/notification_repository/notification_repository.dart';
import '../../../../controllers/home/notification_controller.dart';
import 'chitietthongbao.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controllerNotification = Get.put(NotificationController());
  final controllerNotificationRepo = Get.put(NotificationRepository());
  List<dynamic> allNotification = [];
  List<dynamic> countSpHetHan = [];
  @override
  void initState() {
    super.initState();
    controllerNotification.loadAllNotification();
    allNotification = controllerNotification.allNotification;
    countSpHetHan =
        controllerNotificationRepo.demSanPhamHetHanVaSapHetHan(allNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: Text("Thông báo",
              style: TextStyle(
                  color: whiteColor,
                  fontSize: Font.sizes(context)[2],
                  fontWeight: FontWeight.w700)),
          backgroundColor: mainColor,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              // color: whiteColor // Số 10.0 ở đây là bán kính bo góc
            ),
            child: ListView.builder(
              itemCount: allNotification.length,
              itemBuilder: (context, index) {
                final doc = allNotification[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ChiTietThongBaoScreen(
                            notification: doc,
                          )),
                    ).then((_) {
                      setState(() {
                        doc["read"] = 1;
                      });
                    });
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.mark_email_unread,
                          size: 32,
                          color:
                              doc["read"] == 0 ? processColor : darkLiteColor,
                        ),
                        title: Wrap(
                          children: [
                            const Text(
                              "Sản phẩm sắp hết hạn - ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                            Text(
                              controllerNotificationRepo
                                  .khoangCachThoiGianThongBao(doc["datetime"])
                                  .toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        subtitle: Wrap(
                          children: [
                            Text(
                              "Bạn có ${countSpHetHan[index]["spHetHan"] > 0 ? "${countSpHetHan[index]["spHetHan"]} sản phẩm đã hết hạn," : ""} ${countSpHetHan[index]["spChuaHetHan"] > 0 ? "${countSpHetHan[index]["spChuaHetHan"]} sản phẩm sẽ hết hạn trong 7 ngày tới," : ""}",
                              style: const TextStyle(fontSize: 15),
                              softWrap: true, // Tự động xuống dòng
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      controllerNotificationRepo
                                          .convertDateFormat(doc["datetime"]),
                                      style: TextStyle(
                                          fontSize: Font.sizes(context)[0])),
                                  Text(
                                    "Xem chi tiết",
                                    style: TextStyle(
                                        fontSize: Font.sizes(context)[1]),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Divider(),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}
