import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/khachhang_controller.dart';

import '../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../../../Widget/appbar/search_widget.dart';

class ChooseKhachHangThanhToanScreen extends StatefulWidget {
  const ChooseKhachHangThanhToanScreen({super.key});

  @override
  State<ChooseKhachHangThanhToanScreen> createState() =>
      _ChooseKhachHangThanhToanScreenState();
}

class _ChooseKhachHangThanhToanScreenState
    extends State<ChooseKhachHangThanhToanScreen> {
  String searchKhachHang = "";
  final controllerKhachHang = Get.put(KhachHangController());
  List<dynamic> allKhachHang = [];
  @override
  void initState() {
    controllerKhachHang.loadAllKhachHang();
    allKhachHang = controllerKhachHang.allKhachHangFirebase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 1,
        title: const Text("Nhà Cung Cấp",
            style: TextStyle(fontSize: 18, color: Colors.black)),
        backgroundColor: whiteColor,
        leading: IconButton(
            icon: const Image(
              image: AssetImage(backIcon),
              height: 17,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: whiteColor,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SearchWidget(
                      onChanged: (value) {
                        setState(() {
                          searchKhachHang = value;
                        });
                      },
                      width: 320,
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     _showSortbyHangHoaTaoDon();
                    //   },
                    //   icon: const Image(
                    //     image: AssetImage(sortbyIcon),
                    //     height: 28,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          itemCount: allKhachHang.length,
          physics: const PageScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final doc = allKhachHang[index];
            return InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(doc["tenkhachhang"],
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${doc["sdt"]}",
                            style: const TextStyle(fontSize: 13)),
                        Text(
                          "${doc["loai"]}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DotLineWidget.dotLine(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
