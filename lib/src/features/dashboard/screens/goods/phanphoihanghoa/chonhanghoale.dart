import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/choose_location_phanphoi.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/goods/phanphoihanghoa/widget/cardphanphoihang_widget.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../utils/utils.dart';
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
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text("Phân phối hàng hóa",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
          backgroundColor: backGroundColor,
          centerTitle: true,
        ),
        backgroundColor: backGroundDefaultFigma,
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Column(children: [
                CardPhanPhoiHang(
                    locationSiGanNhat: widget.locationSiGanNhat,
                    soluong: RxInt(0),
                    phanBietSiLe: true,
                    slchuyendoi: 0,
                    imageProduct: updatehanghoaSi['photoGood'].isEmpty
                        ? hanghoaIcon
                        : updatehanghoaSi['photoGood'],
                    donViProduct: updatehanghoaSi['donvi'],
                    updatehanghoa: updatehanghoaSi),
                const Icon(
                  Icons.arrow_downward_outlined,
                ),
                CardPhanPhoiHang(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
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
                                ? 'Vị trí ${updatehanghoaLe['tensanpham']}'
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
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(warningIcon),
                              height: 30,
                            ),
                            Padding(padding: EdgeInsets.only(right: 10)),
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
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '1 ${updatehanghoaSi['donvi'].substring(0, 1).toUpperCase()}${updatehanghoaSi['donvi'].substring(1)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Text(
                              ' = ',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 135,
                              height: 35,
                              child: TextFormField(
                                autofocus: false,
                                controller: textEditsoLuongLe,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      backGroundSearch, // where is this color defined?
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  prefixIconColor: darkLiteColor,
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Nhập số lượng",
                                ),
                                validator: (value) {
                                  return nonZeroOrOneInput(value!);
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d{0,6}')),
                                ],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Text(
                              ' ${updatehanghoaLe['donvi']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(children: [
                          const Image(
                            image: AssetImage(warningIcon),
                            height: 30,
                          ),
                          const Padding(padding: EdgeInsets.only(right: 10)),
                          Expanded(
                            child: Text(
                              'Nhập số lượng ${updatehanghoaSi['donvi']} cần chuyển đổi',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 900,
                          height: 35,
                          child: TextFormField(
                            autofocus: false,
                            controller: textEditsoLuongSi,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  backGroundSearch, // where is this color defined?
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              prefixIconColor: darkLiteColor,
                              floatingLabelStyle:
                                  const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Nhập số lượng",
                            ),
                            validator: (value) {
                              return nonBeyondSi(
                                  value!, updatehanghoaSi['tonkho']);
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d{0,6}')),
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            height: 70,
            child: LayoutBuilder(
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
                              // Đã tìm thấy phần tử
                              foundLocationLe = filteredLocationsLe.first;
                              print(
                                  'if Đã tìm thấy location: $foundLocationLe');
                            } else {
                              // Không tìm thấy
                              foundLocationLe = {
                                'exp': widget.locationSiGanNhat['exp'],
                                'location': hangHoaLeLocation,
                                'soluong': 0,
                              };
                              print(
                                  'else Không tìm thấy location có giá trị "$hangHoaLeLocation"');
                            }
                            if (formKey.currentState!.validate()) {
                              String dateTao = formatNgaytao();
                              //nhận giá trị chuyendoiLe trả về
                              int giaTriChuyenDoiLe =
                                  await controllerHangHoa.calculate(
                                      dateTao,
                                      int.parse(textEditsoLuongLe.text),
                                      int.parse(textEditsoLuongSi.text),
                                      updatehanghoaSi,
                                      updatehanghoaLe,
                                      widget.locationSiGanNhat,
                                      foundLocationLe);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: DonePhanPhoiScreen(
                                    dateTao: dateTao,
                                    updatehanghoaSi: updatehanghoaSi,
                                    updatehanghoaLe: updatehanghoaLe,
                                    chuyendoiLe: giaTriChuyenDoiLe,
                                    chuyendoiSi: int.parse(
                                        textEditsoLuongSi.text.toString()),
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            )));
  }
}
