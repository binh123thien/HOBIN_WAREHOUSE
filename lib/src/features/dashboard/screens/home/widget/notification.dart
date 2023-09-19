import 'package:flutter/material.dart';

import '../../../../../constants/color.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: whiteColor // Số 10.0 ở đây là bán kính bo góc
                ),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return const Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.mark_email_unread,
                        size: 32,
                        color: processColor,
                      ),
                      title: Row(
                        children: [
                          Text(
                            "Sản phẩm sắp hết hạn",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                          Text(
                            " - 8 giờ trước",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Bạn có sản phẩm "Sting" sắp hết hạn trong 7 ngày tới',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Divider(),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}
