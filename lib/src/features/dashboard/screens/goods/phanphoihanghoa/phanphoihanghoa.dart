import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../repository/goods_repository/good_repository.dart';
import '../../../controllers/add/chonhanghoa_controller.dart';
import '../../../controllers/goods/chonhanghoale_controller.dart';
import '../../../controllers/goods/them_hanghoa_controller.dart';
import '../../Widget/appbar/search_widget.dart';
import '../../Widget/card_hanghoa_widget.dart';
import '../widget/sorbyhanghoa/danhsach_sortby.dart';
import 'chonhanghoale.dart';
import 'lichsuchuyendoi.dart';

class PhanPhoiHangHoaScreen extends StatefulWidget {
  final dynamic hanghoaSi;
  const PhanPhoiHangHoaScreen({super.key, this.hanghoaSi});

  @override
  State<PhanPhoiHangHoaScreen> createState() => _PhanPhoiHangHoaScreenState();
}

class _PhanPhoiHangHoaScreenState extends State<PhanPhoiHangHoaScreen> {
  late dynamic updatehanghoaSi;
  String searchHangHoa = "";
  //tạo list hangHoaLe
  late List<dynamic> allHangHoa = [];
  // ========================== sorrt by ======================
  final controllersortby = Get.put(ThemHangHoaController());
  final controllerAllHangHoa = Get.put(ChonHangHoaController());
  final controllerRepo = Get.put(GoodRepository());
  final chonHangHoaLeController = Get.put(ChonHangHoaLeController());
  Future<void> _showSortbyHangHoa() async {
    final selectedValue = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (BuildContext context) {
        return DanhSachSortByHangHoa(
          sortbyhanghoaController: controllersortby.sortbyhanghoaController,
        ); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
      },
    );
    if (selectedValue != null) {
      setState(() {
        controllersortby.sortbyhanghoaController.text = selectedValue;
      });
    }
  }
  //===================== end sort by ==========================================================

  @override
  void initState() {
    //load trước dữ liệu của list lịch sử
    chonHangHoaLeController.loadAllLichSu(widget.hanghoaSi['tensanpham']);
    updatehanghoaSi = widget.hanghoaSi;
    allHangHoa = controllerAllHangHoa.allHangHoaFireBase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bottom sheet lịch sử
    Future<void> showLichSuChuyenDoi() async {
      await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return LichSuChuyenDoiScreen(
            nameProductSi: updatehanghoaSi['tensanpham'],
          ); // Gọi Widget BottomSheetContent để hiển thị bottom sheet
        },
      );
    }

    // Xác định hàng hóa bán sỉ
    List<dynamic> allHangHoaLe = allHangHoa
        .where((item) =>
            item["phanloai"].toString().toLowerCase().contains('bán lẻ'))
        .toList();
    // Sắp xếp danh sách theo thứ tự tăng dần của "tonkho"
    controllerRepo.sortby(
        allHangHoaLe, controllersortby.sortbyhanghoaController.text);
    // Xác định tất cả các mục chứa từ khóa tìm kiếm trong sỉ
    List<dynamic> filteredItemsLe = allHangHoaLe
        .where((item) => item["tensanpham"]
            .toString()
            .toLowerCase()
            .contains(searchHangHoa.toLowerCase()))
        .toList();

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text("Phân phối hàng hóa",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {
              showLichSuChuyenDoi();
            },
            icon: const Image(
              image: AssetImage(historyShareGoodIcon),
              height: 25,
            ),
          ),
          IconButton(
            color: Colors.black,
            onPressed: () {
              MyDialog.showAlertDialogOneBtn(context, "Hướng dẫn",
                  "  Việc phân phối hàng hóa giúp bạn chia sản phẩm sỉ ra thành sản phẩm lẻ. Điều này giúp bạn dễ dàng kiểm soát được lượng hàng bán lẻ.\n\nVD: 1 Thùng = 24 lon");
            },
            icon: const Image(
              image: AssetImage(warningIcon),
              height: 25,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SearchWidget(
                      onChanged: (value) {
                        setState(() {
                          searchHangHoa = value;
                        });
                      },
                      width: 310,
                    ),
                    IconButton(
                        onPressed: () {
                          _showSortbyHangHoa();
                        },
                        icon: const Image(image: AssetImage(sortbyIcon))),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Đang chọn: ${updatehanghoaSi['tensanpham']}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    )),
                const SizedBox(height: 3),
                const Text('Mặt hàng muốn phân phối:',
                    style: TextStyle(
                      fontSize: 17,
                    )),
                SizedBox(
                  width: size.width,
                  height: size.height - 230,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListView.builder(
                      itemCount: filteredItemsLe.length,
                      itemBuilder: (context, index) {
                        var hanghoa = filteredItemsLe[index];
                        return CardHangHoa(
                          hanghoa: hanghoa,
                          onTapChiTietHangHoa: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChonHangHoaLeScreen(
                                        hanghoaLe: hanghoa,
                                        hanghoaSi: updatehanghoaSi,
                                      )),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
