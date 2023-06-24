import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/sono/widget/donno/sortby_donno.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../repository/statistics_repository/khachhang_repository.dart';
import '../../../../../controllers/statistics/khachhang_controller.dart';
import '../../../../Widget/appbar/search_widget.dart';
import '../danhsachno/card_listdanhsachno.dart';

class DonNoWidget extends StatefulWidget {
  const DonNoWidget({super.key});

  @override
  State<DonNoWidget> createState() => _DonNoWidgetState();
}

class _DonNoWidgetState extends State<DonNoWidget> {
  final KhachHangController controller = Get.find();
  final controllerKhachHang = Get.put(KhachHangController());
  final controllerRepo = Get.put(KhachHangRepository());
  late List<dynamic> donbanhang;
  late List<dynamic> donnhaphang;
  @override
  void initState() {
    donbanhang = controller.allDonBanHangFirebase;
    donnhaphang = controller.allDonNhapHangFirebase;
    super.initState();
  }

  String searchKhachHang = "";
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
        return SortByDonNo(
            sortbyDonNoController: controllerKhachHang
                .sortbyDonNoController); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    );
    if (selectedValue != null) {
      setState(() {
        controllerKhachHang.sortbyDonNoController.text = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<dynamic> alldonhang = [];
    alldonhang.addAll(donbanhang);
    alldonhang.addAll(donnhaphang);
    List<dynamic> donnoList =
        alldonhang.where((doc) => doc["no"] != 0).toList();
    List<dynamic> dasortby = controllerRepo.sortbyKhachHang(
        donnoList, controllerKhachHang.sortbyDonNoController.text);
    List<dynamic> locdonnoList = dasortby
        .where((item) => item["khachhang"]
            .toString()
            .toLowerCase()
            .contains(searchKhachHang.toLowerCase()))
        .toList();
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
          padding: const EdgeInsets.all(10.0),
          child: Container(
            color: whiteColor,
            width: size.width,
            height: size.height - kToolbarHeight - 233,
            child: CardListDanhSachNo(
              docs: locdonnoList,
            ),
          ),
        ),
      ],
    );
  }
}
