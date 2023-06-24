import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    donbanhang = controller.allDonBanHangFirebase;
    donnhaphang = controller.allDonNhapHangFirebase;
    super.initState();
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
    List<dynamic> donnoList =
        alldonhang.where((doc) => doc["no"] != 0).toList();
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
                width: 320,
              ),
              IconButton(
                  onPressed: () {
                    _showSortbyKhachHang();
                  },
                  icon: const Image(
                    image: AssetImage(sortbyIcon),
                    height: 30,
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            width: size.width,
            height: size.height - kToolbarHeight - 225,
            child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final khachno = filteredList[index];

                  return Card(
                    color: whiteColor,
                    elevation: 1,
                    child: ListTile(
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
                      leading: const Icon(Icons.account_circle,
                          size: 30, color: darkColor),
                      title: Text(
                        khachno["khachhang"].toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: khachno["billType"] == "NhapHang"
                                ? cancel600Color
                                : darkColor),
                      ),
                      trailing: Text(
                        formatCurrency(khachno["no"]),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
