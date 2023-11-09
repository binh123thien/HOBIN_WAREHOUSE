import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';
import '../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../common_widgets/snackbar/snackbar.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../repository/add_repository/xuathang/xuathang_repository.dart';
import '../../../../models/themdonhang_model.dart';
import '../../xuathang/widget/danhsach_itemdachon_xuathang_widget.dart';
import '../chitiethoadon_screen.dart';
import '../widget/choose_khachhang_widget.dart';
import '../widget/giamgia_widget.dart';
import '../widget/giamgiavano_widget.dart';
import '../widget/phuongthucthanhtoan_widget.dart';
import '../widget/tomtatyeucau.dart';

class ThanhToanXuatHangScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allThongTinItemXuat;
  const ThanhToanXuatHangScreen({super.key, required this.allThongTinItemXuat});

  @override
  State<ThanhToanXuatHangScreen> createState() =>
      _ThanhToanXuatHangScreenState();
}

class _ThanhToanXuatHangScreenState extends State<ThanhToanXuatHangScreen> {
  final controllerXuatHangRepo = Get.put(XuatHangRepository());
  Map<String, dynamic> khachhang = {};
  num giamgia = 0;
  num no = 0;
  bool _isLoading = false; // Sử dụng biến này để kiểm soát hiển thị loading
  bool _isDataSubmitted = false;
  String selectedPaymentMethod = "Tiền mặt";
  void _reload(Map<String, dynamic> khachhangPicked) {
    setState(() {
      khachhang = khachhangPicked;
    });
  }

  void _giamGia() {
    // Khởi tạo FocusNode
    final focusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Gọi requestFocus sau khi showModalBottomSheet được mở
        Future.delayed(const Duration(milliseconds: 100), () {
          focusNode.requestFocus();
        });
        return GiamGiaWidget(
          focusNode: focusNode,
          keyWord: 'giamgia',
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          giamgia = num.tryParse(value)!;
        });
      }
    });
  }

  void _no() {
    // Khởi tạo FocusNode
    final focusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Gọi requestFocus sau khi showModalBottomSheet được mở
        Future.delayed(const Duration(milliseconds: 100), () {
          focusNode.requestFocus();
        });
        return GiamGiaWidget(
          focusNode: focusNode,
          keyWord: 'no',
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          no = num.tryParse(value)!;
        });
      }
    });
  }

  void _updatePaymentMethod(String newValue) {
    setState(() {
      selectedPaymentMethod = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    num totalPrice = widget.allThongTinItemXuat
        .map<num>((item) => item['soluong'] * item['gia'])
        .reduce((value, element) => value + element);

    num totalQuantity = widget.allThongTinItemXuat
        .map<num>((item) => item['soluong'])
        .reduce((value, element) => value + element);
    num tong = totalPrice - giamgia - no;
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 1,
          title: Text("Thanh Toán (${widget.allThongTinItemXuat.length})",
              style: const TextStyle(fontSize: 18, color: Colors.black)),
          backgroundColor: whiteColor,
          leading: IconButton(
              icon: Image(
                image: const AssetImage(backIcon),
                height: 15,
                color: _isLoading == false ? Colors.black : greyColor,
              ),
              onPressed: _isLoading == false
                  ? () {
                      Navigator.of(context).pop();
                    }
                  : null),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const PageScrollPhysics(),
          child: Column(
            children: [
              ChooseKhachHangWidget(
                khachhang: khachhang,
                reload: _reload,
                phanbietnhapxuat: 'xuathang',
              ),
              PhanCachWidget.space(),
              DanhSachItemDaChonXuatHangWidget(
                selectedItems: widget.allThongTinItemXuat,
                blockOnPress: true,
                reLoadOnDeleteXuatHang: () {},
              ),
              PhanCachWidget.space(),
              GiamGiaVaNoWidget(
                  giamgia: giamgia,
                  no: no,
                  giamgiaFunction: _giamGia,
                  noFunction: _no),
              PhanCachWidget.space(),
              TomTatYeuCauWidget(
                totalQuantity: totalQuantity,
                totalPrice: totalPrice,
                giamgia: giamgia,
                no: no,
                tong: tong,
              ),
              PhanCachWidget.space(),
              PhuongThucThanhToanWidget(
                selectedPaymentMethod: selectedPaymentMethod,
                reload: _updatePaymentMethod,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                return Column(
                  children: [
                    const SizedBox(height: 7),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tổng (${widget.allThongTinItemXuat.length} mặt hàng)",
                            style: const TextStyle(fontSize: 17),
                          ),
                          Text(
                            formatCurrency(tong),
                            style: const TextStyle(fontSize: 17),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: mainColor,
                          side: const BorderSide(color: mainColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoading = true; // Kích hoạt hiệu ứng loading
                          });
                          final xHcode = generateXHCode();
                          final ngaytao = formatNgayTao();
                          final datetime = formatDatetime();

                          final hoadonxuathang = ThemDonHangModel(
                            soHD: xHcode,
                            ngaytao: ngaytao,
                            khachhang: khachhang.isEmpty
                                ? "Khách hàng"
                                : khachhang["tenkhachhang"],
                            payment: selectedPaymentMethod,
                            tongsl: totalQuantity,
                            tongtien: totalPrice,
                            giamgia: giamgia,
                            no: no,
                            trangthai: no == 0 ? "Thành công" : "Đang chờ",
                            tongthanhtoan: tong,
                            billType: 'XuatHang',
                            datetime: datetime,
                          );
                          _performDataProcessing(context, hoadonxuathang).then(
                            (value) {
                              setState(() {
                                _isLoading = false;
                                _isDataSubmitted = true;
                                if (_isDataSubmitted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChiTietHoaDonScreen(
                                        donnhaphang: hoadonxuathang,
                                        allThongTinItemNhap:
                                            widget.allThongTinItemXuat,
                                        phanbietNhapXuat: 'XuatHang',
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
                                'Thanh toán',
                                style: TextStyle(fontSize: 19),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ));
  }

  Future<void> _performDataProcessing(
      BuildContext context, ThemDonHangModel donnhaphang) async {
    try {
      //tao don Xuat hang
      await controllerXuatHangRepo.createHoaDonXuatHang(
          donnhaphang, widget.allThongTinItemXuat);
      //cap nhat ngay het han
      await controllerXuatHangRepo.updateExpired(widget.allThongTinItemXuat);
      //cap nhat ngay het han trong hang hoa
      await controllerXuatHangRepo
          .updateHangHoaExpired(widget.allThongTinItemXuat);
      //cap nhat gia tri ton kho
      await controllerXuatHangRepo
          .capNhatGiaTriTonKhoXuatHang(widget.allThongTinItemXuat);
      //cap nhat gia tri da ban
      await controllerXuatHangRepo
          .capNhatGiaTriDaBanXuatHang(widget.allThongTinItemXuat);
      //tinh tong doanh thu
      await controllerXuatHangRepo.createTongDoanhThuNgay(
          donnhaphang.datetime, donnhaphang.tongthanhtoan, donnhaphang.no);
      await controllerXuatHangRepo.createTongDoanhThuTuan(
          donnhaphang.datetime, donnhaphang.tongthanhtoan, donnhaphang.no);
      await controllerXuatHangRepo.createTongDoanhThuThang(
          donnhaphang.datetime, donnhaphang.tongthanhtoan, donnhaphang.no);
    } catch (e) {
      //
    }
  }
}
