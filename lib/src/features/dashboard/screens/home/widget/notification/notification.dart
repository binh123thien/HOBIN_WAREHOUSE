import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

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
  @override
  void initState() {
    super.initState();
    controllerNotification.loadAllNotification();
    allNotification = controllerNotification.allNotification;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: const Text("Thông báo",
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
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
                              'Bạn có ${doc["lengthSanPham"]} sản phẩm sắp hết hạn trong 7 ngày tới',
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Xem chi tiết",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
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
