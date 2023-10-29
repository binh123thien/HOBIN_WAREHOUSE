import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../repository/notification_repository/notification_repository.dart';
import '../../../../controllers/home/notification_controller.dart';

class ChiTietThongBaoScreen extends StatefulWidget {
  final dynamic notification;
  const ChiTietThongBaoScreen({super.key, required this.notification});

  @override
  State<ChiTietThongBaoScreen> createState() => _ChiTietThongBaoScreenState();
}

class _ChiTietThongBaoScreenState extends State<ChiTietThongBaoScreen> {
  final controllerNotiRepo = Get.put(NotificationRepository());
  final controllerNotification = Get.put(NotificationController());
  @override
  void initState() {
    super.initState();
    controllerNotiRepo
        .updateReadNotification(widget.notification["datetime"].split(' ')[0]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
            "Thông báo ${controllerNotiRepo.convertDateFormat(widget.notification["datetime"])}",
            style: TextStyle(
                color: whiteColor,
                fontSize: Font.sizes(context)[2],
                fontWeight: FontWeight.w700)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image(
                    image: const AssetImage(warningIcon),
                    height: size.width * 0.05,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Các sản phẩm bên dưới sẽ hết hạn trong vài ngày tới, hãy chú ý xử lý sảm phẩm!",
                      style: TextStyle(
                        fontSize: Font.sizes(context)[1],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.notification["detail"].length,
                itemBuilder: (context, index) {
                  final doc = widget.notification["detail"][index];

                  final Map<String, dynamic> banghethan = {
                    "Mã sản phẩm:": doc["macode"],
                    "HSD:": doc["exp"],
                    "Vị trí:": doc["location"],
                    "Số lượng:": doc["soluong"],
                    "Ước tính vốn:": formatCurrency(doc["soluong"] * doc["gia"])
                  };
                  final keysList = banghethan.keys.toList();
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: mainColor,
                        ),
                        height: size.height * 0.165,
                        width: size.width,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 7, 12, 5),
                          child: Text(
                            doc["tensanpham"],
                            style: TextStyle(
                                fontSize: Font.sizes(context)[1],
                                color: whiteColor),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 1,
                        left: 1,
                        right: 1,
                        child: Container(
                          width: size.width,
                          height: size.height * 0.125,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: whiteColor,
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: keysList.length,
                                itemBuilder: (context, index) {
                                  final key =
                                      keysList[index]; // Lấy key từ danh sách
                                  final value = banghethan[
                                      key]; // Lấy giá trị tương ứng từ banghethan

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        key,
                                        style: TextStyle(
                                            fontSize: Font.sizes(context)[0]),
                                      ),
                                      Text(
                                        value.toString(),
                                        style: TextStyle(
                                            fontSize: Font.sizes(context)[0]),
                                      ),
                                    ],
                                  );
                                },
                              )),
                        ),
                      )
                    ]

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       doc["tensanpham"],
                        //       style: const TextStyle(fontSize: 16),
                        //     ),
                        //     ListView.builder(
                        //       shrinkWrap: true,
                        //       itemCount: keysList.length,
                        //       itemBuilder: (context, index) {
                        //         final key = keysList[index]; // Lấy key từ danh sách
                        //         final value = banghethan[
                        //             key]; // Lấy giá trị tương ứng từ banghethan

                        //         return Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               key,
                        //               style: const TextStyle(fontSize: 16),
                        //             ),
                        //             Text(
                        //               value.toString(),
                        //               style: const TextStyle(fontSize: 16),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     )
                        //   ],
                        // ),

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
