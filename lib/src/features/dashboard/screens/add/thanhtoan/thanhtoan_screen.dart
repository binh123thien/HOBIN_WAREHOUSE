import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';
import '../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../repository/add_repository/add_repository.dart';
import '../../../models/themdonhang_model.dart';
import '../nhaphang/widget/danhsachitemdachon/danhsachsanpham_dachon.dart';
import 'chitiethoadon_screen.dart';
import 'widget/choose_khachhang_widget.dart';
import 'widget/giamgia_widget.dart';
import 'widget/giamgiavano_widget.dart';
import 'widget/phuongthucthanhtoan_widget.dart';
import 'widget/tomtatyeucau.dart';

class ThanhToanScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allThongTinItemNhap;
  const ThanhToanScreen({super.key, required this.allThongTinItemNhap});

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  final controllerAddRepo = Get.put(AddRepository());
  Map<String, dynamic> khachhang = {};
  num giamgia = 0;
  num no = 0;
  bool _isLoading = false; // Sử dụng biến này để kiểm soát hiển thị loading
  bool _isDataSubmitted =
      false; // Sử dụng biến này để kiểm soát khi nào dữ liệu đã được gửi thành công
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
    num totalPrice = widget.allThongTinItemNhap
        .map<num>((item) => item['soluong'] * item['gia'])
        .reduce((value, element) => value + element);

    num totalQuantity = widget.allThongTinItemNhap
        .map<num>((item) => item['soluong'])
        .reduce((value, element) => value + element);
    num tong = totalPrice - giamgia - no;
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 1,
          title: Text("Thanh Toán (${widget.allThongTinItemNhap.length})",
              style: const TextStyle(fontSize: 18, color: Colors.black)),
          backgroundColor: whiteColor,
          leading: IconButton(
              icon: const Image(
                image: AssetImage(backIcon),
                height: 17,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const PageScrollPhysics(),
          child: Column(
            children: [
              ChooseKhachHangWidget(
                khachhang: khachhang,
                reload: _reload,
              ),
              PhanCachWidget.space(),
              DanhSachSanPhamDaChonWidget(
                selectedItems: widget.allThongTinItemNhap,
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
                            "Tổng (${widget.allThongTinItemNhap.length} mặt hàng)",
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
                          backgroundColor: blueColor,
                          side: const BorderSide(color: blueColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true; // Kích hoạt hiệu ứng loading
                          });

                          final nHcode = generateNHCode();
                          final ngaytao = formatNgayTao();
                          final datetime = formatDatetime();

                          final donnhaphang = ThemDonHangModel(
                            soHD: nHcode,
                            ngaytao: ngaytao,
                            khachhang: khachhang.isEmpty
                                ? "Nhà cung cấp"
                                : khachhang["tenkhachhang"],
                            payment: selectedPaymentMethod,
                            tongsl: totalQuantity,
                            tongtien: totalPrice,
                            giamgia: giamgia,
                            no: no,
                            trangthai: no == 0 ? "Thành công" : "Đang chờ",
                            tongthanhtoan: tong,
                            billType: 'NhapHang',
                            datetime: datetime,
                          );

                          _performDataProcessing(context, donnhaphang).then(
                            (value) {
                              setState(() {
                                _isLoading = false;
                                _isDataSubmitted = true;
                                if (_isDataSubmitted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChiTietHoaDonScreen(
                                        donnhaphang: donnhaphang,
                                        allThongTinItemNhap:
                                            widget.allThongTinItemNhap,
                                      ), // Thay 'TrangKhac' bằng tên trang bạn muốn chuyển đến
                                    ),
                                    // (route) =>
                                    //     false, // Xóa hết tất cả các trang khỏi ngăn xếp
                                  );
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
      // Perform data processing
      // await controllerAddRepo.createDonNhapHang(
      //     donnhaphang, widget.allThongTinItemNhap);
      await controllerAddRepo.createExpired(widget.allThongTinItemNhap);
    } catch (e) {
      // print("Error: $e");
    }
  }
}
