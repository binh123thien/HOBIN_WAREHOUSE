import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/khachhang/widget/chitiet_khachhang.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/khachhang/widget/sortby_khachhang.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/khachhang/widget/them_khachhang.dart';

import '../../../../../repository/statistics_repository/khachhang_repository.dart';
import '../../../controllers/statistics/khachhang_controller.dart';
import '../../Widget/appbar/search_widget.dart';

class KhachHangScreen extends StatefulWidget {
  const KhachHangScreen({super.key});

  @override
  State<KhachHangScreen> createState() => _KhachHangScreenState();
}

class _KhachHangScreenState extends State<KhachHangScreen> {
  String searchKhachHang = "";
  final KhachHangController controller = Get.find();
  final controllerRepo = Get.put(KhachHangRepository());
  final controllerKhachHang = Get.put(KhachHangController());
  late List<dynamic> allKhachHang;
  List<dynamic> filteredKhachHang = [];

  @override
  void initState() {
    super.initState();
    controllerKhachHang.loadAllKhachHang();
    allKhachHang = controller.allKhachHangFirebase;
    filteredKhachHang = allKhachHang;
  }

  Future<void> _showSortbyKhachHang() async {
    final selectedValue = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return DanhSachSortByKhachHang(
            sortbykhachhangController: controllerKhachHang
                .sortbyKhachHangController); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    );
    if (selectedValue != null) {
      setState(() {
        controllerKhachHang.sortbyKhachHangController.text = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<dynamic> newitem = controllerRepo.sortbyKhachHang(
        controllerKhachHang.allKhachHangFirebase,
        controllerKhachHang.sortbyKhachHangController.text);
    filteredKhachHang = newitem
        .where((item) =>
            item["tenkhachhang"]
                .toString()
                .toLowerCase()
                .contains(searchKhachHang.toLowerCase()) ||
            item["sdt"]
                .toString()
                .toLowerCase()
                .contains(searchKhachHang.toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SearchWidget(
                    onChanged: (value) {
                      setState(() {
                        searchKhachHang = value;
                      });
                    },
                    width: 270,
                  ),
                  IconButton(
                      onPressed: () {
                        _showSortbyKhachHang();
                      },
                      icon: const Image(image: AssetImage(sortbyIcon))),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ThemKhachHangScreen()),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      icon: const Image(image: AssetImage(themkhachhangIcon))),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: size.width,
                height: size.height - 243,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredKhachHang.length,
                  itemBuilder: ((context, index) {
                    var khachhang = filteredKhachHang[index];
                    return Card(
                      color: whiteColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KhachHangDetailScreen(
                                    khachhang: khachhang)),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        leading: const Image(
                          image: AssetImage(khachhangIcon),
                          height: 32,
                        ),
                        title: Text(
                          khachhang["tenkhachhang"],
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w900),
                        ),
                        subtitle: Text(
                          khachhang["sdt"],
                          style: TextStyle(
                              fontSize: 15,
                              color: khachhang["loai"] == "Nhà cung cấp"
                                  ? cancelColor
                                  : darkColor),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
