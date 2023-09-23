import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dialog/dialog.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/nhaphang_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/taodonhang_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/add/card_donhang_dachon_widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/appbar/appbar_backgroud_and_back.widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/widget/themdonhang/thongtin_khachhang.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';

import '../../../../repository/add_repository/add_repository.dart';
import '../../models/themdonhang_model.dart';
import 'chitietdonhang.dart';
import 'choose_khachhang.dart';
import 'widget/payment_radio.dart';
import 'widget/show_discount.dart';
import 'widget/show_no_widget.dart';
import 'widget/themdonhang/bottombar_thanhtoan.dart';
import 'widget/themdonhang/no_widget.dart';
import 'widget/themdonhang/total_price_widget.dart';

class NhapHangScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dulieuPicked;
  const NhapHangScreen({super.key, required this.dulieuPicked});

  @override
  State<NhapHangScreen> createState() => _NhapHangScreenState();
}

class _NhapHangScreenState extends State<NhapHangScreen> {
  final controllerNhapHang = Get.put(NhapHangController());
  final controllerAddRepo = Get.put(AddRepository());
  final controllerBanHang = Get.put(TaoDonHangController());

  num disCount = 0;
  int paymentSelected = 0;
  String khachHangSelected = "Nhà cung cấp";

  void updateDiscount(num newDiscount) {
    setState(() {
      disCount = newDiscount;
    });
  }

  void updatePaymentSelected(int newPayment) {
    setState(() {
      paymentSelected = newPayment;
    });
  }

  void updateKhachHangSelected(String newkhachhang) {
    setState(() {
      khachHangSelected = newkhachhang;
    });
  }

  void deleteKhachHang(String newKhachHangSelected) {
    setState(() {
      khachHangSelected = newKhachHangSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dulieuPicked.isEmpty) {
      return const Scaffold(
        appBar: AppBarBGBack(
          phanBietNhatXuat: 1,
          title: tNhapHangHoa,
        ),
        body: Center(
            child: Text(
                "           Chưa có hàng hóa!\nBạn cần thêm hàng hóa vào giỏ")),
      );
    } else {
      //nhập hàng
      int phanbietNhapXuat = 1;

      num no = num.tryParse(controllerNhapHang.noNhapHangController.text) ?? 0;

      //tinh tong item
      int sumItem = 0;
      num sumPrice = 0;
      //tinh tong gia tien khi chon
      for (int i = 0; i < widget.dulieuPicked.length; i++) {
        //tính tiền
        sumPrice = widget.dulieuPicked[i]['soluong'] *
                widget.dulieuPicked[i]["gianhap"] +
            sumPrice;

        sumItem += int.parse(widget.dulieuPicked[i]['soluong'].toString());
      }

      void updateNo(num newNo) {
        setState(() {
          no = newNo;
        });
      }

      Future<void> _showKhachHang() async {
        String? result = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            return ChooseKhachHangScreen(
                khachHangSelected: khachHangSelected,
                phanbietNhapXuat: phanbietNhapXuat);
          },
        );
        if ((result != null)) {
          updateKhachHangSelected(result);
        }
      }

      Future<void> _showDiscount() async {
        num? result = await showModalBottomSheet<num>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            return ShowDiscount(
                sumPrice: sumPrice, phanbietNhapXuat: phanbietNhapXuat);
          },
        );
        if (result != null) {
          updateDiscount(result);
        }
      }

      Future<void> _showNo() async {
        num? result = await showModalBottomSheet<num>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            return ShowNo(
                sumPrice: sumPrice, phanbietNhapXuat: phanbietNhapXuat);
          },
        );
        if (result != null) {
          updateNo(result);
        }
      }

      Future<void> _showHinhThucThanhToan() async {
        int? result = await showModalBottomSheet<int>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            return PaymentRadio(paymentSelected: paymentSelected);
          },
        );
        if ((result != null)) {
          updatePaymentSelected(result);
        }
      }

      return Scaffold(
          appBar: const AppBarBGBack(
            phanBietNhatXuat: 1,
            title: tNhapHangHoa,
          ),
          body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ThongTinKhachHang(
                showKhachHang: _showKhachHang,
                phanbietNhapXuat: phanbietNhapXuat,
                khachHangSelected: khachHangSelected,
                onDeleteKhachhang: deleteKhachHang,
              ),
              const SizedBox(height: 8),
              CardItemBanHangDaChon(
                phanbietNhapXuat: phanbietNhapXuat,
                hangHoaPicked: widget.dulieuPicked,
                sumItem: sumItem,
              ),
              TotalPriceWidget(
                phanbietNhapXuat: phanbietNhapXuat,
                sumItem: sumItem,
                disCount: disCount,
                sumPrice: sumPrice,
                showDiscount: _showDiscount,
              ),
              NoWidget(
                phanbietNhapXuat: phanbietNhapXuat,
                no: no,
                onTapShowNo: _showNo,
              ),
            ]),
          ),
          bottomNavigationBar: BottomBarThanhToan(
            phanbietNhapXuat: phanbietNhapXuat,
            sumPrice: sumPrice,
            disCount: disCount,
            no: no,
            paymentSelected: paymentSelected,
            onPressedThanhToan: () {
              if (widget.dulieuPicked.isEmpty) {
                MyDialog.showAlertDialogOneBtn(context, 'Giỏ hàng đang trống',
                    'Vui lòng kiểm tra lại đơn hàng');
              } else {
                MyDialog.showAlertDialog(
                  context,
                  'Xác nhận thanh toán',
                  'Vui lòng kiểm tra đơn hàng trước khi thanh toán',
                  phanbietNhapXuat,
                  () {
                    controllerBanHang.giamgiaController.clear();
                    controllerNhapHang.noNhapHangController.clear();
                    final nHcode = generateNHCode();
                    final ngaytao = formatNgayTao();
                    final datetime = formatDatetime();

                    final donnhaphang = ThemDonHangModel(
                      soHD: nHcode,
                      ngaytao: ngaytao,
                      khachhang: khachHangSelected,
                      payment: paymentSelected == 0
                          ? "Tiền mặt"
                          : paymentSelected == 1
                              ? "Chuyển khoản"
                              : "Ví điện tử",
                      tongsl: sumItem,
                      tongtien: sumPrice,
                      giamgia: disCount,
                      no: no,
                      trangthai: no == 0 ? "Thành công" : "Đang chờ",
                      tongthanhtoan: sumPrice - disCount - no,
                      billType: 'NhapHang',
                      datetime: datetime,
                    );
                    controllerAddRepo.createDonNhapHang(donnhaphang);
                    for (int i = 0; i < widget.dulieuPicked.length; i++) {
                      controllerAddRepo.createLocation(widget.dulieuPicked[i]);
                    }
                    // Đóng dialog hiện tại (nếu có)
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChiTietHoaDonNew(
                          model: donnhaphang.toJson(),
                          phanbietNhapXuat: phanbietNhapXuat,
                          maHD: nHcode,
                          date: ngaytao,
                          sumPrice: sumPrice,
                          disCount: disCount,
                          sumItem: sumItem,
                          no: no,
                          paymentSelected: paymentSelected,
                          khachhang: khachHangSelected,
                          billType: 'NhapHang',
                        ),
                      ),
                    );
                  },
                );
              }
            },
            onTapPaynemtSelection: _showHinhThucThanhToan,
          ));
    }
  }
}
