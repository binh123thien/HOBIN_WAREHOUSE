import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/color.dart';
import '../../../../constants/icon.dart';
import '../../../../repository/statistics_repository/khachhang_repository.dart';
import '../Widget/appbar/search_widget.dart';

class ChooseKhachHangScreen extends StatefulWidget {
  final int phanbietNhapXuat;
  final String khachHangSelected;
  const ChooseKhachHangScreen(
      {super.key,
      required this.phanbietNhapXuat,
      required this.khachHangSelected});

  @override
  State<ChooseKhachHangScreen> createState() => _ChooseKhachHangScreenState();
}

class _ChooseKhachHangScreenState extends State<ChooseKhachHangScreen> {
  late String khachHangSelectedNew;
  String searchKhachHang = "";
  final controllerRepo = Get.put(KhachHangRepository());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: backGroundColor,
        ),
        height: size.height * 0.8,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Divider(
                  // thêm Divider
                  height: 1,
                  thickness: 3,
                  color: backGround600Color.withOpacity(0.5),
                  indent: 140,
                  endIndent: 140,
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.phanbietNhapXuat == 0
                            ? 'Danh sách khách hàng'
                            : 'Danh sách nhà cung cấp',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: -10,
                      bottom: 0,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.cancel_rounded)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SearchWidget(
                  onChanged: (value) {
                    setState(() {
                      searchKhachHang = value;
                    });
                  },
                  width: 320,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: controllerRepo.getAllKhachHang(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          List<dynamic> allKhachHang = [].obs;
                          List<dynamic> allKhachHangNew = [].obs;
                          // Lặp qua tất cả các tài liệu và thêm chúng vào danh sách tạm thời
                          for (var doc in snapshot.data!.docs) {
                            var allKhachHangFirebase =
                                doc.data() as Map<String, dynamic>;
                            allKhachHang.add(allKhachHangFirebase);
                          }
                          allKhachHangNew = controllerRepo.sortbyKhachHang(
                              allKhachHang,
                              widget.phanbietNhapXuat == 0
                                  ? "Khách hàng"
                                  : "Nhà cung cấp");
                          List<dynamic> filteredItems = allKhachHangNew
                              .where((item) => item["tenkhachhang"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchKhachHang.toLowerCase()))
                              .toList();
                          return ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: ((context, index) {
                                var khachhang = filteredItems[index];
                                return Card(
                                  color: whiteColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        khachHangSelectedNew =
                                            khachhang["tenkhachhang"];
                                      });
                                      Navigator.of(context)
                                          .pop(khachHangSelectedNew);
                                    },
                                    leading: const Image(
                                      image: AssetImage(customerIcon),
                                      height: 32,
                                    ),
                                    title: Text(
                                      khachhang["tenkhachhang"],
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    subtitle: Text(
                                      khachhang["sdt"],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: khachhang["loai"] ==
                                                  "Nhà cung cấp"
                                              ? cancelColor
                                              : darkColor),
                                    ),
                                  ),
                                );
                              }));
                        }
                      }),
                ),
              ],
            )),
      ),
    );
  }
}
