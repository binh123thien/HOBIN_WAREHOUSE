import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dialog/dialog.dart';
import 'package:hobin_warehouse/src/common_widgets/willpopscope.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/chonhanghoa_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/nhaphang_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/add/card_donhang_dachon_widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/appbar/appbar_backgroud_and_back.widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/add/widget/themdonhang/thongtin_khachhang.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';

import '../../../../repository/add_repository/add_repository.dart';
import '../../models/themdonhang_model.dart';
import 'choose_goods.dart';
import 'chitietdonhang.dart';
import 'choose_khachhang.dart';
import 'widget/payment_radio.dart';
import 'widget/show_discount.dart';
import 'widget/show_no_widget.dart';
import 'widget/themdonhang/bottombar_thanhtoan.dart';
import 'widget/themdonhang/no_widget.dart';
import 'widget/themdonhang/themsanpham_widget.dart';
import 'widget/themdonhang/total_price_widget.dart';

class NhapHangScreen extends StatefulWidget {
  const NhapHangScreen({super.key});

  @override
  State<NhapHangScreen> createState() => _NhapHangScreenState();
}

class _NhapHangScreenState extends State<NhapHangScreen> {
  final controller = Get.put(ChonHangHoaController());
  final controllerNhapHang = Get.put(NhapHangController());
  final controllerAddRepo = Get.put(AddRepository());
  List<TextEditingController> _controllers = [];
  num disCount = 0;
  int paymentSelected = 0;
  String khachHangSelected = "Nhà cung cấp";
  @override
  void initState() {
    super.initState();
    controller.loadAllHangHoa();
    _controllers = List.generate(
        controller.allHangHoaFireBase.length, (_) => TextEditingController());
  }

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

  @override
  Widget build(BuildContext context) {
    if (controller.allHangHoaFireBase.isEmpty) {
      return const Scaffold(
        appBar: AppBarBGBack(
          title: 'Nhập hàng',
        ),
        body: Center(child: Text("Chưa có hàng hóa!\nBạn cần thêm hàng hóa")),
      );
    } else {
      int phanbietNhapXuat = 1;

      num no = num.tryParse(controllerNhapHang.noNhapHangController.text) ?? 0;
      num sumPrice = 0;
      //tinh tong gia tien khi chon
      for (int i = 0; i < controller.allHangHoaFireBase.length; i++) {
        _controllers[i].text =
            controller.allHangHoaFireBase[i]["soluong"].toString();
        sumPrice = int.parse(_controllers[i].text) *
                controller.allHangHoaFireBase[i]["gianhap"] +
            sumPrice;
      }
      //tinh tong item
      int sumItem = 0;
      for (var i = 0; i < _controllers.length; i++) {
        sumItem += int.parse(_controllers[i].text);
      }
      void updateSumItem(int newSumItem) {
        setState(() {
          sumItem = newSumItem;
        });
      }

      void deleteKhachHang(String newKhachHangSelected) {
        setState(() {
          khachHangSelected = newKhachHangSelected;
        });
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

      return ExitConfirmationDialog(
          message: "Bạn muốn thoát trang nhập hàng?",
          onConfirmed: () {
            Navigator.of(context).pop(); // Đóng dialog và trả về giá trị false
            //Đóng bottomsheet
            Navigator.of(context).pop();
          },
          dialogChild: Scaffold(
              appBar: const AppBarBGBack(
                title: 'Nhập hàng',
              ),
              body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ThongTinKhachHang(
                        showKhachHang: _showKhachHang,
                        phanbietNhapXuat: phanbietNhapXuat,
                        khachHangSelected: khachHangSelected,
                        onDeleteKhachhang: deleteKhachHang,
                      ),
                      ThemSanPhamWidget(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseGoodsScreen(
                                  controllers: _controllers,
                                  phanbietNhapXuat: phanbietNhapXuat),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        onPressedScan: () async {
                          await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666", // Màu hiển thị của app
                            "Hủy bỏ", // Chữ hiển thị cho nút hủy bỏ
                            true, // Cho phép Async? (có hay không)
                            ScanMode.BARCODE, // Hình thức quét
                          );
                          if (!mounted) return;
                        },
                        phanbietNhapXuat: phanbietNhapXuat,
                      ),
                      const SizedBox(height: 8),
                      CardItemBanHangDaChon(
                        phanbietNhapXuat: phanbietNhapXuat,
                        allHangHoa: controller.allHangHoaFireBase,
                        controllerSoluong: _controllers,
                        sumItem: sumItem,
                        onUpdateSumItem: updateSumItem,
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
                  List<dynamic> filteredList = controller.allHangHoaFireBase
                      .where((element) => element["soluong"] > 0)
                      .toList();
                  if (filteredList.isEmpty) {
                    MyDialog.showAlertDialogOneBtn(
                        context,
                        'Giỏ hàng đang trống',
                        'Vui lòng kiểm tra lại đơn hàng');
                  } else {
                    MyDialog.showAlertDialog(context, 'Xác nhận thanh toán',
                        'Vui lòng kiểm tra đơn hàng trước khi thanh toán', () {
                      final nHcode = generateNHCode();
                      final ngaytao = formatNgaytao();
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
                      ).then((value) {
                        setState(() {
                          paymentSelected = 0;
                          controller.allHangHoaFireBase = value;
                          controllerNhapHang.giamgiaNhapHangController.clear();
                          controllerNhapHang.noNhapHangController.clear();
                          disCount = 0;
                        });
                      });
                    });
                  }
                },
                onTapPaynemtSelection: _showHinhThucThanhToan,
              )));
    }
  }
}
