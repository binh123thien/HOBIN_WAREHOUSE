import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../repository/goods_repository/good_repository.dart';
import '../../../controllers/add/chonhanghoa_controller.dart';
import '../../../controllers/goods/them_hanghoa_controller.dart';
import '../../Widget/appbar/search_widget.dart';
import '../../Widget/card_phanphoihanghoa_widget.dart';
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
    updatehanghoaSi = widget.hanghoaSi;
    allHangHoa = controllerAllHangHoa.allHangHoaFireBase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // show UI
    final tenSPSi = updatehanghoaSi['tensanpham'].toUpperCase();
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
    // Xác định tất cả các mục chứa từ khóa tìm kiếm trong sỉ
    List<dynamic> filteredItemsSi = allHangHoaLe
        .where((item) => item["tensanpham"]
            .toString()
            .toLowerCase()
            .contains(searchHangHoa.toLowerCase()))
        .toList();
    // Sắp xếp danh sách theo thứ tự tăng dần của "tonkho"
    controllerRepo.sortby(
        allHangHoa, controllersortby.sortbyhanghoaController.text);
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
            icon: const Icon(Icons.receipt_long_outlined,
                size: 30, color: darkColor),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 30, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: null,
                              icon: Image(image: AssetImage(warningIcon))),
                        ),
                        Expanded(
                          child: Text(
                            '   Việc phân phối hàng hóa giúp bạn chia sản phẩm sỉ ra thành sản phẩm lẻ. Điều này giúp bạn dễ dàng kiểm soát được lượng hàng bán lẻ.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text('VD 1 Thùng = 24 lon'),
                    SizedBox(height: 15),
                    Text(
                      'CHỌN HÀNG HÓA LẺ CÙNG LOẠI',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SearchWidget(
                    onChanged: (value) {
                      setState(() {
                        searchHangHoa = value;
                      });
                    },
                    width: 270,
                  ),
                  IconButton(
                      onPressed: () {
                        _showSortbyHangHoa();
                      },
                      icon: const Image(image: AssetImage(sortbyIcon))),
                ],
              ),
              Text('MẶT HÀNG SỈ: $tenSPSi',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                width: size.width,
                height: size.height - 230,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: ListView.builder(
                    itemCount: filteredItemsSi.length,
                    itemBuilder: (context, index) {
                      var hanghoa = filteredItemsSi[index];
                      return CardPhanPhoiHangHoa(
                        phanBietSiLe: false, //lẻ
                        hinhanh: hanghoa['photoGood'],
                        donvi: hanghoa["donvi"],
                        tensanpham: hanghoa["tensanpham"],
                        tonkho: hanghoa["tonkho"].toString(),
                        giaban: hanghoa["giaban"],
                        daban: hanghoa["daban"].toString(),
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
    );
  }
}
