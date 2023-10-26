import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../repository/statistics_repository/khachhang_repository.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../controllers/statistics/khachhang_controller.dart';
import '../../../../Widget/appbar/search_widget.dart';
import 'listdanhsachno.dart';
import 'sortby_khachno.dart';

class DanhSachNoWidget extends StatefulWidget {
  const DanhSachNoWidget({super.key});

  @override
  State<DanhSachNoWidget> createState() => _DanhSachNoWidgetState();
}

class _DanhSachNoWidgetState extends State<DanhSachNoWidget> {
  final controllerKhachHangRepo = Get.put(KhachHangRepository());
  final controllerKhachHang = Get.put(KhachHangController());
  String searchKhachHang = "";
  final KhachHangController controller = Get.find();
  late List<dynamic> donbanhang;
  late List<dynamic> donnhaphang;
  @override
  void initState() {
    super.initState();
    donbanhang = controller.allDonBanHangFirebase;
    donnhaphang = controller.allDonNhapHangFirebase;
  }

  Future<void> _showSortbyKhachHang() async {
    final selectedValue = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      builder: (BuildContext context) {
        return SortByKhachNo(
            sortbyKhachNoController: controllerKhachHang
                .sortbyKhachNoController); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    );
    if (selectedValue != null) {
      setState(() {
        controllerKhachHang.sortbyKhachNoController.text = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> alldonhang = [];
    alldonhang.addAll(donbanhang);
    alldonhang.addAll(donnhaphang);
    List<dynamic> donnoList = alldonhang
        .where((doc) => doc["no"] != 0 && doc["trangthai"] != "Hủy")
        .toList();
    //loc don khach hang bi trung lap
    Map<dynamic, dynamic> groupedData = {};
    for (var doc in donnoList) {
      if (groupedData.containsKey(doc["khachhang"])) {
        groupedData[doc["khachhang"]]["no"] += doc["no"];
      } else {
        groupedData[doc["khachhang"]] = {
          "khachhang": doc["khachhang"],
          "no": doc["no"],
          "billType": doc["billType"]
        };
      }
    }

    List<dynamic> donnoBoTrungLap = groupedData.values.toList();
    List<dynamic> dasortby = controllerKhachHangRepo.sortbyKhachHang(
        donnoBoTrungLap, controllerKhachHang.sortbyKhachNoController.text);
    List<dynamic> filteredList = dasortby
        .where((item) => item["khachhang"]
            .toString()
            .toLowerCase()
            .contains(searchKhachHang.toLowerCase()))
        .toList();
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SearchWidget(
                onChanged: (value) {
                  setState(() {
                    searchKhachHang = value;
                  });
                },
                width: size.width * 0.75,
              ),
              IconButton(
                  onPressed: () {
                    _showSortbyKhachHang();
                  },
                  icon: Image(
                    image: const AssetImage(sortbyIcon),
                    height: size.width * 0.08,
                  ))
            ],
          ),
        ),
        SizedBox(
          width: size.width,
          height: size.height * 0.6,
          child: donnoList.isEmpty
              ? Center(
                  child: Text(
                    "Chưa có khách nợ!",
                    style: TextStyle(fontSize: Font.sizes(context)[1]),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final khachno = filteredList[index];

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListDanhSachNo(
                                    tenkhachhang:
                                        khachno["khachhang"].toString(),
                                    billType: khachno["billType"].toString(),
                                  )),
                        ).then((_) {
                          setState(() {
                            donbanhang = controller.allDonBanHangFirebase;
                            donnhaphang = controller.allDonNhapHangFirebase;
                          });
                        });
                      },
                      leading: Icon(Icons.account_circle,
                          size: size.width * 0.08, color: darkColor),
                      title: Text(
                        khachno["khachhang"].toString(),
                        style: TextStyle(
                            fontSize: Font.sizes(context)[2],
                            fontWeight: FontWeight.w900,
                            color: khachno["billType"] == "NhapHang"
                                ? cancel600Color
                                : darkColor),
                      ),
                      subtitle: khachno["billType"] == "NhapHang"
                          ? Text("Nhà cung cấp",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[0]))
                          : Text("Khách hàng",
                              style:
                                  TextStyle(fontSize: Font.sizes(context)[0])),
                      trailing: Text(
                        formatCurrency(khachno["no"]),
                        style: TextStyle(fontSize: Font.sizes(context)[1]),
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}
