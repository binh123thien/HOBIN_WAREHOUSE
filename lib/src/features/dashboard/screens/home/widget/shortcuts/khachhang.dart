import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import '../../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../../common_widgets/network/network.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../repository/statistics_repository/khachhang_repository.dart';
import '../../../../controllers/statistics/khachhang_controller.dart';
import '../../../Widget/appbar/search_widget.dart';
import '../../../statistics/khachhang/widget/chitiet_khachhang.dart';
import '../../../statistics/khachhang/widget/sortby_khachhang.dart';
import '../../../statistics/khachhang/widget/them_khachhang.dart';

class KhachHangShortCutScreen extends StatefulWidget {
  const KhachHangShortCutScreen({super.key});

  @override
  State<KhachHangShortCutScreen> createState() =>
      _KhachHangShortCutScreenState();
}

class _KhachHangShortCutScreenState extends State<KhachHangShortCutScreen> {
  String searchKhachHang = "";
  final controller = Get.put(KhachHangController());
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
      appBar: AppBar(
        title: const Text("Khách Hàng",
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SearchWidget(
                  onChanged: (value) {
                    setState(() {
                      searchKhachHang = value;
                    });
                  },
                  width: 275,
                ),
                IconButton(
                    onPressed: () {
                      _showSortbyKhachHang();
                    },
                    icon: const Image(
                      image: AssetImage(sortbyIcon),
                      height: 28,
                    )),
                IconButton(
                    onPressed: () {
                      NetWork.checkConnection().then((value) {
                        if (value == "Not Connected") {
                          MyDialog.showAlertDialogOneBtn(
                              context,
                              "Không có Internet",
                              "Vui lòng kết nối internet và thử lại sau");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ThemKhachHangScreen()),
                          ).then((value) {
                            setState(() {});
                          });
                        }
                      });
                    },
                    icon: const Image(
                      image: AssetImage(themkhachhangIcon),
                      height: 28,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 5),
          SingleChildScrollView(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredKhachHang.length,
              itemBuilder: ((context, index) {
                var khachhang = filteredKhachHang[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              KhachHangDetailScreen(khachhang: khachhang)),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                    child: Row(
                      children: [
                        Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: backGroundColor),
                            child: Center(
                                child: Text(
                              khachhang["tenkhachhang"]
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(fontSize: 20),
                            ))),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              khachhang["tenkhachhang"],
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              khachhang["sdt"],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: khachhang["loai"] == "Nhà cung cấp"
                                      ? cancelColor
                                      : darkColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
