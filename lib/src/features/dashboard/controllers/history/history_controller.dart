import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common_widgets/snackbar/toast.dart';
import '../../../../repository/add_repository/nhaphang/nhaphang_repository.dart';
import '../../../../repository/add_repository/xuathang/xuathang_repository.dart';
import '../../../../repository/history_repository/hethan_history_repository.dart';
import '../../../../repository/history_repository/history_repository.dart';
import '../add/chonhanghoa_controller.dart';

class HistoryController extends GetxController {
  static HistoryController get instance => Get.find();
  final controllerHistoryRepo = Get.put(HistoryRepository());
  final controllerNhapHangRepo = Get.put(NhapHangRepository());
  final controllerXuatHangRepo = Get.put(XuatHangRepository());
  final controllerHetHanHistoryRepo = Get.put(HetHanHistoryRepository());
  final controller = Get.put(ChonHangHoaController());
  List<dynamic> docHangThang = [].obs;
  List<dynamic> sanPhamTrongHoaDon = [].obs;
  RxDouble tongNhapHang = 0.0.obs;
  RxDouble tongBanHang = 0.0.obs;
  RxDouble soluongtonkho = 0.0.obs;
  RxDouble giatritonkho = 0.0.obs;

  loadPhiNhapHangTrongThang(String loaiNhapHoacBanHang) async {
    await controllerHistoryRepo
        .getAllDonBanHangHoacNhapHang(loaiNhapHoacBanHang)
        .listen((snapshot) {
      docHangThang = snapshot.docs.map((doc) => doc.data()).toList();
      List filteredDocs = docHangThang.where((doc) {
        DateTime datetime = DateFormat('dd-MM-yyyy').parse(doc['datetime']);
        return datetime.month == DateTime.now().month;
      }).toList();

      double totalTongTien = 0;
      for (var doc in filteredDocs) {
        double? tongTien = double.tryParse(doc['tongthanhtoan'].toString());
        totalTongTien += tongTien!;
      }
      if (loaiNhapHoacBanHang == "XuatHang") {
        tongBanHang.value = totalTongTien;
      } else if (loaiNhapHoacBanHang == "NhapHang") {
        tongNhapHang.value = totalTongTien;
      }
      double sltonkho = 0;
      for (var item in controller.allHangHoaFireBase) {
        sltonkho += item["tonkho"];
      }
      soluongtonkho.value = sltonkho;
      final double gtritonkho = controller.allHangHoaFireBase
          .fold(0, (sum, item) => sum + item['gianhap'] * item['tonkho']);
      giatritonkho.value = gtritonkho;
    });
  }

  findHoaDon(String soHD, String billType, num doanhthu, String datetime,
      String trangthai) async {
    await controllerHistoryRepo
        .getAllSanPhamTrongHoaDon(
            soHD,
            billType == "HetHan" || billType == "XuatHang"
                ? "XuatHang"
                : "NhapHang")
        .listen((snapshot) async {
      List<dynamic> sanPhamTrongHoaDon =
          snapshot.docs.map((doc) => doc.data()).toList();
      if (sanPhamTrongHoaDon.isEmpty) {
        ToastWidget.showToast("Lỗi sản phẩm không có trong kho");
      }
      if (billType == "HetHan") {
        // cập nhật ngày hết hạn
        await controllerNhapHangRepo.createExpired(sanPhamTrongHoaDon);
        //tra hang lai kho
        await controllerNhapHangRepo.createHangHoaExpired(sanPhamTrongHoaDon);
        //tăng giá trị tồn kho
        await controllerNhapHangRepo
            .capNhatGiaTriTonKhoNhapHang(sanPhamTrongHoaDon);
        //giam gia tri đã bán
        await controllerXuatHangRepo.giamGiaTriDaBan(sanPhamTrongHoaDon);

        //tinh tong doanh thu
        await controllerXuatHangRepo.truTongDoanhThuNgay(
            datetime, doanhthu, trangthai);
        await controllerXuatHangRepo.truTongDoanhThuTuan(
            datetime, doanhthu, trangthai);
        await controllerXuatHangRepo.truTongDoanhThuThang(
            datetime, doanhthu, trangthai);
        //cap nhat trang thai don hang
        await controllerHetHanHistoryRepo.updateTrangThaiHuy(billType, soHD);
      } else if (billType == "NhapHang") {
        //xuat kho và tính lại tồn kho & update trạng thái hủy
        await controllerNhapHangRepo.xuatkhoNhapHangHangHoaExpired(
            sanPhamTrongHoaDon, soHD, billType);
      } else if (billType == "XuatHang") {
        print(sanPhamTrongHoaDon);
        // cập nhật ngày hết hạn
        await controllerHetHanHistoryRepo
            .createHuyDonExpired(sanPhamTrongHoaDon);
        //
      }
    });
  }
}
