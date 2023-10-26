import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../../common_widgets/fontSize/font_size.dart';
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
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    num totalPrice = widget.selectedItemsHetHan
        .map<num>((item) => item['soluong'] * item['gia'])
        .reduce((value, element) => value + element);
    num totalQuantity = widget.selectedItemsHetHan
        .map<num>((item) => item['soluong'])
        .reduce((value, element) => value + element);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text("Xuất kho hết hạn",
            style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.w700,
                fontSize: Font.sizes(context)[2])),
        backgroundColor: mainColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
                size: size.width * 0.06,
                color: _isLoading == false ? whiteColor : mainColor),
            onPressed: _isLoading == false
                ? () {
                    Navigator.of(context).pop();
                  }
                : null),
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
                key: formKey,
                child: TextFormField(
                  controller: giaHetHanController,
                  validator: (value) {
                    return nonZeroInput(value!);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      suffixText: "VND",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Tiền thực tế",
                      errorStyle: TextStyle(fontSize: Font.sizes(context)[1]),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 1)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Nhập số tiền'),
                )),
          )
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        height: size.height * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                width: size.width - 30,
                height: size.height * 0.05,
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
                    if (formKey.currentState!.validate()) {
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
                      handleXuatKho(context, donhethan).then(
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
                      : Text(
                          'Xác nhận xuất kho',
                          style: TextStyle(fontSize: Font.sizes(context)[2]),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> handleXuatKho(
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
      //cap nhat gia tri da ban
      await controllerXuatHangRepo
          .capNhatGiaTriDaBanXuatHang(widget.selectedItemsHetHan);

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
