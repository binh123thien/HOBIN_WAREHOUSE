import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../../common_widgets/snackbar/snackbar.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../repository/add_repository/hethan/hethan_repository.dart';
import '../../../../../../../repository/add_repository/xuathang/xuathang_repository.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../utils/validate/validate.dart';
import '../../../../../models/themdonhang_model.dart';
import '../../../../add/nhaphang/widget/danhsach_items_dachon.dart';
import '../../../../add/thanhtoan/chitiethoadon_screen.dart';

class XuatKhoHetHanScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItemsHetHan;
  const XuatKhoHetHanScreen({super.key, required this.selectedItemsHetHan});

  @override
  State<XuatKhoHetHanScreen> createState() => _XuatKhoHetHanScreenState();
}

class _XuatKhoHetHanScreenState extends State<XuatKhoHetHanScreen> {
  final controllerXuatHangRepo = Get.put(XuatHangRepository());
  final controllerHetHanRepo = Get.put(HetHanRepository());
  TextEditingController giaHetHanController = TextEditingController();
  bool _isLoading = false; // Sử dụng biến này để kiểm soát hiển thị loading
  bool _isDataSubmitted = false;
  @override
  Widget build(BuildContext context) {
    final formKey1 = GlobalKey<FormState>();
    num totalPrice = widget.selectedItemsHetHan
        .map<num>((item) => item['soluong'] * item['gia'])
        .reduce((value, element) => value + element);
    num totalQuantity = widget.selectedItemsHetHan
        .map<num>((item) => item['soluong'])
        .reduce((value, element) => value + element);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text("Xuất kho hết hạn",
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.w700)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          DanhSachItemsDaChonScreen(
            selectedItems: widget.selectedItemsHetHan,
            blockOnPress: true,
            reLoad: () {},
          ),
          PhanCachWidget.space(),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Form(
                key: formKey1,
                child: TextFormField(
                  controller: giaHetHanController,
                  validator: (value) {
                    return nonZeroInput(value!);
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      suffixText: "VND",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Tiền thực tế",
                      errorStyle: TextStyle(fontSize: 15),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 1)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Nhập số tiền'),
                )),
          )
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: mainColor,
                    side: const BorderSide(color: mainColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: () {
                    if (formKey1.currentState!.validate()) {
                      setState(() {
                        _isLoading = true; // Kích hoạt hiệu ứng loading
                      });
                      final num tongthanhtoan =
                          num.tryParse(giaHetHanController.value.text) ?? 0;
                      final hHcode = generateHHCode();
                      final ngaytao = formatNgayTao();
                      final datetime = formatDatetime();
                      final donhethan = ThemDonHangModel(
                        soHD: hHcode,
                        ngaytao: ngaytao,
                        khachhang: "Kho",
                        payment: "Xuất kho",
                        tongsl: totalQuantity,
                        tongtien: totalPrice,
                        giamgia: totalPrice - tongthanhtoan,
                        no: 0,
                        trangthai: "Thành công",
                        tongthanhtoan: tongthanhtoan,
                        billType: 'HetHan',
                        datetime: datetime,
                      );
                      _performDataProcessing(context, donhethan).then(
                        (value) {
                          setState(() {
                            _isLoading = false;
                            _isDataSubmitted = true;
                            if (_isDataSubmitted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChiTietHoaDonScreen(
                                    donnhaphang: donhethan,
                                    allThongTinItemNhap:
                                        widget.selectedItemsHetHan,
                                    phanbietNhapXuat: 'HetHan',
                                  ), // Thay 'TrangKhac' bằng tên trang bạn muốn chuyển đến
                                ),
                                // (route) =>
                                //     false, // Xóa hết tất cả các trang khỏi ngăn xếp
                              );
                              SnackBarWidget.showSnackBar(context,
                                  "Tạo hóa đơn thành công!", successColor);
                            }
                          });
                        },
                      );
                    }
                  },
                  child: _isLoading
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        ) // Hiển thị tiến trình loading
                      : const Text(
                          'Xác nhận xuất kho',
                          style: TextStyle(fontSize: 19),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _performDataProcessing(
      BuildContext context, ThemDonHangModel donnhaphang) async {
    try {
      //tao don het han
      await controllerHetHanRepo.createHoaDonHetHan(
          donnhaphang, widget.selectedItemsHetHan);
      // xoa ngay het han Expired
      await controllerHetHanRepo.deleteExpired(widget.selectedItemsHetHan);
      // xoa ngay het han trong han hoa
      await controllerHetHanRepo
          .deleteHangHoaExpired(widget.selectedItemsHetHan);
      //cap nhat gia tri ton kho het han
      await controllerHetHanRepo
          .capNhatGiaTriTonKhoHetHan(widget.selectedItemsHetHan);
      //tinh tong doanh thu
      await controllerXuatHangRepo.createTongDoanhThuNgay(
          donnhaphang.datetime, donnhaphang.tongthanhtoan, donnhaphang.no);
      await controllerXuatHangRepo.createTongDoanhThuTuan(
          donnhaphang.datetime, donnhaphang.tongthanhtoan, donnhaphang.no);
      await controllerXuatHangRepo.createTongDoanhThuThang(
          donnhaphang.datetime, donnhaphang.tongthanhtoan, donnhaphang.no);
    } catch (e) {
      // print("Error: $e");
    }
  }
}
