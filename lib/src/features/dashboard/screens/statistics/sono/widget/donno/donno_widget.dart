import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/statistics/sono/widget/donno/sortby_donno.dart';
import '../../../../../../../common_widgets/fontSize/font_size.dart';
import '../../../../../../../constants/icon.dart';
import '../../../../../../../repository/statistics_repository/khachhang_repository.dart';
import '../../../../../../../utils/utils.dart';
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
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
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
    List<dynamic> donnoList = alldonhang
        .where((doc) => doc["no"] != 0 && doc["trangthai"] != "Hủy")
        .toList();
    List<dynamic> dasortby = controllerRepo.sortbyKhachHang(
        donnoList, controllerKhachHang.sortbyDonNoController.text);
    List<dynamic> locdonnoList = dasortby
        .where((item) => item["khachhang"]
            .toString()
            .toLowerCase()
            .contains(searchKhachHang.toLowerCase()))
        .toList();
    double tongno = donnoList.fold(0.0, (sum, doc) {
      if (doc["no"] != null) {
        return sum + doc["no"];
      } else {
        return sum;
      }
    });
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
        const SizedBox(height: 10),
        Container(
          width: size.width,
          height: size.height * 0.038,
          color: processColor,
          child: Center(
            child: Text(
              "Tổng nợ: ${formatCurrency(tongno)}",
              style: TextStyle(
                  fontSize: Font.sizes(context)[1], color: whiteColor),
            ),
          ),
        ),
        Container(
          color: whiteColor,
          width: size.width,
          height: size.height * 0.55,
          child: CardListDanhSachNo(
            docs: locdonnoList,
          ),
        ),
      ],
    );
  }
}
