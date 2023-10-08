import 'package:flutter/material.dart';
import '../../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../../constants/color.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../utils/validate/formsoluong.dart';
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
  TextEditingController giaHetHanController = TextEditingController();
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
                    inputFormatters: [MaxValueTextInputFormatter(totalPrice)],
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChiTietHoaDonScreen(
                              donnhaphang: donhethan,
                              allThongTinItemNhap: widget.selectedItemsHetHan,
                              phanbietNhapXuat: 'HetHan',
                            ), // Thay 'TrangKhac' bằng tên trang bạn muốn chuyển đến
                          ),
                          // (route) =>
                          //     false, // Xóa hết tất cả các trang khỏi ngăn xếp
                        );
                      }
                    },
                    child: const Text(
                      'Xác nhận xuất kho',
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                );
              }),
            ],
          ),
        ));
  }
}
