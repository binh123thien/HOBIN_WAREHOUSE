import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/nhaphang/choose_goods.dart';

class NhapHangScreen extends StatefulWidget {
  const NhapHangScreen({super.key});

  @override
  State<NhapHangScreen> createState() => _NhapHangScreenState();
}

class _NhapHangScreenState extends State<NhapHangScreen> {
  List<Map<String, String>> items = [
    {"icon": goodsIcon, "title": "Chọn hàng hóa"},
    {"icon": locationIcon, "title": "Chọn vị trí"},
    {"icon": calendarIcon, "title": "Chọn ngày hết hạn"},
    {"icon": quantityIcon, "title": "Chọn số lượng"},
  ];

  Map<String, String> thongTinItemNhap = {
    "hanghoa": "",
    "location": "",
    "exp": "",
    "soluong": ""
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Nhập hàng", style: TextStyle(fontSize: 18)),
        backgroundColor: blueColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              final docs = items[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseGoodsScreen()),
                      ).then((value) {
                        setState(() {
                          thongTinItemNhap["hanghoa"] = value["tensanpham"];
                          print(thongTinItemNhap);
                        });
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: Image(image: AssetImage(docs["icon"]!)),
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: index == 0 &&
                                    thongTinItemNhap["hanghoa"]!.isNotEmpty
                                ? Text(
                                    thongTinItemNhap["hanghoa"]!,
                                    style: const TextStyle(fontSize: 17),
                                  )
                                : index == 1 &&
                                        thongTinItemNhap["location"]!.isNotEmpty
                                    ? Text(
                                        thongTinItemNhap["location"]!,
                                        style: const TextStyle(fontSize: 17),
                                      )
                                    : index == 2 &&
                                            thongTinItemNhap["exp"]!.isNotEmpty
                                        ? Text(
                                            thongTinItemNhap["exp"]!,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          )
                                        : index == 3 &&
                                                thongTinItemNhap["soluong"]!
                                                    .isNotEmpty
                                            ? Text(
                                                thongTinItemNhap["soluong"]!,
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )
                                            : Text(
                                                docs["title"]!,
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
