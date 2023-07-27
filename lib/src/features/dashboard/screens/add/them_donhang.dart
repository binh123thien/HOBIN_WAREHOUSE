import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dialog/dialog.dart';
import 'package:hobin_warehouse/src/common_widgets/willpopscope.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/add/taodonhang_controller.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/add/card_donhang_dachon_widget.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/Widget/appbar/appbar_backgroud_and_back.widget.dart';
import 'package:hobin_warehouse/src/repository/add_repository/add_repository.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';
import '../../controllers/add/chonhanghoa_controller.dart';
import '../../models/themdonhang_model.dart';
import 'chitietdonhang.dart';
import 'choose_khachhang.dart';
import 'widget/payment_radio.dart';
import 'widget/show_discount.dart';
import 'widget/show_no_widget.dart';
import 'widget/themdonhang/bottombar_thanhtoan.dart';
import 'widget/themdonhang/no_widget.dart';
import 'widget/themdonhang/thongtin_khachhang.dart';
import 'widget/themdonhang/total_price_widget.dart';

class ThemDonHangScreen extends StatefulWidget {
  final List<TextEditingController> slpick;
  const ThemDonHangScreen({super.key, required this.slpick});

  @override
  State<ThemDonHangScreen> createState() => _ThemDonHangScreenState();
}

class _ThemDonHangScreenState extends State<ThemDonHangScreen> {
  final controller = Get.put(ChonHangHoaController());
  final controllerTaoDonHang = Get.put(TaoDonHangController());
  final controllerAddRepo = Get.put(AddRepository());
  num disCount = 0;
  int paymentSelected = 0;
  String khachHangSelected = "Khách hàng";
  @override
  void initState() {
    super.initState();
    controller.loadAllHangHoa();
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

  void deleteKhachHang(String newKhachHangSelected) {
    setState(() {
      khachHangSelected = newKhachHangSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.allHangHoaFireBase.isEmpty) {
      return const Scaffold(
        appBar: AppBarBGBack(
          phanBietNhatXuat: 0,
          title: 'Thêm đơn hàng',
        ),
        body: Center(child: Text("Chưa có hàng hóa!\nBạn cần thêm hàng hóa")),
      );
    } else {
      int phanbietNhapXuat = 0;

      //Nếu không thể chuyển đổi chuỗi thành số nguyên, thì giá trị mặc định sẽ là 0.
      num no = num.tryParse(controllerTaoDonHang.noController.text) ?? 0;
      num sumPrice = 0;
      //tinh tong gia tien khi chon
      for (int i = 0; i < controller.allHangHoaFireBase.length; i++) {
        widget.slpick[i].text =
            controller.allHangHoaFireBase[i]["soluong"].toString();
        sumPrice = int.parse(widget.slpick[i].text) *
                controller.allHangHoaFireBase[i]["giaban"] +
            sumPrice;
      }
      //tinh tong item
      int sumItem = 0;
      for (var i = 0; i < widget.slpick.length; i++) {
        sumItem += int.parse(widget.slpick[i].text);
      }
      void updateSumItem(int newSumItem) {
        setState(() {
          sumItem = newSumItem;
        });
      }

      void updateNo(num newNo) {
        setState(() {
          no = newNo;
        });
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
              sumPrice: sumPrice,
              phanbietNhapXuat: phanbietNhapXuat,
            );
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
              sumPrice: sumPrice,
              phanbietNhapXuat: phanbietNhapXuat,
            );
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

      return ExitConfirmationDialog(
          message: 'Bạn muốn thoát trang thêm đơn hàng?',
          onConfirmed: () {
            Navigator.of(context).pop(); // Đóng dialog và trả về giá trị false
            //Đóng bottomsheet
            Navigator.of(context).pop();
          },
          dialogChild: Scaffold(
              appBar: const AppBarBGBack(
                phanBietNhatXuat: 0,
                title: 'Thêm đơn hàng',
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
                      const SizedBox(height: 8),
                      CardItemBanHangDaChon(
                        phanbietNhapXuat: phanbietNhapXuat,
                        allHangHoa: controller.allHangHoaFireBase,
                        sumItem: sumItem,
                        // onUpdateSumItem: updateSumItem,
                      ),
                      TotalPriceWidget(
                        phanbietNhapXuat: phanbietNhapXuat,
                        sumItem: sumItem,
                        disCount: disCount,
                        sumPrice: sumPrice,
                        showDiscount: _showDiscount,
                      ),
                      NoWidget(
                        no: no,
                        onTapShowNo: _showNo,
                        phanbietNhapXuat: phanbietNhapXuat,
                      ),
                    ]),
              ),
              bottomNavigationBar: BottomBarThanhToan(
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
                      final bHcode = generateBHCode();
                      final ngaytao = formatNgaytao();
                      final datetime = formatDatetime();

                      final donbanhang = ThemDonHangModel(
                        datetime: datetime,
                        soHD: bHcode,
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
                        billType: 'BanHang',
                      );
                      controllerAddRepo.createDonBanHang(
                          donbanhang, filteredList);
                      controllerAddRepo.createTongDoanhThuNgay(
                          datetime, sumPrice - disCount - no, no);
                      controllerAddRepo.createTongDoanhThuTuan(
                          datetime, sumPrice - disCount - no, no);
                      controllerAddRepo.createTongDoanhThuThang(
                          datetime, sumPrice - disCount - no, no);
                      // Đóng dialog hiện tại (nếu có)
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChiTietHoaDonNew(
                            //biến model từ dạng instance vè json
                            model: donbanhang.toJson(),
                            maHD: bHcode,
                            date: ngaytao,
                            sumPrice: sumPrice,
                            disCount: disCount,
                            sumItem: sumItem,
                            no: no,
                            paymentSelected: paymentSelected,
                            phanbietNhapXuat: phanbietNhapXuat,
                            khachhang: khachHangSelected,
                            billType: 'BanHang',
                          ),
                        ),
                      ).then((value) {
                        setState(() {
                          paymentSelected = 0;
                          controller.allHangHoaFireBase = value;
                          controllerTaoDonHang.noController.clear();
                          controllerTaoDonHang.giamgiaController.clear();
                          disCount = 0;
                        });
                      });
                    });
                  }
                },
                onTapPaynemtSelection: _showHinhThucThanhToan,
                phanbietNhapXuat: phanbietNhapXuat,
              )));
    }
  }
}
