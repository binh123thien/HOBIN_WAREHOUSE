import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/dotline/dotline.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/choose_location_phanphoi.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/widget/cardphanphoihang_widget.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/validate/formsoluong.dart';
import '../../../../../utils/validate/validate.dart';
import '../../../controllers/goods/chonhanghoale_controller.dart';
import 'donephanphoi.dart';

class ChonHangHoaLeScreen extends StatefulWidget {
  final Map<String, dynamic> locationSiGanNhat;
  final dynamic hanghoaLe;
  final dynamic hanghoaSi;
  const ChonHangHoaLeScreen({
    super.key,
    this.hanghoaLe,
    this.hanghoaSi,
    required this.locationSiGanNhat,
  });

  @override
  State<ChonHangHoaLeScreen> createState() => _ChonHangHoaLeScreenState();
}

class _ChonHangHoaLeScreenState extends State<ChonHangHoaLeScreen>
    with InputValidationMixin {
  final controllerHangHoa = Get.put(ChonHangHoaLeController());
  final controllerGoodRepo = Get.put(GoodRepository());
  late dynamic updatehanghoaSi;
  late dynamic updatehanghoaLe;
  bool isLocationLeLoaded = false;

  String hangHoaLeLocation = '';
  bool _isLoading = false; // Sử dụng biến này để kiểm soát hiển thị loading
  @override
  void initState() {
    super.initState();
    updatehanghoaSi = widget.hanghoaSi;
    updatehanghoaLe = widget.hanghoaLe;
  }

  @override
  Widget build(BuildContext context) {
    // TextFeild Controller lấy dữ liệu từ TextForm
    final textEditsoLuongLe = TextEditingController(
        text: updatehanghoaSi['chuyendoi'] != 0
            ? updatehanghoaSi['chuyendoi'].toString()
            : '');
    final textEditsoLuongSi = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text("Phân phối hàng hóa",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: whiteColor,
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: formKey,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 5),
                child: CardPhanPhoiHang(
                    locationSiGanNhat: widget.locationSiGanNhat,
                    soluong: RxInt(0),
                    phanBietSiLe: true,
                    slchuyendoi: 0,
                    imageProduct: updatehanghoaSi['photoGood'].isEmpty
                        ? hanghoaIcon
                        : updatehanghoaSi['photoGood'],
                    donViProduct: updatehanghoaSi['donvi'],
                    updatehanghoa: updatehanghoaSi),
              ),
              const Icon(
                Icons.arrow_downward_outlined,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
                child: CardPhanPhoiHang(
                    listPickedLocationLe:
                        controllerGoodRepo.listLocationHangHoaLePicked,
                    soluong: RxInt(0),
                    phanBietSiLe: false,
                    slchuyendoi: 0,
                    imageProduct: updatehanghoaLe['photoGood'].isEmpty
                        ? hanghoaIcon
                        : updatehanghoaLe['photoGood'],
                    donViProduct: updatehanghoaLe['donvi'],
                    updatehanghoa: updatehanghoaLe),
              ),
              PhanCachWidget.space(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChooseLocationPhanPhoiScreen(
                                hangHoaLe: widget.hanghoaLe,
                                locationUsed: controllerGoodRepo
                                    .listLocationHangHoaLePicked,
                              )),
                    ).then((value) {
                      if (value == null) {
                      } else if (value["id"] != null) {
                        setState(() {
                          hangHoaLeLocation = value["id"];
                        });
                      } else if (value["location"] != null) {
                        setState(() {
                          hangHoaLeLocation = value["location"];
                        });
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color:
                            hangHoaLeLocation.isEmpty ? darkColor : mainColor,
                        width: hangHoaLeLocation.isEmpty ? 0 : 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Row(children: [
                        const SizedBox(
                          width: 25,
                          height: 25,
                          child: Image(
                            image: AssetImage(locationIcon),
                            color: darkColor,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          hangHoaLeLocation.isEmpty
                              ? 'Chọn vị trí cho ${updatehanghoaLe['tensanpham']}'
                              : hangHoaLeLocation,
                          style: const TextStyle(
                            fontSize: 17,
                            color: darkColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          image: AssetImage(warningIcon),
                          height: 22,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Nhập chính xác số lượng đơn vị bán lẻ trên 1 đơn vị kiện hàng bán sỉ',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                    child: TextFormField(
                      controller: textEditsoLuongLe,
                      validator: (value) {
                        return nonZeroInput(value!);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          suffixText: "${updatehanghoaLe['donvi']}",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: const TextStyle(fontSize: 17),
                          labelText:
                              "1 ${updatehanghoaSi['donvi'].substring(0, 1).toUpperCase()}${updatehanghoaSi['donvi'].substring(1)} = ? ${updatehanghoaLe['donvi']}",
                          errorStyle: const TextStyle(fontSize: 15),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 1)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Nhập số lượng'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Image(
                          image: AssetImage(warningIcon),
                          height: 22,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Nhập số lượng ${updatehanghoaSi['donvi']} cần chuyển đổi',
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                    child: TextFormField(
                      controller: textEditsoLuongSi,
                      validator: (value) {
                        return nonZeroInput(value!);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaxValueTextInputFormatter(
                            widget.locationSiGanNhat["soluong"])
                      ],
                      decoration: InputDecoration(
                          suffixText: "${updatehanghoaSi['donvi']}",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: const TextStyle(fontSize: 17),
                          labelText: "Nhập số ${updatehanghoaSi['donvi']}",
                          errorStyle: const TextStyle(fontSize: 15),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 1)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Nhập số lượng'),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: mainColor,
                      side: BorderSide(
                          color: hangHoaLeLocation.isNotEmpty
                              ? mainColor
                              : Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: hangHoaLeLocation.isNotEmpty
                        ? () async {
                            Map<String, dynamic> foundLocationLe = {};
                            // Sử dụng phương thức where để lọc danh sách
                            List<Map<String, dynamic>> filteredLocationsLe =
                                controllerGoodRepo.listLocationHangHoaLePicked
                                    .where((locationMap) =>
                                        locationMap['location'] ==
                                        hangHoaLeLocation)
                                    .toList();
                            if (filteredLocationsLe.isNotEmpty) {
                              filteredLocationsLe = filteredLocationsLe
                                  .where((expMap) =>
                                      expMap['exp'] ==
                                      widget.locationSiGanNhat['exp'])
                                  .toList();
                              if (filteredLocationsLe.isNotEmpty) {
                                foundLocationLe = filteredLocationsLe.first;
                              } else {
                                foundLocationLe = {
                                  'exp': widget.locationSiGanNhat['exp'],
                                  'location': hangHoaLeLocation,
                                  'soluong': 0,
                                };
                              }
                            } else {
                              // Không tìm thấy
                              foundLocationLe = {
                                'exp': widget.locationSiGanNhat['exp'],
                                'location': hangHoaLeLocation,
                                'soluong': 0,
                              };
                            }

                            if (formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true; // Kích hoạt hiệu ứng loading
                              });
                              _performDataProcessing(textEditsoLuongLe,
                                      textEditsoLuongSi, foundLocationLe)
                                  .then((value) {
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            }
                          }
                        : null,
                    child: _isLoading
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ),
                          )
                        : const Text(
                            'Xác nhận',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performDataProcessing(
    TextEditingController textEditsoLuongLe,
    TextEditingController textEditsoLuongSi,
    Map<String, dynamic> foundLocationLe,
  ) async {
    String dateTao = formatNgaytao();
    // nhận giá trị chuyendoiLe trả về
    await controllerHangHoa
        .calculate(
      dateTao,
      int.parse(textEditsoLuongLe.text),
      int.parse(textEditsoLuongSi.text),
      updatehanghoaSi,
      updatehanghoaLe,
      widget.locationSiGanNhat,
      foundLocationLe,
    )
        .then((giaTriChuyenDoiLe) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: DonePhanPhoiScreen(
            locationSi: widget.locationSiGanNhat,
            locationLe: foundLocationLe,
            dateTao: dateTao,
            updatehanghoaSi: updatehanghoaSi,
            updatehanghoaLe: updatehanghoaLe,
            chuyendoiLe: giaTriChuyenDoiLe,
            chuyendoiSi: int.parse(textEditsoLuongSi.text.toString()),
          ),
        ),
      );
    });
  }
}
